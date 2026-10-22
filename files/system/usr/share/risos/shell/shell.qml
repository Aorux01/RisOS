import Quickshell
import QtQuick

// RisOS shell prototype: top bar and floating dock, drawn after style/Bureau, fichiers — clair@2x.png.
// Run with /usr/libexec/risos/start-shell.sh. Quickshell reloads the files as they change.
ShellRoot {
    Pal { id: pal }

    Variants {
        model: Quickshell.screens
        TopBar { pal: pal }
    }

    Variants {
        model: Quickshell.screens
        Dock { pal: pal }
    }
}
