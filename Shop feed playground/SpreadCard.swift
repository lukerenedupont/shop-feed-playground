//
//  SpreadCard.swift
//  Shop feed playground
//
//  Product spread card — drag to fan out a stack of product cards.
//  Inspired by Philip Davis's Spread prototype.
//
//  Shared: SharedComponents.swift
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let stackSize: CGFloat  = 140
    static let stackCorner: CGFloat = 18
    static let cardCount: Int      = 8
    static let stackY: CGFloat     = 280

    static let expandSpring = Animation.spring(response: 0.5, dampingFraction: 0.75)
}

// MARK: - Spread Card

struct SpreadCard: View {
    @State private var isDragging = false
    @State private var isRotating = false
    @State private var offset = CGSize.zero
    @State private var angle: CGFloat = 0

    private let products = [
        ("BlueShoe1", Color(hex: 0x3A6FB5)),
        ("BlueShoe2", Color(hex: 0x4A7FC5)),
        ("BlueShoe3", Color(hex: 0x2A5FA5)),
        ("BlueShoe4", Color(hex: 0x5A8FD5)),
        ("BlueShoe5", Color(hex: 0x1A4F95)),
        ("BlueShoe6", Color(hex: 0x6A9FE5)),
        ("SilverShoe1", Color(hex: 0xA0A0A0)),
        ("SilverShoe2", Color(hex: 0xB8B8B8)),
    ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x1A1A1A))
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )

            header

            productStack

            dragHint
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Header

private extension SpreadCard {
    var header: some View {
        CardHeader(subtitle: "Explore", title: "New arrivals", lightText: true)
    }
}

// MARK: - Drag Hint

private extension SpreadCard {
    var dragHint: some View {
        VStack(spacing: 4) {
            Spacer()
            Text(isDragging || isRotating ? "" : "Drag to explore")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.35))
                .padding(.bottom, 28)
        }
        .allowsHitTesting(false)
        .animation(.easeInOut(duration: 0.2), value: isDragging)
    }
}

// MARK: - Product Stack

private extension SpreadCard {
    var productStack: some View {
        ZStack {
            ForEach(0..<products.count, id: \.self) { i in
                spreadProduct(index: i)
            }
        }
        .position(x: Tokens.cardWidth / 2, y: Layout.stackY)
    }

    func spreadProduct(index i: Int) -> some View {
        let count = CGFloat(products.count)
        let dampFrac = lerp(inMin: 0, inMax: count, outMin: 0, outMax: 1, CGFloat(i))

        let ox = isRotating ? 0 : offset.width * dampFrac
        let oy = isRotating ? 0 : offset.height * dampFrac
        let rot = isRotating
            ? Double(angle) * Double(dampFrac)
            : Double(-lerp(inMin: -200, inMax: 200, outMin: -12, outMax: 12, offset.width * dampFrac))
        let bright = lerp(inMin: 0, inMax: count, outMin: -0.45, outMax: 0, CGFloat(i))
        let anchor: UnitPoint = isRotating ? .bottomLeading : .center

        return Image(products[i].0)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.stackSize, height: Layout.stackSize)
            .clipShape(RoundedRectangle(cornerRadius: Layout.stackCorner, style: .continuous))
            .brightness(Double(bright))
            .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
            .offset(x: ox, y: oy)
            .rotationEffect(.degrees(rot), anchor: anchor)
            .gesture(dragGesture)
    }
}

// MARK: - Gesture

private extension SpreadCard {
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.startLocation.y >= 15 {
                    offset = gesture.translation
                    isDragging = true
                    isRotating = false
                } else {
                    isRotating = true
                    isDragging = false
                    var theta = (atan2(
                        gesture.location.x - 50,
                        50 - gesture.location.y
                    ) - atan2(
                        gesture.startLocation.x - 50,
                        50 - gesture.startLocation.y
                    )) * 180 / .pi
                    if theta < 0 { theta += 360 }
                    angle = theta
                }
            }
            .onEnded { gesture in
                if isDragging {
                    withAnimation(Layout.expandSpring) {
                        offset = CGSize(
                            width: gesture.predictedEndTranslation.width,
                            height: gesture.predictedEndTranslation.height
                        )
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        isDragging = false
                        withAnimation(Layout.expandSpring) {
                            offset = .zero
                        }
                    }
                } else {
                    let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
                    let deceleration = decelerationRate / (1000.0 * (1.0 - decelerationRate))
                    let velocity = (gesture.predictedEndLocation.y - gesture.location.y) / deceleration
                    if velocity > 600 {
                        withAnimation(.spring()) { angle = 360 }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.interpolatingSpring(mass: 1, stiffness: 20, damping: 40, initialVelocity: 1)) {
                            isRotating = false
                        }
                    }
                }
            }
    }
}

