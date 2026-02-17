//
//  EasingShadowCard.swift
//  Shop feed playground
//
//  Multi-layered "eased" shadow that shifts direction and blur as you
//  drag across the card's surface, with 3D tilt.
//  Inspired by Philip Davis's EasingShadow prototype.
//

import SwiftUI

// MARK: - EasingShadowCard

struct EasingShadowCard: View {
    @State private var dragOffset: CGPoint = .zero
    @State private var yOffsetMax: CGFloat = 80
    @State private var xOffsetMax: CGFloat = 0
    @State private var blurMax: CGFloat = 70

    // MARK: Layout

    private enum Layout {
        static let layers: Int = 40
        static let blurFactor: CGFloat = 10
        static let yFactor: CGFloat = 10
        static let xFactor: CGFloat = 10
        static let intensity: CGFloat = 6
        static let innerWidth: CGFloat = 300
        static let innerHeight: CGFloat = 200
        static let cornerRadius: CGFloat = 24
        static let shadowScaleEffect: CGFloat = 0.92
        static let shadowGroupOpacity: Double = 0.9
        static let shadowLayerOpacityMultiplier: Double = 0.7
        static let shadowBaseYOffset: CGFloat = 3
        static let stackOffset: CGFloat = 20
        static let bgColor = Color(hex: 0xF0EDE8)
        static let gradientTop = Color.white
        static let gradientBottom = Color(hex: 0xF5F3EE)
        static let defaultYOffsetMax: CGFloat = 80
        static let defaultBlurMax: CGFloat = 70
        static let yOffsetMaxRange: CGFloat = 300
        static let xOffsetMaxRange: CGFloat = 80
        static let blurMaxRange: (low: CGFloat, high: CGFloat) = (20, 120)
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Layout.bgColor)

            CardHeader(subtitle: "Shadow study", title: "Drag to shift light")

            ZStack {
                shadowLayers
                mainCard
            }
            .offset(y: Layout.stackOffset)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }

    // MARK: Subviews

    private var shadowLayers: some View {
        ZStack {
            ForEach(1...Layout.layers, id: \.self) { i in
                let v = CGFloat(i)
                let opac = 1 - v / CGFloat(Layout.layers)
                let blur = lerp(inMin: 0, inMax: pow(CGFloat(Layout.layers), Layout.blurFactor), outMin: 0, outMax: blurMax, pow(v, Layout.blurFactor))
                let yOff = lerp(inMin: -200, inMax: pow(CGFloat(Layout.layers), Layout.yFactor), outMin: Layout.shadowBaseYOffset, outMax: yOffsetMax, pow(v, Layout.yFactor))
                let xOff = lerp(inMin: 0, inMax: pow(CGFloat(Layout.layers), Layout.xFactor), outMin: 0, outMax: xOffsetMax, pow(v, Layout.xFactor))

                RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                    .fill(Color.black.opacity(Double(opac) * Layout.shadowLayerOpacityMultiplier))
                    .scaleEffect(Layout.shadowScaleEffect)
                    .blur(radius: blur)
                    .frame(width: Layout.innerWidth, height: Layout.innerHeight)
                    .offset(x: xOff, y: yOff)
            }
        }
        .drawingGroup()
        .opacity(Layout.shadowGroupOpacity)
    }

    private var mainCard: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .fill(
                LinearGradient(colors: [Layout.gradientTop, Layout.gradientBottom],
                               startPoint: .top, endPoint: .bottom)
            )
            .frame(width: Layout.innerWidth, height: Layout.innerHeight)
            .rotation3DEffect(.degrees(dragOffset.x), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(dragOffset.y), axis: (x: 1, y: 0, z: 0))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { g in
                        let nx = lerp(inMin: 0, inMax: Layout.innerWidth, outMin: -Layout.intensity, outMax: Layout.intensity, g.location.x)
                        let ny = lerp(inMin: 0, inMax: Layout.innerHeight, outMin: Layout.intensity, outMax: -Layout.intensity, g.location.y)
                        withAnimation(.easeOut(duration: 0.2)) {
                            yOffsetMax = lerp(inMin: -Layout.intensity, inMax: Layout.intensity, outMin: 0, outMax: Layout.yOffsetMaxRange, ny)
                            xOffsetMax = -lerp(inMin: -Layout.intensity, inMax: Layout.intensity, outMin: -Layout.xOffsetMaxRange, outMax: Layout.xOffsetMaxRange, nx)
                            blurMax = lerp(inMin: -Layout.intensity, inMax: Layout.intensity, outMin: Layout.blurMaxRange.low, outMax: Layout.blurMaxRange.high, ny)
                            dragOffset = CGPoint(x: nx, y: ny)
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            dragOffset = .zero
                            yOffsetMax = Layout.defaultYOffsetMax
                            xOffsetMax = 0
                            blurMax = Layout.defaultBlurMax
                        }
                    }
            )
    }
}
