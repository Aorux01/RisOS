import QtQuick

// RisOS loading screen shown after login: same background as the login screen,
// the logo and a bar gliding back and forth. Layout reference: 2000x1250.
Rectangle {
    id: root
    color: "#e8ebf6"

    property int stage
    readonly property real u: height / 1250

    onStageChanged: {
        if (stage == 2) {
            intro.running = true
        } else if (stage == 5) {
            outro.running = true
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0

        Image {
            anchors.fill: parent
            source: "images/background.svg"
            fillMode: Image.PreserveAspectCrop
            sourceSize: Qt.size(root.width, root.height)
        }

        Image {
            id: logo
            width: 206 * root.u
            height: width
            x: (parent.width - width) / 2
            y: 578 * root.u - height / 2
            source: "images/logo.svg"
            sourceSize: Qt.size(width * 2, height * 2)
            asynchronous: true
        }

        Item {
            id: bar
            width: 250 * root.u
            height: 7 * root.u
            x: (parent.width - width) / 2
            y: 768 * root.u

            Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: Qt.rgba(0, 0, 0, 0.1)
            }
            Rectangle {
                id: segment
                width: bar.width * 0.3
                height: bar.height
                radius: height / 2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0; color: "#2FC4C0" }
                    GradientStop { position: 0.5; color: "#4D86E8" }
                    GradientStop { position: 1; color: "#9A6BF0" }
                }
                SequentialAnimation on x {
                    loops: Animation.Infinite
                    running: true
                    NumberAnimation { from: 0; to: bar.width * 0.7; duration: 1100; easing.type: Easing.InOutSine }
                    NumberAnimation { from: bar.width * 0.7; to: 0; duration: 1100; easing.type: Easing.InOutSine }
                }
            }
        }
    }

    OpacityAnimator {
        id: intro
        running: false
        target: content
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }

    OpacityAnimator {
        id: outro
        running: false
        target: bar
        from: 1
        to: 0
        duration: 300
    }
}
