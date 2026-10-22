import QtQuick

// What the shell is showing right now: which popup is open and where it points to.
QtObject {
    property string mode: ""      // "" | system | quick | launcher | dockmenu
    property var app: null        // dock entry for the dock menu
    property real anchorX: 0      // dock menu: center of the tile, in screen pixels
    property real anchorY: 0      // dock menu: top of the dock, in screen pixels

    function toggle(m) {
        mode = mode === m ? "" : m
    }

    function close() {
        mode = ""
    }
}
