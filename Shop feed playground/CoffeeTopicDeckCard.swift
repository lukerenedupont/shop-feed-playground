//
//  CoffeeTopicDeckCard.swift
//  Shop feed playground
//
//  Coffee-only topic deck: each swipe card is a coffee sub-topic.
//

import SwiftUI

struct CoffeeTopicDeckCard: View {
    @State private var selectedIndex: Int
    @State private var dragTranslation: CGFloat = 0
    @State private var hitEdge: Bool = false

    private let cards = CoffeeTopicFocusItem.defaults

    private enum Layout {
        static let visibleBehind: Int = 2
        static let titleTopPadding: CGFloat = 22
        static let titleLeadingPadding: CGFloat = 20
        static let indicatorDotCount: Int = 5
        static let indicatorSpacing: CGFloat = 5
        static let indicatorSelectedWidth: CGFloat = 18
        static let indicatorDefaultWidth: CGFloat = 5
        static let indicatorHeight: CGFloat = 5
        static let indicatorBottomPadding: CGFloat = 18
        static let backgroundOverscanX: CGFloat = 1.12
        static let backgroundOverscanY: CGFloat = 1.28
        static let carouselStride: CGFloat = 208
        static let dragThreshold: CGFloat = 72
        static let edgeResistance: CGFloat = 0.24
    }

    init() {
        _selectedIndex = State(initialValue: min(1, max(0, CoffeeTopicFocusItem.defaults.count - 1)))
    }

    private var activeIndex: Int {
        guard !cards.isEmpty else { return 0 }
        return min(max(selectedIndex, 0), cards.count - 1)
    }

    var body: some View {
        Group {
            if cards.isEmpty {
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .fill(Tokens.ShopClient.bgFillSecondary)
            } else {
                cardContent
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 16)
                .onChanged { value in
                    guard abs(value.translation.width) > abs(value.translation.height) else { return }

                    let translation = value.translation.width
                    let isPushingLeftEdge = activeIndex == 0 && translation > 0
                    let isPushingRightEdge = activeIndex == cards.count - 1 && translation < 0
                    let isAtEdge = isPushingLeftEdge || isPushingRightEdge

                    if isAtEdge && !hitEdge {
                        Haptics.soft(intensity: 0.5)
                        hitEdge = true
                    } else if !isAtEdge {
                        hitEdge = false
                    }

                    dragTranslation = isAtEdge ? translation * Layout.edgeResistance : translation
                }
                .onEnded { value in
                    hitEdge = false

                    guard abs(value.translation.width) > abs(value.translation.height) else {
                        withAnimation(Tokens.springDefault) {
                            dragTranslation = 0
                        }
                        return
                    }

                    let projected = value.predictedEndTranslation.width
                    var newIndex = activeIndex

                    if projected < -Layout.dragThreshold {
                        newIndex += 1
                    } else if projected > Layout.dragThreshold {
                        newIndex -= 1
                    }

                    newIndex = max(0, min(cards.count - 1, newIndex))

                    if newIndex != activeIndex {
                        Haptics.selection()
                    }

                    withAnimation(Tokens.springSnappy) {
                        selectedIndex = newIndex
                        dragTranslation = 0
                    }
                }
        )
    }
}

private extension CoffeeTopicDeckCard {
    var cardContent: some View {
        ZStack {
            backgroundLayer
            stackLayer
            topTitle
            bottomIndicator
        }
    }

    var backgroundLayer: some View {
        ZStack {
            ForEach(cards.indices, id: \.self) { index in
                Image(cards[index].backgroundImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
                    .scaleEffect(
                        x: Layout.backgroundOverscanX,
                        y: Layout.backgroundOverscanY,
                        anchor: .center
                    )
                    .opacity(index == activeIndex ? 1 : 0)
            }

            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(.black.opacity(0.24))
        }
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 0.5)
        )
        .animation(.easeInOut(duration: 0.24), value: activeIndex)
    }

    var topTitle: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Coffee")
                .shopTextStyle(.subtitle)
                .foregroundStyle(.white)
            Text("Swipe to explore coffee setups")
                .shopTextStyle(.caption)
                .foregroundStyle(.white.opacity(0.78))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, Layout.titleTopPadding)
        .padding(.leading, Layout.titleLeadingPadding)
        .allowsHitTesting(false)
    }

    var bottomIndicator: some View {
        let dotCount = min(cards.count, Layout.indicatorDotCount)
        let activeDotIndex = activeIndex % max(dotCount, 1)

        return HStack(spacing: Layout.indicatorSpacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                let isActive = index == activeDotIndex
                RoundedRectangle(cornerRadius: Tokens.radiusMax, style: .continuous)
                    .fill(.white.opacity(isActive ? 0.95 : 0.45))
                    .frame(
                        width: isActive ? Layout.indicatorSelectedWidth : Layout.indicatorDefaultWidth,
                        height: Layout.indicatorHeight
                    )
                    .animation(.spring(response: 0.24, dampingFraction: 0.8), value: activeIndex)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, Layout.indicatorBottomPadding)
        .allowsHitTesting(false)
    }

    var stackLayer: some View {
        let normalizedDrag = dragTranslation / Layout.carouselStride

        return ForEach(cards.indices, id: \.self) { index in
            let relative = CGFloat(index - activeIndex) + normalizedDrag
            if abs(relative) <= CGFloat(Layout.visibleBehind) + 0.35 {
                CoffeeTopicFocusDeckCard(
                    item: cards[index],
                    relative: relative,
                    stride: Layout.carouselStride
                )
            }
        }
    }
}

private struct CoffeeTopicFocusDeckCard: View {
    let item: CoffeeTopicFocusItem
    let relative: CGFloat
    let stride: CGFloat

    private enum Layout {
        static let cornerRadius: CGFloat = Tokens.ShopClient.radius24
        static let width: CGFloat = 286
        static let height: CGFloat = 476
        static let contentTopPadding: CGFloat = 16
        static let contentHorizontalPadding: CGFloat = 14
        static let contentBottomPadding: CGFloat = 14
        static let contentSpacing: CGFloat = 9
        static let titleSpacing: CGFloat = 6
        static let detailsSpacing: CGFloat = 6
        static let detailChipSpacing: CGFloat = 6
        static let detailChipRadius: CGFloat = 9
        static let detailChipHorizontalPadding: CGFloat = 8
        static let detailChipVerticalPadding: CGFloat = 6
        static let productsTopPadding: CGFloat = 8
        static let productSpacing: CGFloat = 8
        static let productCornerRadius: CGFloat = 12
        static let minScale: CGFloat = 0.76
        static let minOpacity: Double = 0.42
        static let maxYRotation: CGFloat = 54
        static let maxZRotation: CGFloat = 11
        static let maxXRotation: CGFloat = 10
        static let focusTiltDegrees: CGFloat = -3.8
        static let perspective: CGFloat = 0.82
        static let maxBrightnessDrop: CGFloat = 0.16
        static let detailsFalloff: CGFloat = 2.4
    }

    private var clampedAbs: CGFloat { min(abs(relative), 1.4) }
    private var isCentered: Bool { abs(relative) < 0.30 }
    private var cardScale: CGFloat {
        max(Layout.minScale, 1 - clampedAbs * 0.18)
    }
    private var cardOpacity: Double {
        // Keep immediate left/right cards fully solid, fade only deeper stack cards.
        if abs(relative) <= 1.05 { return 1.0 }
        return max(Layout.minOpacity, 1 - Double(clampedAbs) * 0.50)
    }
    private var cardBrightness: CGFloat {
        -min(Layout.maxBrightnessDrop, clampedAbs * Layout.maxBrightnessDrop)
    }
    private var detailsOpacity: Double {
        max(0, 1 - Double(abs(relative) * Layout.detailsFalloff))
    }
    private var yRotation: CGFloat {
        let sideFactor = min(1, abs(relative))
        let baseBias = randomInRange(-6.5, 6.5, salt: 11)
        let sideBias = randomInRange(-8, 8, salt: 13) * sideFactor
        let rotation = (-relative * 40) + baseBias + sideBias
        return min(Layout.maxYRotation, max(-Layout.maxYRotation, rotation))
    }
    private var xRotation: CGFloat {
        let sideFactor = min(1, abs(relative))
        let centerFactor = max(0, 1 - abs(relative) * 2.2)
        let baseBias = randomInRange(-4.5, 4.5, salt: 23)
        let sideBias = randomInRange(-5, 5, salt: 31) * sideFactor
        let centerBias = randomInRange(-2.2, 2.2, salt: 37) * centerFactor
        let rotation = baseBias + sideBias + centerBias
        return min(Layout.maxXRotation, max(-Layout.maxXRotation, rotation))
    }
    private var zRotation: CGFloat {
        let sideRotation = -relative * 6.5
        let centerFactor = max(0, 1 - abs(relative) * 2.2)
        let baseRoll = randomInRange(-4.8, 4.8, salt: 41)
        let centerTilt = (Layout.focusTiltDegrees + randomInRange(-2.3, 2.3, salt: 43)) * centerFactor
        let sideBias = randomInRange(-4.2, 4.2, salt: 53) * min(1, abs(relative))
        let rotation = sideRotation + baseRoll + centerTilt + sideBias
        return min(Layout.maxZRotation, max(-Layout.maxZRotation, rotation))
    }
    private var xOffset: CGFloat {
        relative * stride
    }

    private func seededUnit(_ salt: UInt32) -> CGFloat {
        var hash: UInt32 = 2166136261 ^ salt
        for scalar in item.id.unicodeScalars {
            hash ^= UInt32(scalar.value)
            hash &*= 16777619
        }
        return CGFloat(hash % 10_000) / 10_000
    }

    private func randomInRange(_ minValue: CGFloat, _ maxValue: CGFloat, salt: UInt32) -> CGFloat {
        minValue + (maxValue - minValue) * seededUnit(salt)
    }

    private var displayedProducts: [TopicCardProduct] {
        let products = item.products
        if products.count >= 2 {
            return Array(products.prefix(2))
        }
        if let first = products.first {
            return [first, first]
        }
        return [
            .init(id: "coffee-fallback-1", imageName: "TopicCoffeeProductKettle", price: "$195"),
            .init(id: "coffee-fallback-2", imageName: "TopicCoffeeProductCanister", price: "$42"),
        ]
    }

    private func detailChip(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .shopTextStyle(.captionBold)
                .foregroundStyle(.white.opacity(0.80))

            Text(items.prefix(2).joined(separator: ", "))
                .shopTextStyle(.caption)
                .foregroundStyle(.white.opacity(0.92))
                .lineLimit(2)
                .minimumScaleFactor(0.88)
        }
        .padding(.horizontal, Layout.detailChipHorizontalPadding)
        .padding(.vertical, Layout.detailChipVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Layout.detailChipRadius, style: .continuous)
                .fill(.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.detailChipRadius, style: .continuous)
                        .stroke(.white.opacity(0.14), lineWidth: 0.5)
                )
        )
    }

    private var productTileSize: CGFloat {
        (Layout.width - Layout.contentHorizontalPadding * 2 - Layout.productSpacing) / 2
    }

    private var frontContent: some View {
        VStack(alignment: .leading, spacing: Layout.contentSpacing) {
            VStack(alignment: .leading, spacing: Layout.titleSpacing) {
                Text(item.title)
                    .shopTextStyle(.headerBold)
                    .foregroundStyle(.white.opacity(0.96))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                Text(item.subtitle)
                    .shopTextStyle(.bodySmall)
                    .foregroundStyle(.white.opacity(0.82))
                    .lineLimit(3)
                    .minimumScaleFactor(0.88)

                Text(item.povText)
                    .shopTextStyle(.bodySmallBold)
                    .foregroundStyle(.white.opacity(0.92))
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
            }

            VStack(spacing: Layout.detailsSpacing) {
                detailChip(title: "Signals", items: item.sourceChips)
                detailChip(title: "Because you're into", items: item.interestPills)
                detailChip(title: "Trending merchants", items: item.trendingMerchants)
            }

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: Layout.productSpacing) {
                HStack(spacing: Layout.productSpacing) {
                    ForEach(displayedProducts) { product in
                        FeedProductCard(
                            imageName: product.imageName,
                            size: productTileSize,
                            cornerRadius: Layout.productCornerRadius,
                            priceBadgeText: product.price,
                            showsFavorite: true,
                            imageOverlayOpacity: 0
                        )
                    }
                }
            }
            .padding(.top, Layout.productsTopPadding)
        }
        .padding(.top, Layout.contentTopPadding)
        .padding(.horizontal, Layout.contentHorizontalPadding)
        .padding(.bottom, Layout.contentBottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .opacity(detailsOpacity)
        .animation(.easeInOut(duration: 0.16), value: relative)
    }

    var body: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [item.color, item.accent],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .brightness(cardBrightness)
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.14), lineWidth: 0.5)
            )
            .overlay {
                frontContent
            }
            .frame(width: Layout.width, height: Layout.height)
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
            .rotation3DEffect(
                .degrees(Double(xRotation)),
                axis: (x: 1, y: 0, z: 0),
                perspective: Layout.perspective
            )
            .rotation3DEffect(
                .degrees(Double(yRotation)),
                axis: (x: 0, y: 1, z: 0),
                perspective: Layout.perspective
            )
            .rotationEffect(.degrees(Double(zRotation)))
            .offset(x: xOffset, y: clampedAbs * 5)
            .shadow(
                color: Tokens.ShopClient.shadowLColor
                    .opacity(0.18 + (1 - Double(min(clampedAbs, 1))) * 0.42),
                radius: Tokens.ShopClient.shadowMRadius + (1 - clampedAbs) * 14,
                x: 0,
                y: Tokens.ShopClient.shadowMY + (1 - clampedAbs) * 5
            )
            .zIndex(100 - Double(clampedAbs) * 10)
            .allowsHitTesting(isCentered)
            .animation(.spring(response: 0.34, dampingFraction: 0.84), value: relative)
    }
}

private struct CoffeeTopicFocusItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let povText: String
    let backgroundImageName: String
    let color: Color
    let accent: Color
    let sourceChips: [String]
    let interestPills: [String]
    let trendingMerchants: [String]
    let products: [TopicCardProduct]
}

private extension CoffeeTopicFocusItem {
    static func make(
        id: String,
        title: String,
        subtitle: String,
        povText: String,
        backgroundImageName: String,
        color: UInt,
        accent: UInt,
        sourceChips: [String],
        interestPills: [String],
        trendingMerchants: [String],
        products: [TopicCardProduct]
    ) -> CoffeeTopicFocusItem {
        .init(
            id: id,
            title: title,
            subtitle: subtitle,
            povText: povText,
            backgroundImageName: backgroundImageName,
            color: Color(hex: color),
            accent: Color(hex: accent),
            sourceChips: sourceChips,
            interestPills: interestPills,
            trendingMerchants: trendingMerchants,
            products: products
        )
    }

    static let defaults: [CoffeeTopicFocusItem] = [
        .make(
            id: "coffee-brew-station",
            title: "Coffee brew station",
            subtitle: "A compact setup with kettle, grinder, and tidy accessories for fast weekday brews.",
            povText: "You prefer clean, low-clutter counters with premium daily tools.",
            backgroundImageName: "TopicBgCoffeeBeans",
            color: 0x5A3A2D,
            accent: 0x7A4D36,
            sourceChips: ["Coffee TikTok", "Fellow videos", "YouTube demos"],
            interestPills: ["Pour-over ritual", "Countertop minimalism", "Fast mornings"],
            trendingMerchants: ["Fellow", "Ratio", "Blue Bottle"],
            products: [
                .init(id: "coffee-kettle", imageName: "TopicCoffeeProductKettle", price: "$195"),
                .init(id: "coffee-canister", imageName: "TopicCoffeeProductCanister", price: "$42"),
            ]
        ),
        .make(
            id: "coffee-precision-kit",
            title: "Precision brew kit",
            subtitle: "Dial-in focused gear for repeatable cups with better grind control and consistency.",
            povText: "You keep saving setups that balance control with a small footprint.",
            backgroundImageName: "TopicBgCoffeeBeans",
            color: 0x4A332B,
            accent: 0x6D4A3F,
            sourceChips: ["Reddit r/coffee", "Brew guides", "Gear reviews"],
            interestPills: ["Burr grinders", "Recipe consistency", "Clean brew workflow"],
            trendingMerchants: ["Comandante", "Fellow", "Onyx Coffee"],
            products: [
                .init(id: "coffee-grinder", imageName: "TopicCoffeeProductGrinder", price: "$249"),
                .init(id: "coffee-kettle-2", imageName: "TopicCoffeeProductKettle", price: "$195"),
            ]
        ),
        .make(
            id: "coffee-espresso-corner",
            title: "Espresso corner",
            subtitle: "A polished home espresso nook with strong visual design and quick cleanup.",
            povText: "You like statement machines that still feel practical day-to-day.",
            backgroundImageName: "TopicBgCoffeeBeans",
            color: 0x4E362E,
            accent: 0x775144,
            sourceChips: ["Design blogs", "Cafe reels", "Workflow clips"],
            interestPills: ["Home espresso", "Warm materials", "Counter styling"],
            trendingMerchants: ["Breville", "Fellow", "Acaia"],
            products: [
                .init(id: "coffee-machine", imageName: "TopicCoffeeProductMachine", price: "$365"),
                .init(id: "coffee-canister-2", imageName: "TopicCoffeeProductCanister", price: "$42"),
            ]
        ),
        .make(
            id: "coffee-weekend-bar",
            title: "Weekend coffee bar",
            subtitle: "A slower weekend setup with elevated tools for hosting and longer brew sessions.",
            povText: "You’re into setups that feel calm, intentional, and guest-ready.",
            backgroundImageName: "TopicBgCoffeeBeans",
            color: 0x5C3E30,
            accent: 0x866049,
            sourceChips: ["Pinterest saves", "Long-form YouTube", "Cafe references"],
            interestPills: ["Hosting ritual", "Warm tones", "Brew theater"],
            trendingMerchants: ["Blue Bottle", "Fellow", "Kinto"],
            products: [
                .init(id: "coffee-machine-2", imageName: "TopicCoffeeProductMachine", price: "$365"),
                .init(id: "coffee-grinder-2", imageName: "TopicCoffeeProductGrinder", price: "$249"),
            ]
        ),
    ]
}
