import Quickshell
import QtQuick

// RisOS shell prototype: top bar and floating dock, drawn after style/Bureau, fichiers — clair@2x.png.
// Run with /usr/libexec/risos/start-shell.sh. Quickshell reloads the files as they change.
ShellRoot {
    // Not named "pal": inside TopBar and Dock, "pal" is their own property, so "pal: pal" would
    // bind the property to itself and every design token would be empty.
    Pal { id: theme }

    Variants {
        model: Quickshell.screens
        TopBar { pal: theme }
    }

    Variants {
        model: Quickshell.screens
        Dock { pal: theme }
    }
}
