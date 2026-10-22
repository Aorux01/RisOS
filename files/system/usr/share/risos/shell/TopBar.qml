import Quickshell
import Quickshell.Io
import QtQuick

// Top bar. Left: the logo, which opens the system menu. Right: network, battery, date and time;
// clicking them opens the quick settings.
PanelWindow {
    id: bar

    required property var modelData
    required property QtObject pal
    required property QtObject tr
    required property QtObject ui

    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Math.round(40 * pal.u)
    exclusiveZone: implicitHeight
    aboveWindows: false   // the transparent Plasma panel that shows the app menus sits above
    color: "transparent"

    // ---- State ---------------------------------------------------------------------------
    property int batteryPercent: -1
    property bool charging: false
    property string netKind: "none"   // none | wifi | wired
    property int wifiLevel: 0

    readonly property real fontPx: 15 * pal.u
    readonly property real gap: 24 * pal.u   // spacing between the right-hand items

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // Battery, network, theme and language come from a small script (see status.sh).
    Process {
        id: statusProc
        command: ["/usr/libexec/risos/status.sh"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n")
                for (var i = 0; i < lines.length; i++) {
                    var p = lines[i].trim().split(" ")
                    if (p[0] === "battery") {
                        bar.batteryPercent = p[1] === "none" ? -1 : parseInt(p[1])
                        bar.charging = p[2] === "Charging"
                    } else if (p[0] === "net") {
                        bar.netKind = p[1]
                        bar.wifiLevel = parseInt(p[2])
                    } else if (p[0] === "theme") {
                        bar.pal.dark = p[1] === "dark"
                    } else if (p[0] === "lang" && p[1] && p[1].length >= 2) {
                        bar.tr.lang = p[1].substring(0, 2).toLowerCase()
                    }
                }
            }
        }
    }
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: statusProc.running = true
    }

    // ---- Look ----------------------------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        color: pal.barFill

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: pal.barLine
        }
    }

    // Left: logo, opens the system menu
    Item {
        id: logoButton
        anchors.left: parent.left
        anchors.leftMargin: 10 * pal.u
        anchors.verticalCenter: parent.verticalCenter
        width: wordmark.width + 20 * pal.u
        height: 32 * pal.u

        Rectangle {
            anchors.fill: parent
            radius: 9 * pal.u
            color: ui.mode === "system" || logoArea.containsMouse ? pal.rowHover : "transparent"
        }
        Image {
            id: wordmark
            anchors.centerIn: parent
            height: 20 * pal.u
            width: height * 3013 / 790   // aspect ratio of the wordmark SVG
            source: pal.dark ? "icons/wordmark-on-dark.svg" : "icons/wordmark-on-light.svg"
            sourceSize: Qt.size(width * 2, height * 2)
        }
        MouseArea {
            id: logoArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: ui.toggle("system")
        }
    }

    // Right: status and clock, opens the quick settings
    Item {
        id: statusButton
        anchors.right: parent.right
        anchors.rightMargin: 10 * pal.u
        anchors.verticalCenter: parent.verticalCenter
        height: 32 * pal.u
        width: statusRow.implicitWidth + 24 * pal.u

        Rectangle {
            anchors.fill: parent
            radius: 9 * pal.u
            color: ui.mode === "quick" || statusArea.containsMouse ? pal.rowHover : "transparent"
        }

        Row {
            id: statusRow
            anchors.centerIn: parent
            spacing: bar.gap

            EthernetIcon {
                anchors.verticalCenter: parent.verticalCenter
                visible: bar.netKind === "wired"
                width: 20 * pal.u
                height: 20 * pal.u
                color: pal.ink
            }
            WifiIcon {
                anchors.verticalCenter: parent.verticalCenter
                visible: bar.netKind !== "wired"
                width: 20 * pal.u
                height: 20 * pal.u
                color: pal.ink
                level: bar.wifiLevel
                offline: bar.netKind === "none"
            }
            Row {
                anchors.verticalCenter: parent.verticalCenter
                visible: bar.batteryPercent >= 0
                spacing: 6 * pal.u
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: bar.batteryPercent + "%"
                    color: pal.inkSoft
                    font.family: pal.font
                    font.pixelSize: bar.fontPx * 0.9
                }
                BatteryIcon {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 28 * pal.u
                    height: 20 * pal.u
                    color: pal.ink
                    percent: bar.batteryPercent
                    charging: bar.charging
                }
            }
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12 * pal.u
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: tr.dateText(clock.date, "ddd d MMM")
                    color: pal.inkSoft
                    font.family: pal.font
                    font.pixelSize: bar.fontPx
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: tr.dateText(clock.date, "hh:mm")
                    color: pal.ink
                    font.family: pal.font
                    font.pixelSize: bar.fontPx
                    font.weight: Font.Bold
                }
            }
        }

        MouseArea {
            id: statusArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: ui.toggle("quick")
        }
    }
}
