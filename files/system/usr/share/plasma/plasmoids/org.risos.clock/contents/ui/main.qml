import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

// Top bar clock: the date in regular grey, the time in bold.
// Reference: style/Bureau, fichiers — clair@2x.png ("mer. 21 oct.  09:41").
PlasmoidItem {
    id: root

    property date now: new Date()
    readonly property real fontPx: Math.max(14, Math.round(height * 0.42))

    preferredRepresentation: fullRepresentation

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    fullRepresentation: Row {
        spacing: Math.round(root.fontPx * 0.7)
        Layout.minimumWidth: implicitWidth
        Layout.preferredWidth: implicitWidth

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatDate(root.now, "ddd d MMM")
            color: Kirigami.Theme.textColor
            opacity: 0.62
            font.family: "Figtree"
            font.pixelSize: root.fontPx
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatTime(root.now, "hh:mm")
            color: Kirigami.Theme.textColor
            font.family: "Figtree"
            font.pixelSize: root.fontPx
            font.weight: Font.Bold
        }
    }
}
