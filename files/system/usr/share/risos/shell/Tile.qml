import QtQuick

// One dock icon: a rounded colored tile with a white glyph.
// Below it: a dot when the app has a window, plus a fainter one behind it for two or more.
Item {
    id: root

    property real size: 52
    property real radiusPx: 14
    property color tint: "#648aad"
    property url glyph
    property int windowCount: 0

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

    readonly property real dot: Math.max(4, root.size * 0.09)

    // Second dot, fainter and tucked behind the first one (two or more windows).
    Rectangle {
        visible: root.windowCount >= 2
        width: root.dot * 0.8
        height: width
        radius: width / 2
        color: "#22262f"
        opacity: 0.25
        x: (root.width - width) / 2 + root.dot * 1.1
        y: root.height + Math.round(root.size * 0.07) + (root.dot - height) / 2
    }

    Rectangle {
        visible: root.windowCount >= 1
        width: root.dot
        height: width
        radius: width / 2
        color: "#22262f"
        opacity: 0.6
        x: (root.width - width) / 2 - (root.windowCount >= 2 ? root.dot * 0.35 : 0)
        y: root.height + Math.round(root.size * 0.07)
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
