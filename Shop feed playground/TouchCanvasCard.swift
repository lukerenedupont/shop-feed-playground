//
//  TouchCanvasCard.swift
//  Shop feed playground
//
//  Dot grid where points gravitationally warp toward your drag
//  position and snap back on release. Close dots glow teal.
//  Inspired by Philip Davis's TouchCanvas prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let rows = 22
    static let cols = 30
    static let spacing: CGFloat = 12
    static let dotSize: CGFloat = 4

    static let gridOffsetX: CGFloat = 16
    static let gridOffsetY: CGFloat = 60

    static let warpField: CGFloat = 1000
    static let warpStrength: CGFloat = 20
    static let nearThreshold: CGFloat = 0.05

    static let highlightColor: UInt = 0x2EC4B6
    static let dotOpacity: Double = 0.2
}

// MARK: - Touch Canvas Card

struct TouchCanvasCard: View {
    @State private var touchPoint: CGPoint = .zero
    @State private var isDragging = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))

            CardHeader(subtitle: "Canvas", title: "Drag to warp", lightText: true)

            dotGrid
                .offset(x: Layout.gridOffsetX, y: Layout.gridOffsetY)
                .drawingGroup()
                .allowsHitTesting(false)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .contentShape(Rectangle())
        .gesture(dragGesture)
    }
}

// MARK: - Dot Grid

private extension TouchCanvasCard {
    var dotGrid: some View {
        ZStack {
            ForEach(0..<Layout.rows, id: \.self) { row in
                ForEach(0..<Layout.cols, id: \.self) { col in
                    let origin = CGPoint(
                        x: CGFloat(col) * Layout.spacing,
                        y: CGFloat(row) * Layout.spacing
                    )
                    let pos = isDragging ? warpedPos(origin: origin) : origin
                    let isClose = isDragging && isNear(origin: origin)

                    Circle()
                        .fill(isClose ? Color(hex: Layout.highlightColor) : .white.opacity(Layout.dotOpacity))
                        .frame(width: Layout.dotSize, height: Layout.dotSize)
                        .position(pos)
                }
            }
        }
    }
}

// MARK: - Gesture

private extension TouchCanvasCard {
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { g in
                withAnimation(.spring()) {
                    touchPoint = CGPoint(
                        x: g.location.x - Layout.gridOffsetX,
                        y: g.location.y - Layout.gridOffsetY
                    )
                    isDragging = true
                }
            }
            .onEnded { _ in
                withAnimation(.spring()) { isDragging = false }
            }
    }
}

// MARK: - Warp Math

private extension TouchCanvasCard {
    func warpedPos(origin: CGPoint) -> CGPoint {
        let dist = hypot(origin.x - touchPoint.x, origin.y - touchPoint.y)
        var norm = dist / Layout.warpField * Layout.warpStrength
        norm = min(1, max(0, norm))

        let x = origin.x * norm + touchPoint.x * (1 - norm)
        let y = origin.y * norm + touchPoint.y * (1 - norm)
        return CGPoint(x: x, y: y)
    }

    func isNear(origin: CGPoint) -> Bool {
        let dist = hypot(origin.x - touchPoint.x, origin.y - touchPoint.y)
        return dist / Layout.warpField <= Layout.nearThreshold
    }
}
