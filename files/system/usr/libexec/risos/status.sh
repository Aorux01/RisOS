#!/usr/bin/env bash
# Print the battery and network state for the shell, one line each:
#   battery <percent|none> <status>
#   net <none|wifi|wired> <wifi level 0..3>
# Anything that cannot be read is reported as "none".

bat="none"
for b in /sys/class/power_supply/BAT*; do
  if [ -r "$b/capacity" ]; then
    bat="$(cat "$b/capacity") $(cat "$b/status" 2>/dev/null)"
    break
  fi
done
echo "battery $bat"

kind="none"
level=0
wireless=$(awk 'NR>2 {gsub(":", "", $1); print $1, $3}' /proc/net/wireless 2>/dev/null)

for dir in /sys/class/net/*; do
  i=$(basename "$dir")
  case "$i" in
    lo|veth*|docker*|virbr*|br-*|tun*|tap*|vnet*|podman*|cni*) continue ;;
  esac
  [ "$(cat "$dir/operstate" 2>/dev/null)" = "up" ] || continue

  q=$(echo "$wireless" | awk -v n="$i" '$1 == n {print $2}')
  if [ -n "$q" ]; then
    kind="wifi"
    q=${q%.*}
    if [ "$q" -ge 45 ]; then level=3; elif [ "$q" -ge 25 ]; then level=2; elif [ "$q" -gt 0 ]; then level=1; else level=0; fi
  elif [ "$kind" != "wifi" ]; then
    kind="wired"
  fi
done
echo "net $kind $level"
