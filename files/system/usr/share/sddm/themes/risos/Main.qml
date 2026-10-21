import QtQuick

// RisOS login screen, light. Layout follows style/Verrouillage — clair@2x.png (reference 2000x1250),
// without the notifications and the privacy indicator, which belong to the lock screen.
Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#eef0f6"

    readonly property real u: height / 1250
    readonly property string fontFamily: "Figtree"

    // Light palette. A dark one will take over once the system theme is shared with the greeter.
    readonly property color ink: "#22262f"
    readonly property color inkSoft: "#4b4f5c"
    readonly property color hint: "#6b6e75"
    readonly property color fieldFill: Qt.rgba(1, 0.97, 0.95, 0.8)
    readonly property color danger: "#C0473A"

    property date now: new Date()
    property string userLogin: ""
    property bool failed: false
    property bool menuOpen: false

    // System state, read from /sys and /proc (see GreeterEnvironment in zz-risos.conf).
    // Anything that cannot be read is simply not shown.
    property int batteryPercent: -1
    property bool charging: false
    property string netKind: "none"   // none | wifi | wired
    property int wifiLevel: 0

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

    // ---- Date and time -------------------------------------------------------------------
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 92 * root.u
        text: Qt.formatDate(root.now, "dddd, MMMM d")
        color: root.inkSoft
        font.family: root.fontFamily
        font.pixelSize: 26 * root.u
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 124 * root.u
        text: Qt.formatTime(root.now, "hh:mm")
        color: root.ink
        font.family: root.fontFamily
        font.pixelSize: 150 * root.u
        font.weight: Font.DemiBold
    }

    // ---- Status, top right ---------------------------------------------------------------
    Row {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 36 * root.u
        spacing: 18 * root.u
        layoutDirection: Qt.LeftToRight

        EthernetIcon {
            visible: root.netKind === "wired"
            width: 22 * root.u
            height: 22 * root.u
            color: root.ink
        }
        WifiIcon {
            visible: root.netKind !== "wired"
            width: 22 * root.u
            height: 22 * root.u
            color: root.ink
            level: root.wifiLevel
            offline: root.netKind === "none"
        }
        Row {
            visible: root.batteryPercent >= 0
            spacing: 6 * root.u
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.batteryPercent + "%"
                color: root.inkSoft
                font.family: root.fontFamily
                font.pixelSize: 15 * root.u
            }
            BatteryIcon {
                width: 34 * root.u
                height: 22 * root.u
                color: root.ink
                percent: root.batteryPercent
                charging: root.charging
            }
        }
    }

    // ---- User and password ---------------------------------------------------------------
    // Avatar and name. Click the avatar to switch user when there are several.
    ListView {
        id: users
        width: 360 * root.u
        height: 120 * root.u
        x: (root.width - width) / 2
        y: 590 * root.u
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
                width: 76 * root.u
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
                    font.pixelSize: 34 * root.u
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
                y: 88 * root.u
                text: shownName
                color: root.ink
                font.family: root.fontFamily
                font.pixelSize: 21 * root.u
                font.weight: Font.DemiBold
            }
        }
    }

    Rectangle {
        id: field
        readonly property real restX: (root.width - width) / 2
        width: 380 * root.u
        height: 56 * root.u
        radius: height / 2
        x: restX
        y: 722 * root.u
        color: root.fieldFill
        border.width: 1
        border.color: root.failed ? "#D9604F" : Qt.rgba(0, 0, 0, passwordInput.activeFocus ? 0.18 : 0.07)

        Text {
            anchors.verticalCenter: parent.verticalCenter
            x: 26 * root.u
            visible: passwordInput.text.length === 0
            text: root.failed ? "Incorrect password" : "Password"
            color: root.failed ? root.danger : root.hint
            font.family: root.fontFamily
            font.pixelSize: 20 * root.u
        }
        TextInput {
            id: passwordInput
            anchors.verticalCenter: parent.verticalCenter
            x: 26 * root.u
            width: parent.width - 80 * root.u
            echoMode: TextInput.Password
            passwordCharacter: "•"
            color: root.ink
            font.family: root.fontFamily
            font.pixelSize: 20 * root.u
            clip: true
            focus: true
            onTextChanged: root.failed = false
            Keys.onReturnPressed: root.login()
            Keys.onEnterPressed: root.login()
            Keys.onEscapePressed: root.menuOpen = false
        }
        Canvas {
            width: 20 * root.u
            height: 20 * root.u
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width - 26 * root.u - width
            onPaint: {
                var c = getContext("2d")
                c.reset()
                c.strokeStyle = root.ink
                c.lineWidth = 1.9 * root.u
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
            PropertyAnimation { target: field; property: "x"; to: field.restX - 12 * root.u; duration: 50 }
            PropertyAnimation { target: field; property: "x"; to: field.restX + 12 * root.u; duration: 80 }
            PropertyAnimation { target: field; property: "x"; to: field.restX - 6 * root.u; duration: 70 }
            PropertyAnimation { target: field; property: "x"; to: field.restX; duration: 50 }
        }
    }

    // ---- Power, bottom right -------------------------------------------------------------
    // Closes the menu when clicking anywhere else.
    MouseArea {
        anchors.fill: parent
        visible: root.menuOpen
        z: 5
        onClicked: root.menuOpen = false
    }

    Rectangle {
        id: powerButton
        width: 44 * root.u
        height: width
        radius: width / 2
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 32 * root.u
        color: root.menuOpen || powerArea.containsMouse ? Qt.rgba(0, 0, 0, 0.07) : "transparent"
        z: 6

        PowerIcon {
            anchors.centerIn: parent
            width: 24 * root.u
            height: 24 * root.u
            color: root.ink
        }
        MouseArea {
            id: powerArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.menuOpen = !root.menuOpen
        }
    }

    Rectangle {
        visible: root.menuOpen
        z: 6
        width: 176 * root.u
        height: menuColumn.height + 16 * root.u
        radius: 16 * root.u
        color: Qt.rgba(1, 1, 1, 0.94)
        border.width: 1
        border.color: Qt.rgba(0, 0, 0, 0.08)
        anchors.right: powerButton.right
        anchors.bottom: powerButton.top
        anchors.bottomMargin: 10 * root.u

        Column {
            id: menuColumn
            x: 8 * root.u
            y: 8 * root.u
            width: parent.width - 16 * root.u

            Repeater {
                model: [
                    { label: "Restart", enabled: sddm.canReboot, action: "reboot" },
                    { label: "Shut down", enabled: sddm.canPowerOff, action: "poweroff" }
                ]
                delegate: Rectangle {
                    visible: modelData.enabled
                    width: menuColumn.width
                    height: modelData.enabled ? 42 * root.u : 0
                    radius: 10 * root.u
                    color: rowArea.containsMouse ? Qt.rgba(0.46, 0.4, 0.72, 0.12) : "transparent"
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: 14 * root.u
                        text: modelData.label
                        color: root.ink
                        font.family: root.fontFamily
                        font.pixelSize: 18 * root.u
                    }
                    MouseArea {
                        id: rowArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.menuOpen = false
                            if (modelData.action === "reboot") sddm.reboot()
                            else sddm.powerOff()
                        }
                    }
                }
            }
        }
    }

    // ---- Logic ---------------------------------------------------------------------------
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

    function readFile(path, done) {
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE)
                done(xhr.responseText || "")
        }
        xhr.open("GET", "file://" + path)
        xhr.send()
    }

    readonly property var batteryNames: ["BAT0", "BAT1"]

    function pollBattery(i) {
        if (i >= batteryNames.length) {
            batteryPercent = -1
            return
        }
        var base = "/sys/class/power_supply/" + batteryNames[i]
        readFile(base + "/capacity", function (text) {
            var value = parseInt(text)
            if (isNaN(value)) {
                pollBattery(i + 1)
                return
            }
            batteryPercent = value
            readFile(base + "/status", function (s) { charging = s.trim() === "Charging" })
        })
    }

    function pollNetwork() {
        readFile("/proc/net/wireless", function (w) {
            var wifi = {}   // interface -> link quality (0..70)
            var lines = w.split("\n")
            for (var i = 2; i < lines.length; i++) {
                var cols = lines[i].trim().split(/\s+/)
                if (cols.length > 3)
                    wifi[cols[0].replace(":", "")] = parseFloat(cols[2])
            }
            readFile("/proc/net/dev", function (d) {
                var names = []
                var rows = d.split("\n")
                for (var j = 2; j < rows.length; j++) {
                    var n = rows[j].split(":")[0].trim()
                    if (n && n !== "lo" && !/^(veth|docker|virbr|br-|tun|tap|vnet|podman|cni|flannel)/.test(n))
                        names.push(n)
                }
                checkInterfaces(names, wifi, 0, "none", 0)
            })
        })
    }

    // Wi-Fi wins over a wired link when both are up.
    function checkInterfaces(names, wifi, i, kind, level) {
        if (i >= names.length) {
            netKind = kind
            wifiLevel = level
            return
        }
        var n = names[i]
        readFile("/sys/class/net/" + n + "/operstate", function (state) {
            var k = kind
            var lv = level
            if (state.trim() === "up") {
                if (wifi.hasOwnProperty(n)) {
                    var q = wifi[n]
                    k = "wifi"
                    lv = q >= 45 ? 3 : (q >= 25 ? 2 : (q > 0 ? 1 : 0))
                } else if (k !== "wifi") {
                    k = "wired"
                }
            }
            checkInterfaces(names, wifi, i + 1, k, lv)
        })
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.pollBattery(0)
            root.pollNetwork()
        }
    }

    Component.onCompleted: passwordInput.forceActiveFocus()
}
