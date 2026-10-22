#!/usr/bin/env bash
# State for the quick settings panel, one line each:
#   wifi <on|off|none> [network name]
#   bluetooth <on|off|none>
#   dnd <on|off>
#   volume <0..1|none>
#   brightness <0..1|none>
# Anything that cannot be read is reported as "none".

if command -v nmcli >/dev/null 2>&1; then
  radio=$(nmcli radio wifi 2>/dev/null)
  if [ "$radio" = "enabled" ]; then
    ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1 == "yes" {print $2; exit}')
    echo "wifi on $ssid"
  elif [ "$radio" = "disabled" ]; then
    echo "wifi off"
  else
    echo "wifi none"
  fi
else
  echo "wifi none"
fi

if command -v bluetoothctl >/dev/null 2>&1; then
  powered=$(bluetoothctl show 2>/dev/null | awk '/Powered:/ {print $2; exit}')
  case "$powered" in
    yes) echo "bluetooth on" ;;
    no) echo "bluetooth off" ;;
    *) echo "bluetooth none" ;;
  esac
else
  echo "bluetooth none"
fi

until=$(kreadconfig6 --file plasmanotifyrc --group DoNotDisturb --key Until 2>/dev/null)
if [ -n "$until" ]; then echo "dnd on"; else echo "dnd off"; fi

vol=""
if command -v wpctl >/dev/null 2>&1; then
  out=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
  if [ -n "$out" ]; then
    vol=$(echo "$out" | awk '{print $2}')
    case "$out" in *MUTED*) vol="0.00" ;; esac
  fi
fi
if [ -z "$vol" ] && command -v pactl >/dev/null 2>&1; then
  pct=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | head -1 | grep -o '[0-9]*%' | head -1 | tr -d '%')
  [ -n "$pct" ] && vol=$(awk -v p="$pct" 'BEGIN {printf "%.2f", p / 100}')
fi
echo "volume ${vol:-none}"

if command -v brightnessctl >/dev/null 2>&1; then
  pct=$(brightnessctl -m 2>/dev/null | awk -F, 'NR==1 {gsub("%", "", $4); print $4}')
  if [ -n "$pct" ]; then
    awk -v p="$pct" 'BEGIN {printf "brightness %.2f\n", p / 100}'
  else
    echo "brightness none"
  fi
else
  echo "brightness none"
fi
