import Quickshell
import QtQuick

// RisOS shell prototype: top bar and floating dock, drawn after style/Bureau, fichiers — clair@2x.png.
// Run with /usr/libexec/risos/start-shell.sh. Quickshell reloads the files as they change.
ShellRoot {
    // Not named "pal" or "windows": inside TopBar and Dock those are their own properties, so
    // "pal: pal" would bind a property to itself and leave every design token empty.
    Pal { id: theme }

    Loader {
        id: winSource
        source: "Windows.qml"
    }

    Variants {
        model: Quickshell.screens
        TopBar {
            pal: theme
            windows: winSource
        }
    }

    Variants {
        model: Quickshell.screens
        Dock {
            pal: theme
            windows: winSource
        }
    }
}
