#!/usr/bin/env bash
# State for the quick settings panel, one line each:
#   wifi <on|off|none> [network name]
#   bluetooth <on|off|none>
#   volume <0..1>
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

if command -v wpctl >/dev/null 2>&1; then
  vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2}')
  echo "volume ${vol:-0.5}"
else
  echo "volume 0.5"
fi
