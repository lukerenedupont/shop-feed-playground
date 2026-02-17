//
//  PhyllotaxisCard.swift
//  Shop feed playground
//
//  Sunflower-spiral dots that expand on press to reveal a rainbow
//  gradient underneath through cutout holes.
//  Inspired by Philip Davis's PhyllotaxisColorPicker prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let dotCount = 280
    static let dotRadius: Double = 6.5
    static let gradientSize: CGFloat = 300
    static let gradientCorner: CGFloat = 24
    static let spiralScale: CGFloat = 1.4
    static let centerHoleDiameter: CGFloat = 40
    static let centerDotExpanded: CGFloat = 45
    static let centerDotCollapsed: CGFloat = 32
    static let contentOffsetY: CGFloat = 30
    static let expandDelay: Double = 0.0008
    static let collapseDelay: Double = 0.0003
    static let thetaExpanded: Double = .pi * (3 - sqrt(5))
    static let thetaCollapsed: Double = .pi * (3 - sqrt(5)) - 0.0005
}

// MARK: - Phyllotaxis Card

struct PhyllotaxisCard: View {
    @State private var expanded = false

    private var theta: Double { expanded ? Layout.thetaExpanded : Layout.thetaCollapsed }

    // MARK: Helpers

    private func offset(for i: Int) -> CGSize {
        let r = Layout.dotRadius * Double(i).squareRoot()
        let a = theta * Double(i)
        return CGSize(width: r * cos(a), height: r * sin(a))
    }

    private func dotSize(for i: Int) -> CGFloat {
        CGFloat(i) / CGFloat(Layout.dotCount) * Layout.dotRadius
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))

            CardHeader(subtitle: "Color picker", title: "Press and hold", lightText: true)

            // MARK: Spiral

            ZStack {
                AngularGradient(
                    gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]),
                    center: .center
                )
                .saturation(1.5)
                .frame(width: Layout.gradientSize, height: Layout.gradientSize)
                .clipShape(RoundedRectangle(cornerRadius: Layout.gradientCorner, style: .continuous))

                ZStack {
                    Color(hex: 0x0E0E0E)
                        .frame(width: Layout.gradientSize, height: Layout.gradientSize)

                    ZStack {
                        ForEach(1..<Layout.dotCount, id: \.self) { i in
                            Circle()
                                .fill(.white)
                                .frame(width: dotSize(for: i), height: dotSize(for: i))
                                .offset(expanded ? offset(for: i) : .zero)
                                .animation(
                                    .spring().delay(expanded
                                        ? Double(Layout.dotCount - i) * Layout.expandDelay
                                        : Double(i) * Layout.collapseDelay),
                                    value: expanded
                                )
                                .blendMode(.destinationOut)
                        }
                    }
                    .scaleEffect(Layout.spiralScale)

                    ZStack {
                        Circle().fill(.white)
                            .frame(width: Layout.centerHoleDiameter)
                            .blendMode(.destinationOut)
                        Circle().fill(Color(hex: 0x0E0E0E))
                            .frame(width: expanded ? Layout.centerDotExpanded : Layout.centerDotCollapsed)
                            .animation(.spring(), value: expanded)
                    }
                }
                .compositingGroup()
            }
            .drawingGroup()
            .offset(y: Layout.contentOffsetY)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !expanded {
                            Haptics.light()
                            withAnimation(.spring()) { expanded = true }
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) { expanded = false }
                    }
            )
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}
