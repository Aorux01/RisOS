// RisOS Plasma layout: a top bar and a floating dock.
// Run with: /usr/libexec/risos/apply-layout.sh (uses plasmashell's evaluateScript).
// Reference: style/Bureau, fichiers — clair@2x.png

function tryAdd(panel, id) {
    try {
        return panel.addWidget(id);
    } catch (e) {
        print("RisOS layout: widget " + id + " not available");
        return null;
    }
}

// Start from a clean slate.
var existing = panels();
for (var i = 0; i < existing.length; i++) {
    existing[i].remove();
}

// ---- Top bar ------------------------------------------------------------------------------
var bar = new Panel();
bar.location = "top";
bar.height = 34;
bar.floating = false;
bar.hiding = "none";
bar.lengthMode = "fill";

var launcher = tryAdd(bar, "org.kde.plasma.kickoff");
if (launcher) {
    launcher.currentConfigGroup = ["General"];
    launcher.writeConfig("icon", "risos-logo");
}
tryAdd(bar, "org.kde.windowtitle");
tryAdd(bar, "org.kde.plasma.appmenu");
tryAdd(bar, "org.kde.plasma.panelspacer");
tryAdd(bar, "org.kde.plasma.systemtray");
tryAdd(bar, "org.kde.plasma.digitalclock");

// ---- Floating dock ------------------------------------------------------------------------
var dock = new Panel();
dock.location = "bottom";
dock.height = 68;
dock.floating = true;
dock.lengthMode = "fit";
dock.alignment = "center";
dock.hiding = "dodgewindows";

var tasks = tryAdd(dock, "org.kde.plasma.icontasks");
if (tasks) {
    tasks.currentConfigGroup = ["General"];
    tasks.writeConfig("launchers", [
        "applications:org.kde.dolphin.desktop",
        "applications:org.mozilla.firefox.desktop",
        "applications:org.kde.discover.desktop",
        "applications:org.kde.konsole.desktop",
        "applications:systemsettings.desktop"
    ]);
}
