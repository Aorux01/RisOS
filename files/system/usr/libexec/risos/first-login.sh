#!/usr/bin/env bash
# Apply the RisOS look once per user (they stay free to change it afterwards).
flag="${XDG_CONFIG_HOME:-$HOME/.config}/risos/first-login-done"
[ -e "$flag" ] && exit 0

plasma-apply-colorscheme RisOSLight
plasma-apply-wallpaperimage /usr/share/wallpapers/RisOS/contents/images/2560x1600.svg
kwriteconfig6 --file kdeglobals --group General --key font "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key menuFont "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key toolBarFont "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group WM --key activeFont "Figtree,10,-1,5,600,0,0,0,0,0,0,0,0,0,0,1"

# Loading screen shown after login.
kwriteconfig6 --file ksplashrc --group KSplash --key Engine KSplashQML
kwriteconfig6 --file ksplashrc --group KSplash --key Theme org.risos.desktop

mkdir -p "$(dirname "$flag")" && touch "$flag"
