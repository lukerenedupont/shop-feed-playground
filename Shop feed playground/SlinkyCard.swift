//
//  SlinkyCard.swift
//  Shop feed playground
//
//  Trailing concentric circles that chase your finger with staggered
//  spring delays, creating a slinky/trail effect.
//  Inspired by Philip Davis's Slinky prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let ringCount = 30
    static let ringDiameter: CGFloat = 100
    static let ringLineWidth: CGFloat = 1.5
    static let ringMaxOpacity: Double = 0.6
    static let springBase: Double = 0.08
    static let springStep: Double = 0.06
    static let springDamping: Double = 0.82
    static let defaultX: CGFloat = 188
    static let defaultY: CGFloat = 322
}

// MARK: - Slinky Card

struct SlinkyCard: View {
    @State private var point = CGPoint(x: Layout.defaultX, y: Layout.defaultY)

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))

            CardHeader(subtitle: "Interactive", title: "Touch and drag", lightText: true)

            // MARK: Ring Trail

            ZStack {
                ForEach(0..<Layout.ringCount, id: \.self) { i in
                    Circle()
                        .strokeBorder(
                            Color.white.opacity(Double(Layout.ringCount - i) / Double(Layout.ringCount) * Layout.ringMaxOpacity),
                            lineWidth: Layout.ringLineWidth
                        )
                        .frame(width: Layout.ringDiameter)
                        .position(point)
                        .animation(
                            .spring(response: Double(i) * Layout.springStep + Layout.springBase,
                                    dampingFraction: Layout.springDamping),
                            value: point
                        )
                        .zIndex(-Double(i))
                }
            }
            .allowsHitTesting(false)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { g in point = g.location }
        )
    }
}
