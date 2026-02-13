//
//  PriceCheckCard.swift
//  Shop feed playground
//
//  "Price Check" card — guess the price with a ruler slider.
//  Haptic feedback while dragging. Reveal animation on lock-in.
//  Data: PriceCheckData.swift
//

import SwiftUI

// MARK: - Price Check Card

struct PriceCheckCard: View {
    @State private var currentProductIndex: Int = 0
    @State private var guessPrice: Int = 50
    @State private var isRevealed: Bool = false
    @State private var dragStartPrice: Int = 50
    @State private var isShuffling: Bool = false
    @State private var shuffleOut: Bool = false
    @State private var cardDrag: CGSize = .zero
    @State private var cardDragIntent: CardDragIntent = .undecided

    private enum CardDragIntent {
        case undecided, swiping, scrolling
    }

    private let products = PriceCheckProduct.defaults
    private var product: PriceCheckProduct { products[currentProductIndex] }
    private var nextProduct: PriceCheckProduct {
        products[(currentProductIndex + 1) % products.count]
    }

    var body: some View {
        ZStack {
            // Light gray background
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0xE8E8E8))
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
                )

            // Dot pattern background
            DotPatternView()
                .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
                .allowsHitTesting(false)

            // Header (title first, subtitle below)
            CardHeaderFlipped(title: "Price Check", subtitle: "Guess the price to receive a discount")
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                Spacer()

                // Product image (stacked cards look)
                productImageStack
                    .offset(y: 15)
                    .padding(.bottom, Tokens.space16)

                Spacer()

                // Ruler with integrated price bubble
                RulerView(
                    value: $guessPrice,
                    maxValue: product.maxPrice,
                    tickInterval: product.tickInterval,
                    isRevealed: isRevealed,
                    actualPrice: product.actualPrice,
                    bubbleColor: isRevealed ? resultColor : Color(hex: 0x5433EB)
                )
                .frame(height: 100)
                .padding(.bottom, Tokens.space12)

                // Lock in / Next button
                actionButton
                    .padding(.bottom, Tokens.space24)
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Subviews

private extension PriceCheckCard {
    var productImageStack: some View {
        ZStack {
            // Third card (deepest)
            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                .fill(.white)
                .frame(width: 273, height: 273)
                .rotationEffect(.degrees(6))
                .offset(x: 8, y: 6)
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)

            // Second card — becomes visible during shuffle
            Color.clear
                .frame(width: 273, height: 273)
                .background {
                    Image(nextProduct.imageName)
                        .resizable()
                        .scaledToFill()
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
                .rotationEffect(.degrees(shuffleOut ? 0 : 3))
                .offset(x: shuffleOut ? 0 : 4, y: shuffleOut ? 0 : 3)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)

            // Front card — draggable in any direction
            Color.clear
                .frame(width: 273, height: 273)
                .background {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFill()
                }
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                .rotationEffect(.degrees(Double(cardDrag.width) / 18))
                .offset(cardDrag)
                .opacity(shuffleOut ? 0 : 1)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 12)
                        .onChanged { value in
                            if cardDragIntent == .undecided {
                                let dx = abs(value.translation.width)
                                let dy = abs(value.translation.height)
                                let dist = hypot(dx, dy)
                                guard dist >= 14 else { return }
                                // If mostly vertical and small horizontal, let feed scroll
                                cardDragIntent = (dy > dx * 2.0 && dx < 20) ? .scrolling : .swiping
                            }
                            guard cardDragIntent == .swiping else { return }
                            cardDrag = value.translation
                        }
                        .onEnded { value in
                            defer { cardDragIntent = .undecided }
                            guard cardDragIntent == .swiping else {
                                withAnimation(Tokens.springDrag) {
                                    cardDrag = .zero
                                }
                                return
                            }

                            let velocity = CGSize(
                                width: value.predictedEndTranslation.width - value.translation.width,
                                height: value.predictedEndTranslation.height - value.translation.height
                            )
                            let speed = hypot(velocity.width, velocity.height)
                            let distance = hypot(cardDrag.width, cardDrag.height)

                            if distance > 80 || speed > 200 {
                                // Fling away in the drag direction
                                let norm = max(distance, 1)
                                let flyX = (cardDrag.width / norm) * 600
                                let flyY = (cardDrag.height / norm) * 600

                                withAnimation(.easeOut(duration: 0.25)) {
                                    cardDrag = CGSize(width: flyX, height: flyY)
                                    shuffleOut = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
                                    var tx = Transaction()
                                    tx.disablesAnimations = true
                                    withTransaction(tx) {
                                        shuffleOut = false
                                        cardDrag = .zero
                                        currentProductIndex = (currentProductIndex + 1) % products.count
                                        guessPrice = product.maxPrice / 3
                                        isRevealed = false
                                    }
                                }
                            } else {
                                // Snap back
                                withAnimation(Tokens.springDrag) {
                                    cardDrag = .zero
                                }
                            }
                        }
                )
        }
        .animation(Tokens.springDefault, value: shuffleOut)
    }

    var resultColor: Color {
        let diff = abs(guessPrice - product.actualPrice)
        if diff <= 5 { return Color(hex: 0x2AAA4A) }
        if diff <= 20 { return Color(hex: 0x8AAA2A) }
        if diff <= 50 { return Color(hex: 0xE8A020) }
        return Color(hex: 0xD83232)
    }

    var actionButton: some View {
        Button {
            if isRevealed {
                // Fling card off to the left, then advance
                withAnimation(.easeOut(duration: 0.25)) {
                    cardDrag = CGSize(width: -600, height: -40)
                    shuffleOut = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        shuffleOut = false
                        cardDrag = .zero
                        currentProductIndex = (currentProductIndex + 1) % products.count
                        guessPrice = product.maxPrice / 3
                        isRevealed = false
                    }
                }
            } else {
                // Lock in guess
                withAnimation(Tokens.springDrag) {
                    isRevealed = true
                }
                // Haptic on reveal
                let diff = abs(guessPrice - product.actualPrice)
                Haptics.notify(diff <= 10 ? .success : (diff <= 30 ? .warning : .error))
            }
        } label: {
            Text(isRevealed ? "Next" : "Lock it in")
                .font(.system(size: Tokens.bodySize, weight: .semibold))
                .tracking(Tokens.bodyTracking)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(
                    Capsule().fill(Color(hex: 0x5433EB))
                )
        }
    }
}

// MARK: - Triangle Shape

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            p.closeSubpath()
        }
    }
}

// MARK: - Dot Pattern Background

private struct DotPatternView: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 24
            let dotRadius: CGFloat = 2
            var y: CGFloat = 0
            while y < size.height {
                var x: CGFloat = 0
                while x < size.width {
                    let rect = CGRect(x: x - dotRadius, y: y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
                    context.fill(Path(ellipseIn: rect), with: .color(.black.opacity(0.06)))
                    x += spacing
                }
                y += spacing
            }
        }
    }
}

// MARK: - Ruler View

private struct RulerView: View {
    @Binding var value: Int
    let maxValue: Int
    let tickInterval: Int
    let isRevealed: Bool
    let actualPrice: Int
    let bubbleColor: Color

    @State private var dragIntent: DragIntent = .undecided

    private let smallTicksPerInterval = 10
    private let rulerTopOffset: CGFloat = 50  // space for bubble above ruler

    private enum DragIntent {
        case undecided
        case adjustingRuler
        case scrollingFeed
    }

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let dragRange = totalWidth - 32

            ZStack(alignment: .topLeading) {
                // Price bubble — follows the indicator
                let currentX = 16 + (dragRange * CGFloat(value) / CGFloat(maxValue))

                VStack(spacing: 0) {
                    Text("$\(value)")
                        .font(.system(size: 22, weight: .bold))
                        .tracking(-0.5)
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(bubbleColor)
                        )

                    Triangle()
                        .fill(bubbleColor)
                        .frame(width: 18, height: 8)
                }
                .position(x: currentX, y: 22)
                .animation(.interactiveSpring(), value: value)

                // Tick marks
                Canvas { context, size in
                    let totalTicks = (maxValue / tickInterval) * smallTicksPerInterval
                    let tickSpacing = dragRange / CGFloat(totalTicks)

                    for i in 0...totalTicks {
                        let x = 16 + CGFloat(i) * tickSpacing
                        let isMajor = i % smallTicksPerInterval == 0
                        let tickH: CGFloat = isMajor ? 26 : 14

                        let rect = CGRect(x: x - 0.75, y: rulerTopOffset, width: 1.5, height: tickH)
                        context.fill(Path(rect), with: .color(.black.opacity(isMajor ? 0.8 : 0.3)))

                        if isMajor {
                            let dollarValue = (i / smallTicksPerInterval) * tickInterval
                            let text = Text("\(dollarValue)")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.black.opacity(0.5))
                            context.draw(
                                context.resolve(text),
                                at: CGPoint(x: x, y: rulerTopOffset + 36),
                                anchor: .center
                            )
                        }
                    }
                }

                // Actual price indicator (shown after reveal)
                if isRevealed {
                    let actualX = 16 + (dragRange * CGFloat(actualPrice) / CGFloat(maxValue))
                    Rectangle()
                        .fill(bubbleColor)
                        .frame(width: 3, height: 30)
                        .offset(x: actualX - 1.5, y: rulerTopOffset)
                        .transition(.opacity)
                }

                // Current value indicator line
                Rectangle()
                    .fill(Color(hex: 0x5433EB))
                    .frame(width: 3, height: 30)
                    .offset(x: currentX - 1.5, y: rulerTopOffset)
            }
            .contentShape(Rectangle())
            .simultaneousGesture(
                isRevealed ? nil :
                DragGesture(minimumDistance: 8)
                    .onChanged { drag in
                        if dragIntent == .undecided {
                            let dx = drag.translation.width
                            let dy = drag.translation.height
                            let distance = hypot(dx, dy)
                            guard distance >= 12 else { return }
                            dragIntent = abs(dy) > abs(dx) * 1.12 ? .scrollingFeed : .adjustingRuler
                        }

                        guard dragIntent == .adjustingRuler else { return }
                        let x = drag.location.x - 16
                        let fraction = max(0, min(x / dragRange, 1))
                        let newValue = Int(fraction * CGFloat(maxValue))
                        if newValue != value { Haptics.selection() }
                        value = newValue
                    }
                    .onEnded { _ in
                        dragIntent = .undecided
                    }
            )
        }
        .padding(.horizontal, Tokens.space16)
    }
}
