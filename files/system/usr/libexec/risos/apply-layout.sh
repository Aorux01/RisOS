#!/usr/bin/env bash
# Apply the RisOS panel layout (top bar and floating dock) to the running Plasma session.
# Uses busctl (part of systemd), so it needs no extra package.
#   --restart-shell   restart plasmashell first (needed after adding or changing a plasmoid)
set -uo pipefail

# Panel and menu theme (flat top bar, rounded floating dock).
plasma-apply-desktoptheme RisOS || true

if [ "${1:-}" = "--restart-shell" ]; then
  systemctl --user restart plasma-plasmashell.service || true
  sleep 3
fi

# Wait for plasmashell to be reachable on the session bus.
for _ in $(seq 60); do
  busctl --user status org.kde.plasmashell >/dev/null 2>&1 && break
  sleep 1
done

busctl --user call org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell evaluateScript s "$(cat /usr/share/risos/layout.js)"
