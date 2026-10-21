import QtQuick

// Power glyph: an open circle with a vertical bar.
Canvas {
    property color color: "#22262f"

    onColorChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        var w = width
        var h = height
        ctx.strokeStyle = color
        ctx.lineWidth = w * 0.09
        ctx.lineCap = "round"
        var cx = w / 2
        var cy = h * 0.54
        var r = w * 0.33
        ctx.beginPath()
        ctx.arc(cx, cy, r, -Math.PI / 2 + 0.6, -Math.PI / 2 - 0.6 + Math.PI * 2)
        ctx.stroke()
        ctx.beginPath()
        ctx.moveTo(cx, h * 0.12)
        ctx.lineTo(cx, h * 0.46)
        ctx.stroke()
    }
}
