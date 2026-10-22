#!/usr/bin/env bash
# Apply the RisOS panel layout (top bar and floating dock) to the running Plasma session.
# Uses busctl (part of systemd), so it needs no extra package.
set -uo pipefail

# Wait for plasmashell to be reachable on the session bus.
for _ in $(seq 60); do
  busctl --user status org.kde.plasmashell >/dev/null 2>&1 && break
  sleep 1
done

busctl --user call org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell evaluateScript s "$(cat /usr/share/risos/layout.js)"
