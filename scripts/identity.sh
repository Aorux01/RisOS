#!/usr/bin/env bash
# Donne son nom à l'image. On garde ID=fedora pour ne rien casser (comme Bazzite / Aurora).
set -euo pipefail

VERSION="$(cat /usr/share/risos/VERSION)"

sed -i \
  -e "s|^NAME=.*|NAME=\"RisOS\"|" \
  -e "s|^PRETTY_NAME=.*|PRETTY_NAME=\"RisOS ${VERSION}\"|" \
  -e "s|^VARIANT=.*|VARIANT=\"RisOS\"|" \
  /usr/lib/os-release

grep -q '^VARIANT_ID=' /usr/lib/os-release \
  && sed -i 's|^VARIANT_ID=.*|VARIANT_ID=risos|' /usr/lib/os-release \
  || echo 'VARIANT_ID=risos' >> /usr/lib/os-release

grep -q '^VARIANT=' /usr/lib/os-release || echo 'VARIANT="RisOS"' >> /usr/lib/os-release
