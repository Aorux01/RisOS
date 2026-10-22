import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

// Everything that opens above the desktop: the system menu (logo), the quick settings (status area),
// the app launcher (dock) and the dock menu (right click). Layout follows style/system-menus,
// app-launcher and context-menus (light and dark).
PanelWindow {
    id: overlay

    required property var modelData
    required property QtObject pal
    required property QtObject tr
    required property QtObject ui

    screen: modelData
    visible: ui.mode !== ""
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    color: "transparent"

    readonly property real u: pal.u
    readonly property real barH: 40 * u
    readonly property string userName: Quickshell.env("USER") || ""

    // ---- Actions -------------------------------------------------------------------------
    function run(cmd) {
        Quickshell.execDetached(cmd)
        ui.close()
    }

    function launchApp(desktopId) {
        var entry = desktopId ? DesktopEntries.byId(desktopId) : null
        if (entry)
            entry.execute()
        ui.close()
    }

    function toggleTheme() {
        pal.dark = !pal.dark
        Quickshell.execDetached(["sh", "-c",
            "mkdir -p ~/.config/risos && echo " + (pal.dark ? "dark" : "light") + " > ~/.config/risos/theme; "
            + "plasma-apply-colorscheme " + (pal.dark ? "RisOSDark" : "RisOSLight")])
    }

    // ---- Quick settings state (see quick-status.sh) --------------------------------------
    property string wifiState: "none"
    property string wifiName: ""
    property string btState: "none"
    property real volume: -1   // -1 when it cannot be read: the slider is hidden
    property string dndState: "off"
    property real brightness: -1   // -1 when there is no backlight

    Icons { id: icons }

    Process {
        id: quickProc
        command: ["/usr/libexec/risos/quick-status.sh"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n")
                for (var i = 0; i < lines.length; i++) {
                    var p = lines[i].trim().split(" ")
                    if (p[0] === "wifi") {
                        overlay.wifiState = p[1]
                        overlay.wifiName = p.slice(2).join(" ")
                    } else if (p[0] === "bluetooth") {
                        overlay.btState = p[1]
                    } else if (p[0] === "volume") {
                        overlay.volume = p[1] === "none" ? -1 : parseFloat(p[1])
                    } else if (p[0] === "dnd") {
                        overlay.dndState = p[1]
                    } else if (p[0] === "brightness") {
                        overlay.brightness = p[1] === "none" ? -1 : parseFloat(p[1])
                    }
                }
            }
        }
    }
    Timer {
        id: refreshSoon
        interval: 900
        onTriggered: quickProc.running = true
    }
    Timer {
        id: brightnessSend
        interval: 150
        onTriggered: Quickshell.execDetached(["brightnessctl", "set", Math.round(overlay.brightness * 100) + "%"])
    }
    Timer {
        id: volumeSend
        interval: 120
        onTriggered: Quickshell.execDetached(["sh", "-c",
            "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + overlay.volume.toFixed(2)
            + " || pactl set-sink-volume @DEFAULT_SINK@ " + Math.round(overlay.volume * 100) + "%"])
    }

    // ---- Launcher state ------------------------------------------------------------------
    property string query: ""
    readonly property var allApps: {
        var out = []
        var list = DesktopEntries.applications.values
        for (var i = 0; i < list.length; i++)
            out.push(list[i])
        out.sort(function (a, b) { return overlay.tr.appName(a).toLowerCase() < overlay.tr.appName(b).toLowerCase() ? -1 : 1 })
        return out
    }
    readonly property var shownApps: {
        var q = query.toLowerCase()
        return q === "" ? allApps : allApps.filter(function (a) { return overlay.tr.appName(a).toLowerCase().indexOf(q) >= 0 || a.name.toLowerCase().indexOf(q) >= 0 })
    }

    Connections {
        target: overlay.ui
        function onModeChanged() {
            if (overlay.ui.mode === "quick") {
                quickProc.running = true
            } else if (overlay.ui.mode === "launcher") {
                overlay.query = ""
                searchInput.text = ""
                searchInput.forceActiveFocus()
            }
        }
    }

    // ---- Click outside closes ------------------------------------------------------------
    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: overlay.ui.close()
        MouseArea {
            anchors.fill: parent
            onClicked: overlay.ui.close()
        }
    }

    // ---- System menu (logo) --------------------------------------------------------------
    Rectangle {
        visible: ui.mode === "system"
        x: 18 * u
        y: barH + 6 * u
        width: Math.round(262 * u)
        height: systemColumn.implicitHeight + 20 * u
        radius: 24 * u
        color: pal.cardFill
        border.width: 1
        border.color: pal.cardLine

        MouseArea { anchors.fill: parent }

        Column {
            id: systemColumn
            x: 10 * u
            y: 10 * u
            width: parent.width - 20 * u
            spacing: 2 * u

            MenuRow { pal: overlay.pal; label: tr.t("about"); bold: true; onTriggered: overlay.run(["systemsettings", "kcm_about-distro"]) }
            MenuRow { pal: overlay.pal; label: tr.t("settings"); onTriggered: overlay.run(["systemsettings"]) }
            MenuRow { pal: overlay.pal; label: tr.t("store"); onTriggered: overlay.run(["plasma-discover"]) }
            Rectangle { width: parent.width; height: 1; color: pal.separator }
            MenuRow { pal: overlay.pal; label: tr.t("lock"); onTriggered: { overlay.ui.close(); overlay.ui.lockRequested() } }
            MenuRow { pal: overlay.pal; label: tr.t("sleep"); onTriggered: overlay.run(["systemctl", "suspend"]) }
            MenuRow { pal: overlay.pal; label: tr.t("restart"); onTriggered: overlay.run(["systemctl", "reboot"]) }
            MenuRow { pal: overlay.pal; label: tr.t("shutdown"); onTriggered: overlay.run(["systemctl", "poweroff"]) }
            Rectangle { width: parent.width; height: 1; color: pal.separator }
            MenuRow {
                pal: overlay.pal
                label: tr.t("logout", overlay.userName)
                onTriggered: overlay.run(["sh", "-c", "loginctl terminate-session \"$XDG_SESSION_ID\""])
            }
        }
    }

    // ---- Quick settings (status area) ----------------------------------------------------
    Rectangle {
        visible: ui.mode === "quick"
        width: Math.round(380 * u)
        height: quickColumn.implicitHeight + 28 * u
        x: overlay.width - width - 18 * u
        y: barH + 6 * u
        radius: 26 * u
        color: pal.cardFill
        border.width: 1
        border.color: pal.cardLine

        MouseArea { anchors.fill: parent }

        Column {
            id: quickColumn
            x: 14 * u
            y: 14 * u
            width: parent.width - 28 * u
            spacing: 10 * u

            Row {
                spacing: 10 * u
                QuickTile {
                    width: Math.floor((quickColumn.width - 10 * u) / 2)
                    pal: overlay.pal
                    iconPaths: icons.wifi
                    title: tr.t("wifi")
                    subtitle: overlay.wifiState === "on" ? (overlay.wifiName !== "" ? overlay.wifiName : tr.t("on"))
                              : (overlay.wifiState === "off" ? tr.t("off") : tr.t("wired"))
                    active: overlay.wifiState === "on"
                    enabledTile: overlay.wifiState !== "none"
                    onClicked: {
                        Quickshell.execDetached(["nmcli", "radio", "wifi", overlay.wifiState === "on" ? "off" : "on"])
                        refreshSoon.restart()
                    }
                }
                QuickTile {
                    width: Math.floor((quickColumn.width - 10 * u) / 2)
                    pal: overlay.pal
                    iconPaths: icons.bluetooth
                    title: tr.t("bluetooth")
                    subtitle: overlay.btState === "on" ? tr.t("on") : (overlay.btState === "off" ? tr.t("off") : tr.t("unavailable"))
                    active: overlay.btState === "on"
                    enabledTile: overlay.btState !== "none"
                    onClicked: {
                        Quickshell.execDetached(["bluetoothctl", "power", overlay.btState === "on" ? "off" : "on"])
                        refreshSoon.restart()
                    }
                }
            }
            Row {
                spacing: 10 * u
                QuickTile {
                    width: Math.floor((quickColumn.width - 10 * u) / 2)
                    pal: overlay.pal
                    iconPaths: icons.bell
                    title: tr.t("dnd")
                    subtitle: overlay.dndState === "on" ? tr.t("on") : tr.t("off")
                    active: overlay.dndState === "on"
                    onClicked: {
                        var on = overlay.dndState !== "on"
                        overlay.dndState = on ? "on" : "off"
                        Quickshell.execDetached(on
                            ? ["kwriteconfig6", "--file", "plasmanotifyrc", "--group", "DoNotDisturb", "--key", "Until", "2099-12-31T23:59:00"]
                            : ["kwriteconfig6", "--file", "plasmanotifyrc", "--group", "DoNotDisturb", "--key", "Until", "--delete"])
                    }
                }
                QuickTile {
                    width: Math.floor((quickColumn.width - 10 * u) / 2)
                    pal: overlay.pal
                    iconPaths: icons.moon
                    title: tr.t("theme")
                    subtitle: pal.dark ? tr.t("dark") : tr.t("light")
                    onClicked: overlay.toggleTheme()
                }
            }

            // Brightness (only when the machine has a backlight)
            Item {
                visible: overlay.brightness >= 0
                width: parent.width
                height: visible ? 30 * u : 0

                Glyph {
                    id: sunGlyph
                    anchors.verticalCenter: parent.verticalCenter
                    x: 4 * u
                    size: 20 * u
                    p0: icons.sun[0]; p1: icons.sun[1]; p2: icons.sun[2]; p3: icons.sun[3]
                    color: pal.ink
                }
                Rectangle {
                    id: brightTrack
                    anchors.verticalCenter: parent.verticalCenter
                    x: 40 * u
                    width: parent.width - 48 * u
                    height: 8 * u
                    radius: height / 2
                    color: pal.track

                    Rectangle {
                        width: parent.width * Math.max(0, Math.min(1, overlay.brightness))
                        height: parent.height
                        radius: height / 2
                        color: pal.tileOn
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    function setFrom(mouseX) {
                        overlay.brightness = Math.max(0.05, Math.min(1, (mouseX - brightTrack.x) / brightTrack.width))
                        brightnessSend.restart()
                    }
                    onPressed: function (mouse) { setFrom(mouse.x) }
                    onPositionChanged: function (mouse) { if (pressed) setFrom(mouse.x) }
                }
            }

            // Volume
            Item {
                visible: overlay.volume >= 0
                width: parent.width
                height: visible ? 30 * u : 0

                Glyph {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 4 * u
                    size: 20 * u
                    p0: icons.speaker[0]; p1: icons.speaker[1]; p2: icons.speaker[2]; p3: icons.speaker[3]
                    color: pal.ink
                }
                Rectangle {
                    id: volumeTrack
                    anchors.verticalCenter: parent.verticalCenter
                    x: 40 * u
                    width: parent.width - 48 * u
                    height: 8 * u
                    radius: height / 2
                    color: pal.track

                    Rectangle {
                        width: parent.width * Math.max(0, Math.min(1, overlay.volume))
                        height: parent.height
                        radius: height / 2
                        color: pal.tileOn
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    function setFrom(mouseX) {
                        overlay.volume = Math.max(0, Math.min(1, (mouseX - volumeTrack.x) / volumeTrack.width))
                        volumeSend.restart()
                    }
                    onPressed: function (mouse) { setFrom(mouse.x) }
                    onPositionChanged: function (mouse) { if (pressed) setFrom(mouse.x) }
                }
            }
        }
    }

    // ---- Launcher (grid icon of the dock) ------------------------------------------------
    Rectangle {
        id: launcher
        visible: ui.mode === "launcher"
        width: Math.min(overlay.width * 0.8, 1120 * u)
        height: Math.min((overlay.height - barH) * 0.88, 720 * u)
        x: (overlay.width - width) / 2
        y: barH + (overlay.height - barH - height) / 2
        radius: 38 * u
        color: pal.cardFill
        border.width: 1
        border.color: pal.cardLine

        MouseArea { anchors.fill: parent }

        // Search field
        Rectangle {
            id: searchBox
            x: 28 * u
            y: 24 * u
            width: parent.width - 56 * u
            height: 48 * u
            radius: height / 2
            color: pal.fieldFill

            Canvas {
                id: magnifier
                width: 18 * u
                height: 18 * u
                x: 18 * u
                anchors.verticalCenter: parent.verticalCenter
                onPaint: {
                    var c = getContext("2d")
                    c.reset()
                    c.strokeStyle = pal.inkSoft
                    c.lineWidth = 1.8 * u
                    c.lineCap = "round"
                    c.beginPath()
                    c.arc(width * 0.42, height * 0.42, width * 0.32, 0, Math.PI * 2)
                    c.moveTo(width * 0.66, height * 0.66)
                    c.lineTo(width * 0.92, height * 0.92)
                    c.stroke()
                }
                Connections {
                    target: overlay.pal
                    function onDarkChanged() { magnifier.requestPaint() }
                }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                x: 50 * u
                visible: searchInput.text.length === 0
                text: tr.t("search", overlay.allApps.length)
                color: pal.inkSoft
                font.family: pal.font
                font.pixelSize: 17 * u
            }
            TextInput {
                id: searchInput
                anchors.verticalCenter: parent.verticalCenter
                x: 50 * u
                width: parent.width - 80 * u
                color: pal.ink
                font.family: pal.font
                font.pixelSize: 17 * u
                clip: true
                onTextChanged: overlay.query = text
                Keys.onEscapePressed: overlay.ui.close()
                Keys.onReturnPressed: {
                    if (overlay.shownApps.length > 0) {
                        overlay.shownApps[0].execute()
                        overlay.ui.close()
                    }
                }
            }
        }

        GridView {
            id: grid
            x: 28 * u
            y: searchBox.y + searchBox.height + 22 * u
            width: parent.width - 56 * u
            height: parent.height - y - 24 * u
            clip: true
            model: overlay.shownApps
            readonly property int columns: Math.max(3, Math.floor(width / (150 * u)))
            cellWidth: Math.floor(width / columns)
            cellHeight: Math.round(118 * u)
            boundsBehavior: Flickable.StopAtBounds

            delegate: Item {
                id: cell
                required property var modelData
                width: grid.cellWidth
                height: grid.cellHeight

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4 * u
                    radius: 16 * u
                    color: cellArea.containsMouse ? pal.rowHover : "transparent"
                }
                IconImage {
                    id: appIcon
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 10 * u
                    implicitSize: Math.round(60 * u)
                    source: Quickshell.iconPath(cell.modelData.icon)
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: appIcon.y + appIcon.height + 8 * u
                    width: parent.width - 12 * u
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    text: overlay.tr.appName(cell.modelData)
                    color: pal.ink
                    font.family: pal.font
                    font.pixelSize: 14 * u
                    font.weight: Font.DemiBold
                }
                MouseArea {
                    id: cellArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        cell.modelData.execute()
                        overlay.ui.close()
                    }
                }
            }
        }

        Text {
            anchors.centerIn: grid
            visible: overlay.shownApps.length === 0
            text: tr.t("no_result")
            color: pal.inkSoft
            font.family: pal.font
            font.pixelSize: 16 * u
        }
    }

    // ---- Dock menu (right click on an icon) ----------------------------------------------
    Rectangle {
        visible: ui.mode === "dockmenu" && ui.app !== null
        width: Math.round(230 * u)
        height: dockMenuColumn.implicitHeight + 20 * u
        x: Math.max(12 * u, Math.min(overlay.width - width - 12 * u, ui.anchorX - width / 2))
        y: ui.anchorY - height - 10 * u
        radius: 22 * u
        color: pal.cardFill
        border.width: 1
        border.color: pal.cardLine

        MouseArea { anchors.fill: parent }

        Column {
            id: dockMenuColumn
            x: 10 * u
            y: 10 * u
            width: parent.width - 20 * u
            spacing: 2 * u

            MenuRow {
                pal: overlay.pal
                label: ui.app ? ui.app.name : ""
                bold: true
                onTriggered: overlay.launchApp(ui.app ? ui.app.id : "")
            }
            Rectangle { width: parent.width; height: 1; color: pal.separator }
            MenuRow {
                pal: overlay.pal
                label: tr.t("new_window")
                onTriggered: overlay.launchApp(ui.app ? ui.app.id : "")
            }
        }
    }
}
