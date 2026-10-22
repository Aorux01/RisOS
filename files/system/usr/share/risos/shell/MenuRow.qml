import QtQuick

// One row of a popup menu: a label, an optional hint on the right (shortcut), hover highlight.
Rectangle {
    id: root

    required property QtObject pal

    property string label
    property string hint
    property bool bold: false
    property bool danger: false

    signal triggered()

    width: parent ? parent.width : 200
    height: Math.round(34 * pal.u)
    radius: Math.round(9 * pal.u)
    color: area.containsMouse ? pal.rowHover : "transparent"

    Text {
        anchors.verticalCenter: parent.verticalCenter
        x: Math.round(14 * pal.u)
        text: root.label
        color: root.danger ? pal.danger : pal.ink
        font.family: pal.font
        font.pixelSize: Math.round(15 * pal.u)
        font.weight: root.bold ? Font.DemiBold : Font.Normal
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Math.round(14 * pal.u)
        text: root.hint
        color: pal.inkSoft
        font.family: pal.font
        font.pixelSize: Math.round(13 * pal.u)
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}
