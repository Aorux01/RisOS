#!/usr/bin/env bash
# Apply the RisOS look to the user at login, once per version of the look.
# /usr/share/risos/STYLE_VERSION is bumped whenever the look changes (new theme, new layout...);
# a user whose recorded version is older gets it applied again. After that they stay free to change it.
version_file=/usr/share/risos/STYLE_VERSION
marker="${XDG_CONFIG_HOME:-$HOME/.config}/risos/style-version"

want=$(cat "$version_file" 2>/dev/null || echo 0)
have=$(cat "$marker" 2>/dev/null || echo 0)
[ "$have" = "$want" ] && exit 0

plasma-apply-colorscheme RisOSLight
kwriteconfig6 --file kdeglobals --group General --key font "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key menuFont "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group General --key toolBarFont "Figtree,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

# Colors, wallpaper, icons, window frame, lock screen, Num Lock, global menu.
/usr/libexec/risos/apply-style.sh

# The one Plasma panel that remains (application menus); the bar and the dock come from the RisOS shell.
/usr/libexec/risos/apply-layout.sh

# Loading screen shown after login.
kwriteconfig6 --file ksplashrc --group KSplash --key Engine KSplashQML
kwriteconfig6 --file ksplashrc --group KSplash --key Theme org.risos.desktop

mkdir -p "$(dirname "$marker")" && echo "$want" > "$marker"
