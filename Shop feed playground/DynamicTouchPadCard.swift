//
//  DynamicTouchPadCard.swift
//  Shop feed playground
//
//  Dense dot grid that reactively bulges toward your finger on drag,
//  with a ripple-pulse on tap.
//  Inspired by Philip Davis's DynamicTouchPad prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let rows = 30
    static let cols = 16
    static let spacing: CGFloat = 14
    static let dotSize: CGFloat = 4
    static let dotCorner: CGFloat = 2
    static let influenceRadius: CGFloat = 80.0
    static let maxNorm: CGFloat = 2.5
    static let peakScale: CGFloat = 3.5
    static let minScale: CGFloat = 0.5
    static let gridOffsetX: CGFloat = 20
    static let gridOffsetY: CGFloat = 50
}

// MARK: - Helpers

private extension DynamicTouchPadCard {
    static func dotScale(cell: Int, row: Int, point: CGPoint) -> CGFloat {
        let px = Layout.spacing + CGFloat(cell) * (Layout.dotSize + Layout.spacing)
        let py = Layout.spacing + CGFloat(row) * (Layout.dotSize + Layout.spacing)
        let dist = hypot(Float(px - point.x), Float(py - point.y))
        let norm = min(Layout.maxNorm, max(0, CGFloat(dist) / Layout.influenceRadius * Layout.maxNorm))
        return norm
    }
}

// MARK: - Dynamic Touch Pad Card

struct DynamicTouchPadCard: View {
    @State private var touchPoint: CGPoint = .zero
    @State private var isDragging = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))

            CardHeader(subtitle: "Touch pad", title: "Drag to ripple", lightText: true)

            // MARK: Dot Grid

            ZStack {
                ForEach(0..<Layout.rows, id: \.self) { row in
                    ForEach(0..<Layout.cols, id: \.self) { cell in
                        let s = isDragging
                            ? Layout.peakScale - Self.dotScale(cell: cell, row: row, point: touchPoint)
                            : 1.0
                        RoundedRectangle(cornerRadius: Layout.dotCorner, style: .continuous)
                            .fill(.white)
                            .frame(width: Layout.dotSize, height: Layout.dotSize)
                            .scaleEffect(max(Layout.minScale, s))
                            .position(
                                x: Layout.spacing + CGFloat(cell) * (Layout.dotSize + Layout.spacing),
                                y: Layout.spacing + CGFloat(row) * (Layout.dotSize + Layout.spacing)
                            )
                    }
                }
            }
            .allowsHitTesting(false)
            .offset(x: Layout.gridOffsetX, y: Layout.gridOffsetY)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { g in
                    withAnimation(.interactiveSpring()) {
                        touchPoint = CGPoint(x: g.location.x - Layout.gridOffsetX,
                                             y: g.location.y - Layout.gridOffsetY)
                        isDragging = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring()) { isDragging = false }
                }
        )
    }
}
