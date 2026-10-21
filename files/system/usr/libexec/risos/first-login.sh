#!/usr/bin/env bash
# Applique l'apparence RisOS une seule fois par utilisateur (ensuite il reste libre de la changer).
flag="${XDG_CONFIG_HOME:-$HOME/.config}/risos/first-login-done"
[ -e "$flag" ] && exit 0

plasma-apply-colorscheme RisOSLight
plasma-apply-wallpaperimage /usr/share/wallpapers/RisOS/contents/images/2560x1600.svg
kwriteconfig6 --file kdeglobals --group General --key font "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key menuFont "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key toolBarFont "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group WM --key activeFont "Figtree,10,-1,5,600,0,0,0,0,0,0,0,0,0,0,1"

mkdir -p "$(dirname "$flag")" && touch "$flag"
