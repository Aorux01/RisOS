import Quickshell
import QtQuick

// The dock plus a thin strip at the bottom edge that brings it back when it has slid away.
Scope {
    id: group

    required property var modelData
    required property QtObject pal
    required property QtObject tr
    required property QtObject ui
    required property var windows

    Dock {
        id: dock
        modelData: group.modelData
        pal: group.pal
        tr: group.tr
        ui: group.ui
        windows: group.windows
    }

    PanelWindow {
        screen: group.modelData
        anchors {
            bottom: true
            left: true
            right: true
        }
        implicitHeight: 3
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"
        visible: dock.covered

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: dock.revealed = true
        }
    }
}
