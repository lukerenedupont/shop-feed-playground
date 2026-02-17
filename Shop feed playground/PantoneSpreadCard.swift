//
//  PantoneSpreadCard.swift
//  Shop feed playground
//
//  Pantone-style color swatch fan — tap or drag to spread/close.
//  Inspired by Philip Davis's PantoneSpread prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let swatchWidth: CGFloat = 60
    static let swatchHeight: CGFloat = 200
    static let swatchShadowOpacity: Double = 0.3
    static let swatchShadowRadius: CGFloat = 6
    static let swatchOffsetX: CGFloat = 40
    static let anchorX: CGFloat = 50
    static let anchorBottomInset: CGFloat = 60
    static let spreadAngle: CGFloat = 90
    static let snapThreshold: CGFloat = 45
    static let velocityThreshold: CGFloat = 100
    static let atanCenterX: CGFloat = 30
    static let atanCenterY: CGFloat = 100
    static let innerSwatchSpacing: CGFloat = 4
    static let innerSwatchRadius: CGFloat = 8
    static let outerSwatchRadius: CGFloat = 16
    static let outerPadding: CGFloat = 4
    static let outerSwatchRadius2: CGFloat = 20
}

// MARK: - Pantone Spread Card

struct PantoneSpreadCard: View {
    @State private var angle: CGFloat = 0
    @State private var lastAngle: CGFloat = 0

    private let swatches: [Color] = [
        Color(hex: 0xE84855), Color(hex: 0xF9DC5C), Color(hex: 0x3BB273),
        Color(hex: 0x2EC4B6), Color(hex: 0x5B7AFF), Color(hex: 0x1A1A1A),
    ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))

            CardHeader(subtitle: "Color palette", title: "Fan to explore", lightText: true)

            // MARK: Swatch Fan

            ZStack {
                ForEach(0..<swatches.count, id: \.self) { i in
                    let damp = CGFloat(i + 1) / CGFloat(swatches.count)

                    SwatchView(color: swatches[i])
                        .frame(width: Layout.swatchWidth, height: Layout.swatchHeight)
                        .shadow(color: .black.opacity(Layout.swatchShadowOpacity),
                                radius: Layout.swatchShadowRadius)
                        .offset(x: Layout.swatchOffsetX)
                        .rotationEffect(
                            .degrees(Double(angle) * Double(damp)),
                            anchor: .bottomTrailing
                        )
                }
            }
            .position(x: Layout.anchorX, y: Tokens.cardHeight - Layout.anchorBottomInset)
            .onTapGesture {
                withAnimation(.spring()) {
                    if angle == 0 {
                        angle = Layout.spreadAngle
                        lastAngle = Layout.spreadAngle
                    } else {
                        angle = 0
                        lastAngle = 0
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { g in
                        var theta = (atan2(g.location.x - Layout.atanCenterX,
                                           Layout.atanCenterY - g.location.y)
                            - atan2(g.startLocation.x - Layout.atanCenterX,
                                    Layout.atanCenterY - g.startLocation.y)) * 180 / .pi
                        if theta < 0 { theta += 360 }
                        angle = theta + lastAngle
                    }
                    .onEnded { g in
                        let vx = g.predictedEndLocation.x - g.location.x
                        if vx > Layout.velocityThreshold || angle >= Layout.snapThreshold {
                            withAnimation(.spring()) { angle = Layout.spreadAngle }
                        } else {
                            withAnimation(.spring()) { angle = 0 }
                        }
                        lastAngle = angle
                    }
            )
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Swatch View

private struct SwatchView: View {
    let color: Color

    var body: some View {
        VStack(spacing: Layout.innerSwatchSpacing) {
            RoundedRectangle(cornerRadius: Layout.innerSwatchRadius, style: .continuous).fill(color)
            RoundedRectangle(cornerRadius: Layout.innerSwatchRadius, style: .continuous).fill(color).brightness(0.3)
            RoundedRectangle(cornerRadius: Layout.innerSwatchRadius, style: .continuous).fill(color).brightness(0.5)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: Layout.outerSwatchRadius, style: .continuous))
        .padding(Layout.outerPadding)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: Layout.outerSwatchRadius2, style: .continuous))
    }
}
