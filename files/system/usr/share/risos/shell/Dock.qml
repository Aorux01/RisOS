import Quickshell
import QtQuick

// Floating dock. Left: pinned apps. Then a separator, the app launcher and the trash.
// Tile colors and layout follow style/Bureau, fichiers — clair@2x.png.
PanelWindow {
    id: dock

    required property var modelData
    required property QtObject pal
    required property var windows   // Loader of Windows.qml

    readonly property real tile: 52 * pal.u
    readonly property real gap: 13 * pal.u
    readonly property real padX: 16 * pal.u
    readonly property real bottomGap: 22 * pal.u

    screen: modelData
    anchors.bottom: true
    margins.bottom: bottomGap
    implicitWidth: Math.round(row.implicitWidth + padX * 2)
    implicitHeight: Math.round(77 * pal.u)
    exclusiveZone: implicitHeight + bottomGap
    color: "transparent"

    // Pinned apps. Entries that are not installed yet are placeholders and do nothing when clicked.
    readonly property var pinned: [
        { name: "Files",    icon: "folder",   tint: pal.blue,   id: "org.kde.dolphin" },
        { name: "Web",      icon: "globe",    tint: pal.teal,   id: "org.mozilla.firefox" },
        { name: "Store",    icon: "bag",      tint: pal.coral,  id: "org.kde.discover" },
        { name: "Messages", icon: "chat",     tint: pal.green,  id: "" },
        { name: "Phone",    icon: "phone",    tint: pal.violet, id: "" },
        { name: "Meet",     icon: "video",    tint: pal.pink,   id: "" },
        { name: "Notes",    icon: "note",     tint: pal.ochre,  id: "" },
        { name: "Terminal", icon: "terminal", tint: pal.slate,  id: "org.kde.konsole" }
    ]

    // Number of open windows of an app (0 when unknown or when the window list is unavailable).
    function windowCount(desktopId) {
        if (desktopId === "" || !windows.item)
            return 0
        return windows.item.counts[desktopId.toLowerCase()] || 0
    }

    function launch(desktopId) {
        if (desktopId === "")
            return
        var entry = DesktopEntries.byId(desktopId)
        if (entry)
            entry.execute()
    }

    Rectangle {
        anchors.fill: parent
        radius: 26 * pal.u
        color: pal.dockFill
        border.width: 1
        border.color: pal.dockLine
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: dock.gap

        Repeater {
            model: dock.pinned
            delegate: Tile {
                required property var modelData
                size: dock.tile
                radiusPx: 14 * pal.u
                tint: modelData.tint
                glyph: "icons/" + modelData.icon + ".svg"
                windowCount: dock.windowCount(modelData.id)
                onClicked: dock.launch(modelData.id)
            }
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 1
            height: dock.tile * 0.7
            color: pal.dockLine
        }

        Tile {
            size: dock.tile
            radiusPx: 14 * pal.u
            tint: pal.gray
            glyph: "icons/grid.svg"
        }
        Tile {
            size: dock.tile
            radiusPx: 14 * pal.u
            tint: pal.trash
            glyph: "icons/trash.svg"
            onClicked: Quickshell.execDetached(["xdg-open", "trash:/"])
        }
    }
}
