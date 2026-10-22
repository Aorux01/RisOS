import QtQuick

// Design tokens for the shell, light and dark (style/*-light* and style/*-dark* mockups).
// Sizes are in "design pixels" of the 1280x800 mockup: raise `u` to scale everything.
QtObject {
    property real u: 1.0
    property bool dark: false

    readonly property string font: "Figtree"

    // Surfaces
    readonly property color barFill: dark ? Qt.rgba(0.133, 0.149, 0.184, 0.94) : Qt.rgba(0.969, 0.969, 0.961, 0.94)
    readonly property color barLine: dark ? Qt.rgba(1, 1, 1, 0.07) : Qt.rgba(0, 0, 0, 0.07)
    readonly property color dockFill: dark ? Qt.rgba(0.14, 0.157, 0.19, 0.82) : Qt.rgba(0.98, 0.972, 0.957, 0.82)
    readonly property color dockLine: dark ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.08)
    readonly property color cardFill: dark ? Qt.rgba(0.141, 0.157, 0.188, 0.97) : Qt.rgba(0.98, 0.976, 0.965, 0.97)
    readonly property color cardLine: dark ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(0, 0, 0, 0.07)
    readonly property color fieldFill: dark ? Qt.rgba(1, 1, 1, 0.07) : Qt.rgba(0, 0, 0, 0.045)
    readonly property color rowHover: dark ? Qt.rgba(0.55, 0.68, 0.85, 0.2) : Qt.rgba(0.47, 0.62, 0.78, 0.2)
    readonly property color separator: dark ? Qt.rgba(1, 1, 1, 0.09) : Qt.rgba(0, 0, 0, 0.08)
    readonly property color tileOn: dark ? "#9bbbe0" : "#3a6788"
    readonly property color tileOnText: dark ? "#16202c" : "#ffffff"
    readonly property color track: dark ? Qt.rgba(1, 1, 1, 0.16) : Qt.rgba(0, 0, 0, 0.1)
    readonly property color tileOff: dark ? Qt.rgba(1, 1, 1, 0.07) : Qt.rgba(0, 0, 0, 0.05)

    // Text and icons
    readonly property color ink: dark ? "#eceef2" : "#22262f"
    readonly property color inkSoft: dark ? Qt.rgba(0.925, 0.933, 0.949, 0.7) : Qt.rgba(0.133, 0.149, 0.184, 0.72)
    readonly property color danger: dark ? "#ee8479" : "#c0473a"
    readonly property color link: dark ? "#9bbbe0" : "#3a6788"

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
