#!/usr/bin/env bash
# Dev loop for a running RisOS VM: pull the latest files/system from GitHub and apply it
# right away, without waiting for an image build.
#
# Works for anything that does not need a rebuild: the SDDM theme, color schemes, wallpapers,
# config in /etc. It does not cover the Plymouth theme (it lives in the initramfs) or packages.
# The changes live in a temporary overlay on /usr and disappear at the next reboot, when the
# real image takes over again.
#
# Usage (inside the VM):  bash dev-sync.sh [--restart-sddm]
set -euo pipefail

repo=Aorux01/RisOS
branch=main

# Make /usr writable (temporary). Fails harmlessly if it is already unlocked.
sudo rpm-ostree usroverlay 2>/dev/null || true

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "https://codeload.github.com/$repo/tar.gz/refs/heads/$branch" | tar -xz -C "$tmp"
src="$tmp/${repo#*/}-$branch/files/system"

sudo cp -rT "$src/usr/share" /usr/share
sudo cp -rT "$src/etc" /etc
echo "Applied files/system from $repo@$branch."

if [ "${1:-}" = "--restart-sddm" ]; then
  echo "Restarting SDDM (this logs you out)..."
  sudo systemctl restart sddm
fi
