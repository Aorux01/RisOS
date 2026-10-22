import QtQuick

// Path data of the line icons (24x24 box, up to four paths each). Use with Glyph:
//   Glyph { p0: icons.wifi[0]; p1: icons.wifi[1]; ... }
// Helper: Icons.apply(glyph, "wifi") is not possible in QML, so Glyph takes the paths directly.
QtObject {
    readonly property var wifi: [
        "M2.5 9.5a14 14 0 0 1 19 0",
        "M5.5 13a9.5 9.5 0 0 1 13 0",
        "M8.8 16.4a5 5 0 0 1 6.4 0",
        "M12 19.7h.02"
    ]
    readonly property var bluetooth: [
        "M7 8l10 8-5 5V3l5 5-10 8", "", "", ""
    ]
    readonly property var bell: [
        "M6 16.5V11a6 6 0 0 1 12 0v5.5l1.5 2H4.5z",
        "M10 20.5a2 2 0 0 0 4 0", "", ""
    ]
    readonly property var moon: [
        "M20 14.5A8 8 0 1 1 9.5 4a6.5 6.5 0 0 0 10.5 10.5z", "", "", ""
    ]
    readonly property var sun: [
        "M8.5 12a3.5 3.5 0 1 0 7 0a3.5 3.5 0 1 0-7 0",
        "M12 3v2.5M12 18.5V21M3 12h2.5M18.5 12H21",
        "M5.6 5.6l1.8 1.8M16.6 16.6l1.8 1.8M5.6 18.4l1.8-1.8M16.6 7.4l1.8-1.8", ""
    ]
    readonly property var speaker: [
        "M4 9.5h3.5L12 6v12l-4.5-3.5H4z",
        "M15.5 9a4 4 0 0 1 0 6",
        "M18 6.8a7.5 7.5 0 0 1 0 10.4", ""
    ]
    readonly property var eye: [
        "M2.5 12s3.5-6.5 9.5-6.5 9.5 6.5 9.5 6.5-3.5 6.5-9.5 6.5S2.5 12 2.5 12z",
        "M9.5 12a2.5 2.5 0 1 0 5 0a2.5 2.5 0 1 0-5 0",
        "M4 20L20 4", ""
    ]
    readonly property var sliders: [
        "M4 7h10M18 7h2M4 17h2M10 17h10",
        "M14 7a2 2 0 1 0 4 0a2 2 0 1 0-4 0",
        "M6 17a2 2 0 1 0 4 0a2 2 0 1 0-4 0", ""
    ]
}
