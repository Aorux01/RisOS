import QtQuick

// Battery glyph. percent 0..100. When charging, a bolt is drawn to the left of the body.
Canvas {
    property color color: "#22262f"
    property int percent: 100
    property bool charging: false

    onColorChanged: requestPaint()
    onPercentChanged: requestPaint()
    onChargingChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        var w = width
        var h = height
        var lw = h * 0.085
        ctx.lineWidth = lw
        ctx.lineJoin = "round"
        ctx.lineCap = "round"

        // Body (right part of the canvas)
        var bx = w * 0.22 + lw / 2
        var bw = w * 0.7 - lw
        var by = h * 0.26
        var bh = h * 0.48
        var r = bh * 0.28
        ctx.strokeStyle = color
        ctx.beginPath()
        ctx.moveTo(bx + r, by)
        ctx.lineTo(bx + bw - r, by)
        ctx.quadraticCurveTo(bx + bw, by, bx + bw, by + r)
        ctx.lineTo(bx + bw, by + bh - r)
        ctx.quadraticCurveTo(bx + bw, by + bh, bx + bw - r, by + bh)
        ctx.lineTo(bx + r, by + bh)
        ctx.quadraticCurveTo(bx, by + bh, bx, by + bh - r)
        ctx.lineTo(bx, by + r)
        ctx.quadraticCurveTo(bx, by, bx + r, by)
        ctx.closePath()
        ctx.stroke()

        // Nub
        ctx.fillStyle = color
        ctx.fillRect(bx + bw + lw * 0.6, by + bh * 0.3, lw * 1.1, bh * 0.4)

        // Level
        var low = percent <= 15 && !charging
        ctx.fillStyle = low ? "#D9604F" : color
        var pad = lw * 1.4
        var fw = Math.max(0, (bw - pad * 2) * Math.min(100, percent) / 100)
        ctx.fillRect(bx + pad, by + pad, fw, bh - pad * 2)

        // Bolt
        if (charging) {
            ctx.fillStyle = color
            ctx.beginPath()
            ctx.moveTo(w * 0.13, h * 0.2)
            ctx.lineTo(w * 0.04, h * 0.54)
            ctx.lineTo(w * 0.11, h * 0.54)
            ctx.lineTo(w * 0.08, h * 0.8)
            ctx.lineTo(w * 0.19, h * 0.44)
            ctx.lineTo(w * 0.12, h * 0.44)
            ctx.closePath()
            ctx.fill()
        }
    }
}
