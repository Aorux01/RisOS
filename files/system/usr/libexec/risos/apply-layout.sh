#!/usr/bin/env bash
# Apply the RisOS panel layout (top bar and floating dock) to the running Plasma session.
set -uo pipefail

qdbus=$(command -v qdbus6 || command -v qdbus)

# Wait for plasmashell to be reachable on D-Bus.
for _ in $(seq 60); do
  "$qdbus" org.kde.plasmashell /PlasmaShell >/dev/null 2>&1 && break
  sleep 1
done

"$qdbus" org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "$(cat /usr/share/risos/layout.js)"
