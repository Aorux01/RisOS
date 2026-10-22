#!/usr/bin/env bash
# Apply the RisOS look to the current user: icons, window frame, lock screen.
# Run by first-login.sh for new users, and by hand (or risos-dev-sync) to try changes.
set -uo pipefail

# Colors and wallpaper.
plasma-apply-colorscheme RisOSLight || true
plasma-apply-wallpaperimage /usr/share/wallpapers/RisOS/contents/images/2560x1600.svg || true

# Icons: colored tiles for the core apps, Breeze for the rest.
kwriteconfig6 --file kdeglobals --group Icons --key Theme RisOS
/usr/libexec/plasma-changeicons RisOS 2>/dev/null || true

# Window frame: RisOS Aurorae theme, buttons on the right.
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.kwin.aurorae
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme __aurorae__svg__RisOS
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft ""
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight IAX
busctl --user call org.kde.KWin /KWin org.kde.KWin reconfigure >/dev/null 2>&1 || true

# Window titles: Figtree, semibold.
kwriteconfig6 --file kdeglobals --group WM --key activeFont "Figtree,11,-1,5,600,0,0,0,0,0,0,0,0,0,0,1"
kwriteconfig6 --file kdeglobals --group WM --key inactiveFont "Figtree,11,-1,5,500,0,0,0,0,0,0,0,0,0,0,1"

# Lock screen: the RisOS wallpaper instead of KDE's "picture of the day".
kwriteconfig6 --file kscreenlockerrc --group Greeter --key WallpaperPlugin org.kde.image
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General \
  --key Image file:///usr/share/wallpapers/RisOS/contents/images/2560x1600.svg

# Num Lock stays on at login (0 = on, 1 = off, 2 = leave unchanged).
kwriteconfig6 --file kcminputrc --group Keyboard --key NumLock 0

# Global menu: apps show their menus in the top bar instead of their own window.
kwriteconfig6 --file kded6rc --group Module-appmenu --key autoload true

# Terminal: RisOS profile and colors, no toolbar (the menus are in the top bar).
kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile RisOS.profile
kwriteconfig6 --file konsolerc --group MainWindow --group "Toolbar mainToolBar" --key Hidden true
kwriteconfig6 --file konsolerc --group KonsoleWindow --key ShowMenuBarByDefault false
