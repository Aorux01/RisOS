#!/usr/bin/env bash
# Set up the one Plasma panel RisOS keeps: a transparent strip that shows the application menus
# in the top bar (see /usr/share/risos/menu-panel.js). The bar, the dock and the popups are drawn
# by the RisOS shell (Quickshell, /usr/share/risos/shell).
#   --restart-shell   restart plasmashell first
set -uo pipefail

restart=0
for arg in "$@"; do
  [ "$arg" = "--restart-shell" ] && restart=1
done

# Transparent panel background.
plasma-apply-desktoptheme RisOS || true

if [ "$restart" = 1 ]; then
  systemctl --user restart plasma-plasmashell.service || true
  sleep 3
fi

# Wait for plasmashell to be reachable on the session bus.
for _ in $(seq 60); do
  busctl --user status org.kde.plasmashell >/dev/null 2>&1 && break
  sleep 1
done

busctl --user call org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell evaluateScript s "$(cat /usr/share/risos/menu-panel.js)"
