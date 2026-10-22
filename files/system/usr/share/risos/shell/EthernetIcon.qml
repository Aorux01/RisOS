import QtQuick

// Wired network glyph: a node with a stem and a bar.
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
        ctx.lineWidth = w * 0.085
        ctx.lineCap = "round"
        ctx.lineJoin = "round"
        var r = w * 0.1
        var x0 = w * 0.18, x1 = w * 0.82, y0 = h * 0.16, y1 = h * 0.6
        ctx.beginPath()
        ctx.moveTo(x0 + r, y0)
        ctx.lineTo(x1 - r, y0)
        ctx.quadraticCurveTo(x1, y0, x1, y0 + r)
        ctx.lineTo(x1, y1 - r)
        ctx.quadraticCurveTo(x1, y1, x1 - r, y1)
        ctx.lineTo(x0 + r, y1)
        ctx.quadraticCurveTo(x0, y1, x0, y1 - r)
        ctx.lineTo(x0, y0 + r)
        ctx.quadraticCurveTo(x0, y0, x0 + r, y0)
        ctx.closePath()
        ctx.stroke()
        ctx.beginPath()
        ctx.moveTo(w / 2, y1)
        ctx.lineTo(w / 2, h * 0.82)
        ctx.moveTo(w * 0.25, h * 0.82)
        ctx.lineTo(w * 0.75, h * 0.82)
        ctx.stroke()
    }
}
