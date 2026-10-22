#!/usr/bin/env bash
# Set up the panels of the running Plasma session.
#
# With Quickshell installed, the RisOS shell (top bar and dock, see /usr/share/risos/shell) draws
# them, so Plasma's own panels are removed. Without it, fall back to a styled Plasma layout so the
# desktop is never left without a bar.
#   --plasma          force the Plasma layout
#   --restart-shell   restart plasmashell first (needed after adding or changing a plasmoid)
set -uo pipefail

use_plasma=0
restart=0
for arg in "$@"; do
  case "$arg" in
    --plasma) use_plasma=1 ;;
    --restart-shell) restart=1 ;;
  esac
done
command -v quickshell >/dev/null 2>&1 || use_plasma=1

# Panel and menu theme (used by the Plasma layout).
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

if [ "$use_plasma" = 1 ]; then
  script="$(cat /usr/share/risos/layout.js)"
else
  script='var p = panels(); for (var i = 0; i < p.length; i++) { p[i].remove(); }'
fi

busctl --user call org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell evaluateScript s "$script"
