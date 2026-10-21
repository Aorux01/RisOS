import QtQuick

// Eye glyph for the "show password" toggle. crossed draws a slash over it.
Canvas {
    property color color: "#6b6e75"
    property bool crossed: true

    onColorChanged: requestPaint()
    onCrossedChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        var w = width
        var h = height
        var cy = h / 2
        ctx.strokeStyle = color
        ctx.fillStyle = color
        ctx.lineWidth = w * 0.08
        ctx.lineCap = "round"
        ctx.lineJoin = "round"

        ctx.beginPath()
        ctx.moveTo(w * 0.06, cy)
        ctx.quadraticCurveTo(w * 0.5, h * 0.02, w * 0.94, cy)
        ctx.quadraticCurveTo(w * 0.5, h * 0.98, w * 0.06, cy)
        ctx.closePath()
        ctx.stroke()

        ctx.beginPath()
        ctx.arc(w / 2, cy, w * 0.14, 0, Math.PI * 2)
        ctx.fill()

        if (crossed) {
            ctx.beginPath()
            ctx.moveTo(w * 0.16, h * 0.9)
            ctx.lineTo(w * 0.84, h * 0.1)
            ctx.stroke()
        }
    }
}
