//
//  BoomerangCard.swift
//  Shop feed playground
//
//  Swipeable product card stack — flick the top card up to send it
//  boomeranging behind the deck with rotation physics.
//  Inspired by Philip Davis's Boomerang prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let cardW: CGFloat = 300
    static let cardH: CGFloat = 200
    static let startY: CGFloat = 400
    static let flick: Double = 0.17

    static let imageInsetH: CGFloat = 40
    static let imageInsetV: CGFloat = 60
    static let innerRadius: CGFloat = 20
    static let imageRadius: CGFloat = 14
    static let shadowOpacity: Double = 0.2
    static let shadowRadius: CGFloat = 10
    static let shadowY: CGFloat = 6

    static let scaleMin: CGFloat = 0.75
    static let scaleMax: CGFloat = 1.0
    static let stackMin: CGFloat = 0
    static let stackMax: CGFloat = 4
    static let positionMin: CGFloat = 1
    static let positionMax: CGFloat = 4
    static let offsetOutMin: CGFloat = 50
    static let offsetOutMax: CGFloat = 0

    static let flickThreshold: CGFloat = -200
    static let velocityDivisor: CGFloat = 1500
    static let velocityThreshold: Double = 0.01
    static let rotationMax: CGFloat = 3
    static let flickYMin: CGFloat = -400
    static let flickYMax: CGFloat = 200
}

// MARK: - Boomerang Card

struct BoomerangCard: View {
    @State private var topCard = 1

    private let products: [(image: String, color: Color)] = [
        ("BlueShoe1", Color(hex: 0x3A6FB5)),
        ("GreenShoe1", Color(hex: 0x3A7D4A)),
        ("BrownShoe1", Color(hex: 0x8B6F4E)),
        ("BlackShoe1", Color(hex: 0x2A2A2A)),
    ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))
            CardHeader(subtitle: "Swipe up", title: "Flick to browse", lightText: true)
            ZStack {
                ForEach((1...4).reversed(), id: \.self) { index in
                    BoomerangItem(
                        product: products[index - 1],
                        index: index,
                        topCard: $topCard
                    )
                }
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Single Boomerang Item

private struct BoomerangItem: View {
    let product: (image: String, color: Color)
    let index: Int
    @Binding var topCard: Int

    @State private var rotation: Double = 0
    @State private var zIdx: Double = 0
    @State private var dragY: CGFloat = Layout.startY

    // MARK: Helpers

    private let order: [[Int]] = [
        [1, 2, 3, 4],
        [2, 3, 4, 1],
        [3, 4, 1, 2],
        [4, 1, 2, 3],
    ]

    private func position() -> Int {
        order[topCard - 1].firstIndex(of: index) ?? 0
    }

    private func sizeScale() -> CGFloat {
        lerp(inMin: Layout.stackMin, inMax: Layout.stackMax,
             outMin: Layout.scaleMin, outMax: Layout.scaleMax,
             CGFloat(4 - position()))
    }

    private func offsetY() -> CGFloat {
        lerp(inMin: Layout.positionMin, inMax: Layout.positionMax,
             outMin: Layout.offsetOutMin, outMax: Layout.offsetOutMax,
             CGFloat(position()))
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Layout.innerRadius, style: .continuous)
                .fill(product.color)
            Image(product.image)
                .resizable()
                .scaledToFill()
                .frame(width: Layout.cardW - Layout.imageInsetH,
                       height: Layout.cardH - Layout.imageInsetV)
                .clipShape(RoundedRectangle(cornerRadius: Layout.imageRadius, style: .continuous))
        }
        .frame(width: Layout.cardW, height: Layout.cardH)
        .clipShape(RoundedRectangle(cornerRadius: Layout.innerRadius, style: .continuous))
        .shadow(color: .black.opacity(Layout.shadowOpacity),
                radius: Layout.shadowRadius, x: 0, y: Layout.shadowY)
        .rotationEffect(.degrees(rotation))
        .scaleEffect(sizeScale())
        .position(x: Tokens.cardWidth / 2, y: dragY)
        .zIndex(zIdx)
        .offset(y: offsetY())
        .animation(.spring(), value: topCard)
        .gesture(
            topCard == index ?
            DragGesture()
                .onChanged { g in dragY = g.translation.height + Layout.startY }
                .onEnded { g in
                    let predicted = g.predictedEndTranslation.height
                    let vel = abs(predicted - g.translation.height) / Layout.velocityDivisor
                    let shouldRotate = vel > Layout.velocityThreshold

                    if predicted <= Layout.flickThreshold {
                        topCard = topCard < 4 ? topCard + 1 : 1

                        if shouldRotate {
                            let rotAmt = round(lerp(inMin: 0, inMax: 1,
                                                    outMin: 0, outMax: Layout.rotationMax, vel))
                            withAnimation(.easeOut(duration: Layout.flick)) {
                                dragY = lerp(inMin: 0, inMax: 1,
                                             outMin: Layout.flickYMin, outMax: Layout.flickYMax,
                                             1 - vel)
                                rotation -= rotAmt * 180
                            }
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + (shouldRotate ? Layout.flick : 0)) {
                            zIdx -= 1
                        }

                        withAnimation(.spring().delay(shouldRotate ? Layout.flick : 0)) {
                            dragY = Layout.startY
                            if shouldRotate {
                                rotation -= round(lerp(inMin: 0, inMax: 1,
                                                       outMin: 0, outMax: Layout.rotationMax, vel)) * 180
                            }
                        }
                    } else {
                        withAnimation(.spring()) { dragY = Layout.startY }
                    }
                }
            : nil
        )
        .allowsHitTesting(topCard == index)
    }
}
