import Quickshell
import QtQuick

// One lock screen, after style/Verrouillage — clair and sombre: the wallpaper, the date and a big
// clock, then the user and the password field.
Item {
    id: view

    required property QtObject pal
    required property QtObject tr

    property bool busy: false
    property bool failed: false
    property bool showPassword: false

    signal submitted(string password)

    readonly property real u: height / 1250
    readonly property string userName: Quickshell.env("USER") || ""

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Image {
        anchors.fill: parent
        source: pal.dark ? "assets/lock-dark.svg" : "assets/lock-light.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize: Qt.size(view.width, view.height)
    }

    // Date and time
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 84 * view.u
        text: tr.dateText(clock.date, "dddd d MMMM")
        color: pal.inkSoft
        font.family: pal.font
        font.pixelSize: 31 * view.u
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 122 * view.u
        text: tr.dateText(clock.date, "hh:mm")
        color: pal.ink
        font.family: pal.font
        font.pixelSize: 184 * view.u
        font.weight: Font.DemiBold
    }

    // User
    Rectangle {
        id: avatar
        width: 96 * view.u
        height: width
        radius: width / 2
        x: (view.width - width) / 2
        y: 520 * view.u
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0; color: "#8B7BD8" }
            GradientStop { position: 1; color: "#6A5AB3" }
        }
        Text {
            anchors.centerIn: parent
            text: view.userName.charAt(0).toUpperCase()
            color: "#ffffff"
            font.family: pal.font
            font.pixelSize: 42 * view.u
            font.weight: Font.DemiBold
        }
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: avatar.y + avatar.height + 14 * view.u
        text: view.userName
        color: pal.ink
        font.family: pal.font
        font.pixelSize: 26 * view.u
        font.weight: Font.DemiBold
    }

    // Password field
    Rectangle {
        id: field
        readonly property real restX: (view.width - width) / 2
        width: 440 * view.u
        height: 68 * view.u
        radius: height / 2
        x: restX
        y: 684 * view.u
        color: pal.dark ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(1, 0.97, 0.95, 0.8)
        border.width: 1
        border.color: view.failed ? "#D9604F" : (pal.dark ? Qt.rgba(1, 1, 1, 0.18) : Qt.rgba(0, 0, 0, input.activeFocus ? 0.18 : 0.07))
        opacity: view.busy ? 0.7 : 1

        Text {
            anchors.verticalCenter: parent.verticalCenter
            x: 30 * view.u
            visible: input.text.length === 0
            text: view.failed ? tr.t("wrong_password") : tr.t("password")
            color: view.failed ? pal.danger : pal.inkSoft
            font.family: pal.font
            font.pixelSize: 24 * view.u
        }
        TextInput {
            id: input
            anchors.verticalCenter: parent.verticalCenter
            x: 30 * view.u
            width: parent.width - 100 * view.u
            echoMode: view.showPassword ? TextInput.Normal : TextInput.Password
            passwordCharacter: "•"
            color: pal.ink
            font.family: pal.font
            font.pixelSize: 24 * view.u
            clip: true
            focus: true
            readOnly: view.busy
            onTextChanged: view.failed = false
            Keys.onReturnPressed: view.submit()
            Keys.onEnterPressed: view.submit()
        }
        Glyph {
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - 30 * view.u - size
            size: 26 * view.u
            p0: icons.eye[0]; p1: icons.eye[1]; p2: view.showPassword ? "" : icons.eye[2]; p3: ""
            color: view.showPassword ? pal.ink : pal.inkSoft
            MouseArea {
                anchors.fill: parent
                anchors.margins: -10 * view.u
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    view.showPassword = !view.showPassword
                    input.forceActiveFocus()
                }
            }
        }

        SequentialAnimation {
            id: shake
            PropertyAnimation { target: field; property: "x"; to: field.restX - 12 * view.u; duration: 50 }
            PropertyAnimation { target: field; property: "x"; to: field.restX + 12 * view.u; duration: 80 }
            PropertyAnimation { target: field; property: "x"; to: field.restX - 6 * view.u; duration: 70 }
            PropertyAnimation { target: field; property: "x"; to: field.restX; duration: 50 }
        }
    }

    Icons { id: icons }

    function submit() {
        view.submitted(input.text)
    }

    onFailedChanged: {
        if (failed) {
            input.text = ""
            shake.start()
            input.forceActiveFocus()
        }
    }

    Component.onCompleted: input.forceActiveFocus()
}
