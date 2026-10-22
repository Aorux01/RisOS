// RisOS: the only Plasma panel left. It is transparent and sits over the left of the RisOS top bar,
// after the logo, and does one job: show the menus of the active application (File, Edit, View...)
// through KDE's global menu. The bar itself, the dock and the popups are drawn by the RisOS shell.
// Run with: /usr/libexec/risos/apply-layout.sh

var existing = panels();
for (var i = 0; i < existing.length; i++) {
    existing[i].remove();
}

var menu = new Panel();
menu.location = "top";
menu.height = 40;
menu.floating = false;
menu.hiding = "windowsgobelow";   // reserves no space: the RisOS bar already does
menu.lengthMode = "custom";
menu.alignment = "left";
menu.offset = 118;                // leaves room for the wordmark
menu.minimumLength = 900;
menu.maximumLength = 900;

menu.addWidget("org.kde.plasma.appmenu");
