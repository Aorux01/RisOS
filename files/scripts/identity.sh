#!/usr/bin/env bash
# Give the image its name. Keep ID=fedora so nothing breaks (like Bazzite / Aurora).
set -euxo pipefail

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

# Logo shown in About (risos-logo icon, installed in hicolor).
grep -q '^LOGO=' /usr/lib/os-release \
  && sed -i 's|^LOGO=.*|LOGO=risos-logo|' /usr/lib/os-release \
  || echo 'LOGO=risos-logo' >> /usr/lib/os-release
