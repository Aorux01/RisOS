#!/usr/bin/env bash
# Install Figtree (OFL) system-wide.
set -euxo pipefail

dest=/usr/share/fonts/figtree
mkdir -p "$dest"
base=https://raw.githubusercontent.com/google/fonts/main/ofl/figtree
curl -fsSL "$base/Figtree%5Bwght%5D.ttf" -o "$dest/Figtree[wght].ttf"
curl -fsSL "$base/Figtree-Italic%5Bwght%5D.ttf" -o "$dest/Figtree-Italic[wght].ttf"
curl -fsSL "$base/OFL.txt" -o "$dest/OFL.txt"
fc-cache -f "$dest"
