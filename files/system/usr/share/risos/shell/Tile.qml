import QtQuick

// One dock icon: a rounded colored tile with a white glyph, and a dot below when the app runs.
Item {
    id: root

    property real size: 52
    property real radiusPx: 14
    property color tint: "#648aad"
    property url glyph
    property bool running: false

    signal clicked()

    width: size
    height: size

    Rectangle {
        id: face
        anchors.fill: parent
        radius: root.radiusPx
        gradient: Gradient {
            GradientStop { position: 0; color: Qt.lighter(root.tint, 1.14) }
            GradientStop { position: 1; color: Qt.darker(root.tint, 1.1) }
        }
        scale: area.pressed ? 0.94 : (area.containsMouse ? 1.07 : 1.0)
        Behavior on scale {
            NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
        }

        Image {
            anchors.centerIn: parent
            width: root.size * 0.5
            height: width
            source: root.glyph
            sourceSize: Qt.size(96, 96)
        }
    }

    Rectangle {
        visible: root.running
        width: Math.max(4, root.size * 0.09)
        height: width
        radius: width / 2
        color: "#22262f"
        opacity: 0.55
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: Math.round(root.size * 0.07)
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
