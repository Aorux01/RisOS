import Quickshell
import Quickshell.Io
import QtQuick

// RisOS shell prototype: top bar, floating dock and popups, drawn after the mockups in style/.
// Run with /usr/libexec/risos/start-shell.sh. Quickshell reloads the files as they change.
ShellRoot {
    // The ids differ from the property names on purpose: inside TopBar, Dock and Overlay, "pal",
    // "tr", "ui" and "windows" are their own properties, so "pal: pal" would bind a property to
    // itself and leave every design token empty.
    Pal { id: theme }
    I18n { id: texts }
    ShellState { id: uiState }

    Loader {
        id: winSource
        source: "Windows.qml"
    }

    Variants {
        model: Quickshell.screens
        TopBar {
            pal: theme
            tr: texts
            ui: uiState
        }
    }

    Variants {
        model: Quickshell.screens
        DockGroup {
            pal: theme
            tr: texts
            ui: uiState
            windows: winSource
        }
    }

    LockScreen {
        id: lockScreen
        pal: theme
        tr: texts
    }

    // The RisOS lock screen is still a prototype: it only runs when ~/.config/risos/own-lock exists.
    // Otherwise "Lock screen" uses Plasma's, so a bug here can never leave the session stuck.
    Process {
        id: lockCheck
        command: ["test", "-e", Quickshell.env("HOME") + "/.config/risos/own-lock"]
        onExited: function (exitCode) {
            if (exitCode === 0)
                lockScreen.lock()
            else
                Quickshell.execDetached(["loginctl", "lock-session"])
        }
    }

    Connections {
        target: uiState
        function onLockRequested() { lockCheck.running = true }
    }

    Variants {
        model: Quickshell.screens
        Overlay {
            pal: theme
            tr: texts
            ui: uiState
        }
    }
}
