import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick

// The RisOS lock screen: covers every screen through the session-lock protocol and checks the
// password with PAM. Opened from the system menu. If the compositor does not confirm the lock,
// the shell falls back to Plasma's own lock screen so the session is never left unprotected.
Scope {
    id: root

    required property QtObject pal
    required property QtObject tr

    property bool busy: false
    property bool failed: false
    property string attempt: ""

    function lock() {
        failed = false
        session.locked = true
        fallback.restart()
        safety.restart()
    }

    // Prototype safety net: release the lock by itself after 45 seconds, so a screen that fails to
    // draw can never trap the session. Remove this timer once the lock screen is proven.
    Timer {
        id: safety
        interval: 45000
        onTriggered: session.locked = false
    }

    function unlock(password) {
        if (busy || password.length === 0)
            return
        attempt = password
        busy = true
        failed = false
        pam.start()
    }

    Timer {
        id: fallback
        interval: 1000
        onTriggered: {
            if (session.locked && !session.secure) {
                session.locked = false
                Quickshell.execDetached(["loginctl", "lock-session"])
            }
        }
    }

    PamContext {
        id: pam
        configDirectory: "pam"
        config: "password.conf"

        onPamMessage: {
            if (responseRequired)
                respond(root.attempt)
        }
        onCompleted: function (result) {
            root.busy = false
            root.attempt = ""
            if (result === PamResult.Success) {
                root.failed = false
                session.locked = false
            } else {
                root.failed = true
            }
        }
    }

    WlSessionLock {
        id: session

        WlSessionLockSurface {
            LockView {
                anchors.fill: parent
                pal: root.pal
                tr: root.tr
                busy: root.busy
                failed: root.failed
                onSubmitted: function (password) { root.unlock(password) }
            }
        }
    }
}
