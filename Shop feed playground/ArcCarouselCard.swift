//
//  ArcCarouselCard.swift
//  Shop feed playground
//
//  "What they're wearing" A24 card — portrait cards on an arc.
//  Swipe one at a time; tap to expand with product rail.
//  Data: ArcCarouselData.swift
//

import SwiftUI

private enum ArcMetrics {
    static let arcRadius: CGFloat = 900
    static let anglePerCard: CGFloat = 16.25
    static let cardWidth: CGFloat = 208
    static let cardHeight: CGFloat = 260
    static let expandedCardWidth: CGFloat = 310
    static let expandedCardHeight: CGFloat = 460
    static let dragPerCard: CGFloat = 132
    static let arcYOffset: CGFloat = 132
    static let expandedYOffset: CGFloat = 0
    static let sideExitX: CGFloat = 500
    static let centeredDistanceThreshold: CGFloat = 0.3
    static let centeredDragThreshold: CGFloat = 15
    static let swipeThreshold: CGFloat = 30
    static let closeButtonDelay: TimeInterval = 0.45
    static let closeButtonFadeDuration: TimeInterval = 0.2
}

private struct ArcCardState {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let angle: Double
    let opacity: Double
    let zIndex: Double
    let isExpanded: Bool
    let isCentered: Bool
}

// MARK: - Arc Carousel Card

struct ArcCarouselCard: View {
    @State private var currentIndex: Int = 2
    @State private var dragOffset: CGFloat = 0
    @State private var expandedIndex: Int? = nil
    @State private var showCloseButton: Bool = false
    @State private var pendingCloseButtonWorkItem: DispatchWorkItem?

    private let portraits = PortraitData.defaults





    private var isExpanded: Bool { expandedIndex != nil }

    private var continuousPosition: CGFloat {
        CGFloat(currentIndex) - (dragOffset / ArcMetrics.dragPerCard)
    }

    private var bgColor: Color {
        let pos = max(0, min(continuousPosition, CGFloat(portraits.count - 1)))
        let lower = Int(pos)
        let upper = min(lower + 1, portraits.count - 1)
        let frac = pos - CGFloat(lower)
        return portraits[lower].bgColor.interpolate(to: portraits[upper].bgColor, fraction: frac)
    }

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(bgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )

            // Dark gradient overlay
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.27),
                    .init(color: .black.opacity(0.6), location: 0.73),
                ],
                startPoint: .top, endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
            .allowsHitTesting(false)

            // Background image
            Image("MartySupreme")
                .resizable()
                .scaledToFill()
                .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
                .opacity(0.15)
                .clipped()
                .allowsHitTesting(false)

            // Header
            CardHeader(subtitle: "What they're wearing", title: "A24", lightText: true)
                .allowsHitTesting(false)

            // Arc carousel
            arcCarousel

            // Drag gesture
            .simultaneousGesture(isExpanded ? nil : arcDragGesture)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .onDisappear {
            pendingCloseButtonWorkItem?.cancel()
        }
    }
}

// MARK: - Subviews

private extension ArcCarouselCard {
    var arcCarousel: some View {
        ZStack {
            ForEach(0..<portraits.count, id: \.self) { index in
                let cardState = state(for: index)
                let portrait = portraits[index]

                PortraitCard(data: portrait, showText: cardState.isCentered, isExpanded: cardState.isExpanded)
                    .frame(width: cardState.width, height: cardState.height)
                    // Product rail
                    .overlay(alignment: .bottom) {
                        if cardState.isExpanded && showCloseButton && !portrait.products.isEmpty {
                            ProductRail(products: portrait.products)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
                    // Close button
                    .overlay(alignment: .topTrailing) {
                        if cardState.isExpanded && showCloseButton {
                            CloseButton(action: collapseExpandedCard)
                        }
                    }
                    .rotationEffect(.degrees(cardState.angle))
                    .offset(x: cardState.x, y: cardState.y)
                    .opacity(cardState.opacity)
                    .zIndex(cardState.zIndex)
                    .onTapGesture {
                        guard cardState.isCentered else { return }
                        expandCard(at: index)
                    }
            }
        }
        .animation(Tokens.springExpand, value: expandedIndex)
        .animation(
            dragOffset == 0 ? Tokens.springDefault : .interactiveSpring(),
            value: continuousPosition
        )
    }

    func state(for index: Int) -> ArcCardState {
        let relativePosition = CGFloat(index) - continuousPosition
        let angle = relativePosition * ArcMetrics.anglePerCard
        let radians = angle * .pi / 180

        let arcX = sin(radians) * ArcMetrics.arcRadius
        let arcY = (1 - cos(radians)) * ArcMetrics.arcRadius + ArcMetrics.arcYOffset
        let isThisExpanded = expandedIndex == index

        let expandedX: CGFloat
        if isThisExpanded {
            expandedX = 0
        } else if index < (expandedIndex ?? index) {
            expandedX = -ArcMetrics.sideExitX
        } else {
            expandedX = ArcMetrics.sideExitX
        }

        let x = isExpanded ? expandedX : arcX
        let y = isExpanded ? (isThisExpanded ? ArcMetrics.expandedYOffset : arcY) : arcY
        let width = isThisExpanded ? ArcMetrics.expandedCardWidth : ArcMetrics.cardWidth
        let height = isThisExpanded ? ArcMetrics.expandedCardHeight : ArcMetrics.cardHeight
        let resolvedAngle = isExpanded ? 0 : Double(angle)
        let opacity = (isExpanded && !isThisExpanded) ? 0.0 : 1.0
        let zIndex = isThisExpanded ? 200 : Double(100) - Double(abs(angle))
        let isCentered = !isExpanded &&
            abs(relativePosition) < ArcMetrics.centeredDistanceThreshold &&
            abs(dragOffset) < ArcMetrics.centeredDragThreshold

        return ArcCardState(
            x: x,
            y: y,
            width: width,
            height: height,
            angle: resolvedAngle,
            opacity: opacity,
            zIndex: zIndex,
            isExpanded: isThisExpanded,
            isCentered: isCentered
        )
    }

    var arcDragGesture: some Gesture {
        DragGesture(minimumDistance: 16)
            .onChanged { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                dragOffset = value.translation.width
            }
            .onEnded { value in
                guard abs(value.translation.width) > abs(value.translation.height) else {
                    withAnimation(Tokens.springDefault) {
                        dragOffset = 0
                    }
                    return
                }

                let horizontal = value.translation.width
                let next: Int
                if horizontal < -ArcMetrics.swipeThreshold && currentIndex < portraits.count - 1 {
                    next = currentIndex + 1
                } else if horizontal > ArcMetrics.swipeThreshold && currentIndex > 0 {
                    next = currentIndex - 1
                } else {
                    next = currentIndex
                }

                if next != currentIndex {
                    Haptics.selection()
                }

                withAnimation(Tokens.springDefault) {
                    currentIndex = next
                    dragOffset = 0
                }
            }
    }

    func expandCard(at index: Int) {
        pendingCloseButtonWorkItem?.cancel()
        showCloseButton = false
        Haptics.light()

        withAnimation(Tokens.springExpand) {
            expandedIndex = index
        }

        let workItem = DispatchWorkItem {
            guard expandedIndex == index else { return }
            withAnimation(.easeIn(duration: ArcMetrics.closeButtonFadeDuration)) {
                showCloseButton = true
            }
        }
        pendingCloseButtonWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + ArcMetrics.closeButtonDelay, execute: workItem)
    }

    func collapseExpandedCard() {
        pendingCloseButtonWorkItem?.cancel()
        showCloseButton = false
        Haptics.light()
        withAnimation(Tokens.springExpand) {
            expandedIndex = nil
        }
    }
}

// MARK: - Product Rail (reusable)

private struct ProductRail: View {
    let products: [ProductCutout]
    private let tileSize: CGFloat = 112
    private let tilePalettes: [[Color]] = [
        [Color(hex: 0xD8D4CE), Color(hex: 0xC2BDB5)],
        [Color(hex: 0xEBE8E3), Color(hex: 0xDDD9D3)],
        [Color(hex: 0xC9A86C), Color(hex: 0x8B7444)],
        [Color(hex: 0xD0CCC6), Color(hex: 0xBAB5AE)],
        [Color(hex: 0xD5D1CB), Color(hex: 0xC0BCB5)],
        [Color(hex: 0xE8E5E0), Color(hex: 0xDAD6D0)],
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Spacer().frame(width: Tokens.space20)
                ForEach(Array(products.enumerated()), id: \.offset) { index, product in
                    BuyAgainStyleRailCard(
                        product: product,
                        palette: tilePalettes[index % tilePalettes.count],
                        size: tileSize
                    )
                }
                Spacer().frame(width: Tokens.space20)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, Tokens.space24)
        .transition(.opacity)
    }
}

private struct BuyAgainStyleRailCard: View {
    let product: ProductCutout
    let palette: [Color]
    let size: CGFloat

    private var contentSize: CGSize {
        let maxContent = size * 0.74
        let scale = min(maxContent / max(product.width, 1), maxContent / max(product.height, 1))
        return CGSize(width: product.width * scale, height: product.height * scale)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: palette,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Image(product.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: contentSize.width, height: contentSize.height)
                        .rotationEffect(.degrees(product.rotation * 0.45))
                        .shadow(
                            color: Tokens.ShopClient.shadowSColor,
                            radius: Tokens.ShopClient.shadowSRadius,
                            x: 0,
                            y: Tokens.ShopClient.shadowSY
                        )
                }
                .shadow(
                    color: Tokens.ShopClient.shadowSColor,
                    radius: Tokens.ShopClient.shadowSRadius,
                    x: 0,
                    y: Tokens.ShopClient.shadowSY
                )
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Close Button (reusable)

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 32, height: 32)
                .background(Circle().fill(.white))
        }
        .padding(Tokens.space12)
        .transition(.opacity)
    }
}

// MARK: - Portrait Card

private struct PortraitCard: View {
    let data: PortraitData
    let showText: Bool
    var isExpanded: Bool = false

    var body: some View {
        Color.clear
            .background {
                Image(data.imageName)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(data.imageScale)
            }
            .clipped()
            .overlay {
                LinearGradient(
                    stops: isExpanded
                        ? [.init(color: Color(hex: 0x212524).opacity(0), location: 0.33),
                           .init(color: Color(hex: 0x212524), location: 0.82)]
                        : [.init(color: .clear, location: 0.5),
                           .init(color: .black.opacity(0.5), location: 1.0)],
                    startPoint: .top, endPoint: .bottom
                )
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.name)
                        .shopTextStyle(.headerBold)
                        .foregroundColor(.white)
                    Text(data.brand)
                        .shopTextStyle(.caption)
                        .foregroundColor(.white.opacity(0.56))
                }
                .padding(Tokens.space16)
                .opacity(showText ? 1 : 0)
            }
            .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}
