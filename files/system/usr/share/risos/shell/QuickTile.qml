import QtQuick

// A toggle tile of the quick settings panel (Wi-Fi, Bluetooth, Theme...).
Rectangle {
    id: root

    required property QtObject pal

    property string title
    property string subtitle
    property bool active: false
    property bool enabledTile: true

    signal clicked()

    width: Math.round(176 * pal.u)
    height: Math.round(76 * pal.u)
    radius: Math.round(20 * pal.u)
    color: active ? pal.tileOn : pal.tileOff
    opacity: enabledTile ? 1 : 0.45

    Column {
        anchors.left: parent.left
        anchors.leftMargin: Math.round(16 * pal.u)
        anchors.verticalCenter: parent.verticalCenter
        spacing: Math.round(2 * pal.u)

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
