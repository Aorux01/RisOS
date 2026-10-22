import Quickshell
import Quickshell.Io
import QtQuick

// Top bar. Left: logo, name of the active app. Right: network, battery, date and time.
PanelWindow {
    id: bar

    required property var modelData
    required property QtObject pal
    required property var windows   // Loader of Windows.qml

    screen: modelData
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Math.round(40 * pal.u)
    exclusiveZone: implicitHeight
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

    // Battery and network come from a small script (see /usr/libexec/risos/status.sh).
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

    // Name of the active application. Falls back to "RisOS" when no window is focused or when the
    // window list is unavailable.
    readonly property string appName: {
        if (!windows.item || windows.item.activeName === "")
            return "RisOS"
        return windows.item.activeName
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

    // Left
    Row {
        anchors.left: parent.left
        anchors.leftMargin: 16 * pal.u
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8 * pal.u

        Image {
            anchors.verticalCenter: parent.verticalCenter
            width: 30 * pal.u
            height: 30 * pal.u
            source: "icons/glyph.svg"
            sourceSize: Qt.size(64, 64)
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: bar.appName
            color: pal.ink
            font.family: pal.font
            font.pixelSize: bar.fontPx
            font.weight: Font.Bold
        }
    }

    // Right
    Row {
        anchors.right: parent.right
        anchors.rightMargin: 22 * pal.u
        anchors.verticalCenter: parent.verticalCenter
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
            spacing: 8 * pal.u
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
                text: Qt.formatDate(clock.date, "ddd d MMM")
                color: pal.inkSoft
                font.family: pal.font
                font.pixelSize: bar.fontPx
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Qt.formatTime(clock.date, "hh:mm")
                color: pal.ink
                font.family: pal.font
                font.pixelSize: bar.fontPx
                font.weight: Font.Bold
            }
        }
    }
}
