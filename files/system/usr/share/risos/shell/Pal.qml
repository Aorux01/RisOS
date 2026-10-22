import QtQuick

// Design tokens for the shell. Light theme; the dark one swaps these values.
// Sizes are in "design pixels" of the 1280x800 mockup: raise `u` to scale everything.
QtObject {
    property real u: 1.0

    readonly property string font: "Figtree"

    // Surfaces
    property color barFill: Qt.rgba(0.969, 0.969, 0.961, 0.94)
    property color barLine: Qt.rgba(0, 0, 0, 0.07)
    property color dockFill: Qt.rgba(0.98, 0.972, 0.957, 0.82)
    property color dockLine: Qt.rgba(0, 0, 0, 0.08)

    // Text and icons
    property color ink: "#22262f"
    property color inkSoft: Qt.rgba(0.133, 0.149, 0.184, 0.62)

    // Dock tiles (from style/tokens.json)
    readonly property color blue: "#648aad"
    readonly property color teal: "#55a1a1"
    readonly property color coral: "#e08572"
    readonly property color green: "#71a087"
    readonly property color violet: "#9084c6"
    readonly property color pink: "#d07b9e"
    readonly property color ochre: "#c69341"
    readonly property color slate: "#5e6672"
    readonly property color gray: "#6b7078"
    readonly property color trash: "#8c94a0"
}
