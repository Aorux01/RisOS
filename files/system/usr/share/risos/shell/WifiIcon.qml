import QtQuick

// Wi-Fi glyph: a dot and three arcs. level 0..3 lights the arcs; offline adds a slash.
Canvas {
    property color color: "#22262f"
    property int level: 3
    property bool offline: false

    onColorChanged: requestPaint()
    onLevelChanged: requestPaint()
    onOfflineChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        var w = width
        var cx = w / 2
        var cy = height * 0.82
        var lw = w * 0.085
        var on = Qt.rgba(color.r, color.g, color.b, offline ? 0.45 : 1)
        var off = Qt.rgba(color.r, color.g, color.b, 0.22)
        ctx.lineCap = "round"
        ctx.lineWidth = lw
        var radii = [w * 0.26, w * 0.46, w * 0.66]
        for (var i = 0; i < 3; i++) {
            ctx.strokeStyle = i < level ? on : off
            ctx.beginPath()
            ctx.arc(cx, cy, radii[i], -Math.PI * 0.78, -Math.PI * 0.22)
            ctx.stroke()
        }
        ctx.fillStyle = on
        ctx.beginPath()
        ctx.arc(cx, cy, lw * 0.85, 0, Math.PI * 2)
        ctx.fill()
        if (offline) {
            ctx.strokeStyle = on
            ctx.beginPath()
            ctx.moveTo(w * 0.15, height * 0.12)
            ctx.lineTo(w * 0.85, height * 0.92)
            ctx.stroke()
        }
    }
}
