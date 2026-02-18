//
//  MagnifyGridCard.swift
//  Shop feed playground
//
//  Interactive product grid — drag to magnify nearby items.
//  Products warp toward your finger and scale up based on proximity.
//  Inspired by Philip Davis's DynamicGrid prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let cols = 6
    static let rows = 8
    static let spacing: CGFloat = 6
    static let cellSize: CGFloat = 52
    static let orbRadius: CGFloat = 90
    static let pullRange: CGFloat = 500
}

// MARK: - Magnify Grid Card

struct MagnifyGridCard: View {
    @State private var touchPoint: CGPoint = .zero
    @State private var isDragging = false

    private let images: [String] = {
        let all = [
            "BlueShoe1", "BlueShoe2", "BlueShoe3", "BlueShoe4", "BlueShoe5", "BlueShoe6",
            "SilverShoe1", "SilverShoe2", "SilverShoe3", "SilverShoe4", "SilverShoe5", "SilverShoe6",
            "GreenShoe1", "GreenShoe2", "GreenShoe3", "GreenShoe4", "GreenShoe5", "GreenShoe6",
            "WhiteShoe1", "WhiteShoe2", "WhiteShoe3", "WhiteShoe4", "WhiteShoe5", "WhiteShoe6",
            "BrownShoe1", "BrownShoe2", "BrownShoe3", "BrownShoe4", "BrownShoe5", "BrownShoe6",
            "BlackShoe1", "BlackShoe2", "BlackShoe3", "BlackShoe4", "BlackShoe5", "BlackShoe6",
            "BlueShoe1", "BlueShoe2", "BlueShoe3", "BlueShoe4", "BlueShoe5", "BlueShoe6",
            "SilverShoe1", "SilverShoe2", "SilverShoe3", "SilverShoe4", "SilverShoe5", "SilverShoe6",
        ]
        return all.shuffled()
    }()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )

            header

            grid
                .offset(y: 40)

            dragHint
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Header

private extension MagnifyGridCard {
    var header: some View {
        CardHeader(subtitle: "Discover", title: "Explore products", lightText: true)
    }
}

// MARK: - Drag Hint

private extension MagnifyGridCard {
    var dragHint: some View {
        VStack {
            Spacer()
            Text(isDragging ? "" : "Touch and drag to explore")
                .shopTextStyle(.caption)
                .foregroundColor(.white.opacity(0.35))
                .padding(.bottom, 24)
        }
        .allowsHitTesting(false)
        .animation(.easeInOut(duration: 0.2), value: isDragging)
    }
}

// MARK: - Grid

private extension MagnifyGridCard {
    var grid: some View {
        ZStack {
            ForEach(0..<Layout.rows, id: \.self) { row in
                ForEach(0..<Layout.cols, id: \.self) { col in
                    let idx = row * Layout.cols + col
                    gridCell(row: row, col: col, image: images[idx % images.count])
                }
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    withAnimation(.interactiveSpring()) {
                        touchPoint = gesture.location
                        isDragging = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        isDragging = false
                    }
                }
        )
    }

    func gridCell(row: Int, col: Int, image: String) -> some View {
        let origin = cellOrigin(row: row, col: col)
        let dist = isDragging ? distance(origin, touchPoint) : 0
        let pull = isDragging ? Swift.max(0, 1 - dist / Layout.pullRange) : 0

        let orbPos = orbPosition(origin: origin, pull: pull)
        let pos = isDragging ? orbPos : origin

        let scale = isDragging ? (0.4 + pull * 0.8) : 1.0
        let opacity = isDragging ? (0.15 + pull * 0.85) : 1.0

        return Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.cellSize, height: Layout.cellSize)
            .clipShape(RoundedRectangle(cornerRadius: isDragging ? Layout.cellSize * pull * 0.5 : 4, style: .continuous))
            .scaleEffect(scale)
            .opacity(opacity)
            .position(pos)
            .zIndex(Double(pull) * 100)
            .shadow(color: .black.opacity(pull > 0.5 ? 0.3 : 0), radius: 6, x: 0, y: 3)
            .allowsHitTesting(false)
    }
}

// MARK: - Grid Math

private extension MagnifyGridCard {
    func cellOrigin(row: Int, col: Int) -> CGPoint {
        let totalW = CGFloat(Layout.cols) * (Layout.cellSize + Layout.spacing) - Layout.spacing
        let totalH = CGFloat(Layout.rows) * (Layout.cellSize + Layout.spacing) - Layout.spacing
        let startX = (Tokens.cardWidth - totalW) / 2 + Layout.cellSize / 2
        let startY = (Tokens.cardHeight - totalH) / 2 + Layout.cellSize / 2

        return CGPoint(
            x: startX + CGFloat(col) * (Layout.cellSize + Layout.spacing),
            y: startY + CGFloat(row) * (Layout.cellSize + Layout.spacing)
        )
    }

    func orbPosition(origin: CGPoint, pull: CGFloat) -> CGPoint {
        let dist = distance(origin, touchPoint)
        guard dist > 0.1 else { return touchPoint }

        let dx = origin.x - touchPoint.x
        let dy = origin.y - touchPoint.y
        let angle = atan2(dy, dx)

        let orbDist = Layout.orbRadius * (1 - pull * 0.6)
        let targetX = touchPoint.x + cos(angle) * orbDist
        let targetY = touchPoint.y + sin(angle) * orbDist

        return CGPoint(
            x: origin.x + (targetX - origin.x) * pull,
            y: origin.y + (targetY - origin.y) * pull
        )
    }

    func distance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
        return hypot(p1.x - p2.x, p1.y - p2.y)
    }
}

