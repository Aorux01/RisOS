#!/usr/bin/env bash
# Install Figtree (interface) and JetBrains Mono (terminal), both OFL, system-wide.
set -euxo pipefail

dest=/usr/share/fonts/figtree
mkdir -p "$dest"
base=https://raw.githubusercontent.com/google/fonts/main/ofl/figtree
curl -fsSL "$base/Figtree%5Bwght%5D.ttf" -o "$dest/Figtree[wght].ttf"
curl -fsSL "$base/Figtree-Italic%5Bwght%5D.ttf" -o "$dest/Figtree-Italic[wght].ttf"
curl -fsSL "$base/OFL.txt" -o "$dest/OFL.txt"

# The terminal font is a nicety: if the download fails, Konsole falls back to the default monospace font.
mono=/usr/share/fonts/jetbrains-mono
mkdir -p "$mono"
mbase=https://raw.githubusercontent.com/google/fonts/main/ofl/jetbrainsmono
(curl -fsSL "$mbase/JetBrainsMono%5Bwght%5D.ttf" -o "$mono/JetBrainsMono[wght].ttf"   && curl -fsSL "$mbase/JetBrainsMono-Italic%5Bwght%5D.ttf" -o "$mono/JetBrainsMono-Italic[wght].ttf"   && curl -fsSL "$mbase/OFL.txt" -o "$mono/OFL.txt") || echo "JetBrains Mono not installed"

fc-cache -f "$dest" "$mono"
