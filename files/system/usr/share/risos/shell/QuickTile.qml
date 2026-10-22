import QtQuick

// A toggle tile of the quick settings panel (Wi-Fi, Bluetooth, Do not disturb, Theme):
// an icon at the top, a title and a subtitle below.
Rectangle {
    id: root

    required property QtObject pal

    property var iconPaths: ["", "", "", ""]
    property string title
    property string subtitle
    property bool active: false
    property bool enabledTile: true

    signal clicked()

    width: Math.round(176 * pal.u)
    height: Math.round(88 * pal.u)
    radius: Math.round(20 * pal.u)
    color: active ? pal.tileOn : pal.tileOff
    opacity: enabledTile ? 1 : 0.45

    Glyph {
        x: Math.round(16 * pal.u)
        y: Math.round(14 * pal.u)
        size: Math.round(22 * pal.u)
        p0: root.iconPaths[0]
        p1: root.iconPaths[1]
        p2: root.iconPaths[2]
        p3: root.iconPaths[3]
        color: root.active ? pal.tileOnText : pal.ink
    }

    Column {
        anchors.left: parent.left
        anchors.leftMargin: Math.round(16 * pal.u)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.round(12 * pal.u)
        spacing: Math.round(1 * pal.u)

        Text {
            text: root.title
            color: root.active ? pal.tileOnText : pal.ink
            font.family: pal.font
            font.pixelSize: Math.round(16 * pal.u)
            font.weight: Font.DemiBold
        }
        Text {
            text: root.subtitle
            color: root.active ? pal.tileOnText : pal.inkSoft
            opacity: root.active ? 0.85 : 1
            font.family: pal.font
            font.pixelSize: Math.round(13 * pal.u)
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabledTile
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
