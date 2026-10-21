import QtQuick

// RisOS login screen. Layout follows style/Verrouillage — sombre@2x.png (reference 2000x1250).
Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1a1d2e"

    readonly property real u: height / 1250
    readonly property string fontFamily: "Figtree"
    property date now: new Date()
    property string userLogin: ""
    property bool failed: false

    Image {
        anchors.fill: parent
        source: "background.svg"
        fillMode: Image.PreserveAspectCrop
        sourceSize: Qt.size(root.width, root.height)
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    // Date and time
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 108 * root.u
        text: Qt.formatDate(root.now, "dddd, MMMM d")
        color: "#d3d0ec"
        font.family: root.fontFamily
        font.pixelSize: 34 * root.u
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 150 * root.u
        text: Qt.formatTime(root.now, "hh:mm")
        color: "#ffffff"
        font.family: root.fontFamily
        font.pixelSize: 210 * root.u
        font.weight: Font.DemiBold
    }

    // Current user: avatar and name. Click the avatar to switch user when there are several.
    ListView {
        id: users
        width: 400 * root.u
        height: 180 * root.u
        x: (root.width - width) / 2
        y: 918 * root.u
        model: userModel
        currentIndex: userModel.lastIndex
        orientation: ListView.Horizontal
        interactive: false
        clip: true
        highlightMoveDuration: 0
        onCurrentItemChanged: if (currentItem) root.userLogin = currentItem.login

        delegate: Item {
            width: users.width
            height: users.height
            readonly property string login: model.name
            readonly property string shownName: model.realName && model.realName.length > 0 ? model.realName : model.name

            Rectangle {
                width: 100 * root.u
                height: width
                radius: width / 2
                x: (parent.width - width) / 2
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0; color: "#8B7BD8" }
                    GradientStop { position: 1; color: "#6A5AB3" }
                }
                Text {
                    anchors.centerIn: parent
                    text: shownName.charAt(0).toUpperCase()
                    color: "#ffffff"
                    font.family: root.fontFamily
                    font.pixelSize: 44 * root.u
                    font.weight: Font.DemiBold
                }
                MouseArea {
                    anchors.fill: parent
                    enabled: users.count > 1
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: users.currentIndex = (users.currentIndex + 1) % users.count
                }
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                y: 118 * root.u
                text: shownName
                color: "#ffffff"
                font.family: root.fontFamily
                font.pixelSize: 26 * root.u
                font.weight: Font.DemiBold
            }
        }
    }

    // Password field
    Rectangle {
        id: field
        width: 466 * root.u
        height: 72 * root.u
        radius: height / 2
        x: (root.width - width) / 2
        y: 1089 * root.u
        color: Qt.rgba(0.1, 0.1, 0.15, 0.55)
        border.width: 1
        border.color: root.failed ? "#FF8F85" : Qt.rgba(1, 1, 1, passwordInput.activeFocus ? 0.35 : 0.18)

        Text {
            anchors.verticalCenter: parent.verticalCenter
            x: 32 * root.u
            visible: passwordInput.text.length === 0
            text: root.failed ? "Incorrect password" : "Password"
            color: root.failed ? "#FFB3AA" : "#bdb9d0"
            font.family: root.fontFamily
            font.pixelSize: 26 * root.u
        }
        TextInput {
            id: passwordInput
            anchors.verticalCenter: parent.verticalCenter
            x: 32 * root.u
            width: parent.width - 100 * root.u
            echoMode: TextInput.Password
            passwordCharacter: "•"
            color: "#ffffff"
            font.family: root.fontFamily
            font.pixelSize: 26 * root.u
            clip: true
            focus: true
            onTextChanged: root.failed = false
            Keys.onReturnPressed: root.login()
            Keys.onEnterPressed: root.login()
        }
        Canvas {
            width: 24 * root.u
            height: 24 * root.u
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - 32 * root.u - width
            onPaint: {
                var c = getContext("2d")
                c.reset()
                c.strokeStyle = "#ffffff"
                c.lineWidth = 2.2 * root.u
                c.lineCap = "round"
                c.lineJoin = "round"
                var m = height / 2
                c.beginPath()
                c.moveTo(2 * root.u, m)
                c.lineTo(width - 2 * root.u, m)
                c.moveTo(width * 0.55, m - width * 0.35)
                c.lineTo(width - 2 * root.u, m)
                c.lineTo(width * 0.55, m + width * 0.35)
                c.stroke()
            }
            MouseArea {
                anchors.fill: parent
                anchors.margins: -12 * root.u
                cursorShape: Qt.PointingHandCursor
                onClicked: root.login()
            }
        }

        SequentialAnimation {
            id: shake
            PropertyAnimation { target: field; property: "x"; to: (root.width - field.width) / 2 - 14 * root.u; duration: 50 }
            PropertyAnimation { target: field; property: "x"; to: (root.width - field.width) / 2 + 14 * root.u; duration: 80 }
            PropertyAnimation { target: field; property: "x"; to: (root.width - field.width) / 2 - 8 * root.u; duration: 70 }
            PropertyAnimation { target: field; property: "x"; to: (root.width - field.width) / 2; duration: 50 }
        }
    }

    // Power actions
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 40 * root.u
        spacing: 28 * root.u
        Text {
            visible: sddm.canReboot
            text: "Restart"
            color: "#d3d0ec"
            font.family: root.fontFamily
            font.pixelSize: 22 * root.u
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.reboot() }
        }
        Text {
            visible: sddm.canPowerOff
            text: "Shut down"
            color: "#d3d0ec"
            font.family: root.fontFamily
            font.pixelSize: 22 * root.u
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sddm.powerOff() }
        }
    }

    function login() {
        if (root.userLogin.length > 0)
            sddm.login(root.userLogin, passwordInput.text, sessionModel.lastIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            passwordInput.text = ""
            root.failed = true
            shake.start()
            passwordInput.forceActiveFocus()
        }
    }

    Component.onCompleted: passwordInput.forceActiveFocus()
}
