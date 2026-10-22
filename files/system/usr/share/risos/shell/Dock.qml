import Quickshell
import QtQuick

// Floating dock. Left: the pinned base apps. Then a separator, the app launcher and the trash.
// It reserves no space: windows go under it, and it slides away while the active window is
// maximized or fullscreen (the bottom edge brings it back). See style/Bureau, fichiers — clair@2x.png.
PanelWindow {
    id: dock

    required property var modelData
    required property QtObject pal
    required property QtObject tr
    required property QtObject ui
    required property var windows   // Loader of Windows.qml

    readonly property real tile: 52 * pal.u
    readonly property real gap: 13 * pal.u
    readonly property real padX: 16 * pal.u
    readonly property real bottomGap: 22 * pal.u

    // Hidden while a maximized or fullscreen window is in front, unless the pointer asks for it.
    readonly property bool covered: windows.item ? (windows.item.activeMaximized || windows.item.activeFullscreen) : false
    property bool revealed: false
    readonly property bool shown: !covered || revealed || ui.mode !== ""

    onCoveredChanged: if (!covered) revealed = false

    screen: modelData
    anchors.bottom: true
    margins.bottom: shown ? bottomGap : -(implicitHeight + 12 * pal.u)
    Behavior on margins.bottom {
        NumberAnimation { duration: 240; easing.type: Easing.OutCubic }
    }
    implicitWidth: Math.round(row.implicitWidth + padX * 2)
    implicitHeight: Math.round(77 * pal.u)
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    // The base apps (see I18n.baseNames). Firefox keeps its own logo.
    readonly property var pinned: [
        { name: tr.t("files"),    icon: "folder",   tint: pal.blue,   id: "org.kde.dolphin",    logo: "" },
        { name: tr.t("web"),      icon: "",         tint: pal.teal,   id: "org.mozilla.firefox", logo: "org.mozilla.firefox" },
        { name: tr.t("store"),    icon: "bag",      tint: pal.coral,  id: "org.kde.discover",   logo: "" },
        { name: tr.t("photos"),   icon: "image",    tint: pal.coral,  id: "org.kde.gwenview",   logo: "" },
        { name: tr.t("editor"),   icon: "note",     tint: pal.ochre,  id: "org.kde.kate",       logo: "" },
        { name: tr.t("terminal"), icon: "terminal", tint: pal.slate,  id: "org.kde.konsole",    logo: "" },
        { name: tr.t("settings"), icon: "sun",      tint: pal.gray,   id: "systemsettings",     logo: "" }
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

    // Right click: open the dock menu above the icon.
    function openMenu(item, app) {
        var p = item.mapToItem(null, item.width / 2, 0)
        ui.anchorX = (dock.screen.width - dock.width) / 2 + p.x
        ui.anchorY = dock.screen.height - bottomGap - implicitHeight
        ui.app = { name: app.name, id: app.id }
        ui.mode = "dockmenu"
    }

    Rectangle {
        anchors.fill: parent
        radius: 26 * pal.u
        color: pal.dockFill
        border.width: 1
        border.color: pal.dockLine
    }

    HoverHandler {
        onHoveredChanged: if (!hovered && dock.covered) dock.revealed = false
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: dock.gap

        Repeater {
            model: dock.pinned
            delegate: Tile {
                id: pinnedTile
                required property var modelData
                size: dock.tile
                radiusPx: 14 * pal.u
                tint: modelData.tint
                glyph: modelData.icon !== "" ? "icons/" + modelData.icon + ".svg" : ""
                iconName: modelData.logo
                windowCount: dock.windowCount(modelData.id)
                onClicked: dock.launch(modelData.id)
                onContextRequested: dock.openMenu(pinnedTile, modelData)
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
            onClicked: ui.toggle("launcher")
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
