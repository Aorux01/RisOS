#!/usr/bin/env bash
# Render the Plymouth theme images from the RisOS logo and Figtree, then enable the theme.
set -euxo pipefail

theme=/usr/share/plymouth/themes/risos
cd "$theme"

# Everything is drawn at 2x the 2000x1250 reference layout.
svg() { # name width height body
  rsvg-convert -o "$1.png" <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="$2" height="$3" viewBox="0 0 $2 $3">$4</svg>
SVG
}
text() { # name width height size weight color anchor x text
  svg "$1" "$2" "$3" "<text x=\"$8\" y=\"$(( $3 * 3 / 4 ))\" font-family=\"Figtree\" font-size=\"$4\" font-weight=\"$5\" fill=\"$6\" text-anchor=\"$7\">$9</text>"
}

# Logo: the app-icon version of the glyph, 206 px in the reference.
rsvg-convert -w 412 -h 412 -o logo.png /usr/share/icons/hicolor/scalable/apps/risos-logo.svg

# Progress bar: dark track and blue-to-violet fill.
svg bar-track 1000 28 '<rect width="1000" height="28" rx="14" fill="#25272e"/>'
svg bar-fill 1000 28 '<defs><linearGradient id="g" x1="0" x2="1"><stop offset="0" stop-color="#3F6F99"/><stop offset="1" stop-color="#7566B8"/></linearGradient></defs><rect width="1000" height="28" rx="14" fill="url(#g)"/>'

# Boot screen.
text hint 1400 90 42 400 '#6b6e75' middle 700 'Hold a key to pick a previous version'

# Update screen.
text title 1000 120 72 700 '#ffffff' middle 500 'Updating RisOS'
text status 800 90 44 400 '#c8cad0' start 0 'Installing'
rsvg-convert -o note.png <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="230" viewBox="0 0 1400 230" font-family="Figtree" font-size="42" fill="#8a8d95" text-anchor="middle">
<text x="700" y="50">Your computer will restart automatically.</text>
<text x="700" y="124">Your files and settings stay exactly as they are.</text>
</svg>
SVG
for d in 0 1 2 3 4 5 6 7 8 9; do text "d$d" 30 90 44 400 '#c8cad0' start 0 "$d"; done
text pct 60 90 44 400 '#c8cad0' start 0 '%'

plymouth-set-default-theme risos
