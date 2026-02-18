//
//  TopicMerchDigestCard.swift
//  Shop feed playground
//
//  Topic deck that mirrors Explore Categories interactions.
//

import SwiftUI

struct TopicMerchDigestCard: View {
    @State private var selectedIndex: Int

    private let topics = TopicExplorerItem.defaults

    private enum Layout {
        static let visibleBehind: Int = 4
        static let indicatorDotCount: Int = 5
        static let indicatorSpacing: CGFloat = 5
        static let indicatorSelectedWidth: CGFloat = 18
        static let indicatorDefaultWidth: CGFloat = 5
        static let indicatorHeight: CGFloat = 5
        static let indicatorBottomPadding: CGFloat = 18
        static let titleTopPadding: CGFloat = 22
        static let titleLeadingPadding: CGFloat = 20
        static let backgroundOverscanX: CGFloat = 1.18
        static let backgroundOverscanY: CGFloat = 1.34
        static let backgroundYOffset: CGFloat = -8
    }

    init() {
        _selectedIndex = State(initialValue: min(4, max(0, TopicExplorerItem.defaults.count - 1)))
    }

    private var activeIndex: Int {
        guard !topics.isEmpty else { return 0 }
        return min(max(selectedIndex, 0), topics.count - 1)
    }

    var body: some View {
        Group {
            if topics.isEmpty {
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .fill(Tokens.ShopClient.bgFillSecondary)
            } else {
                cardContent
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Subviews

private extension TopicMerchDigestCard {
    var cardContent: some View {
        return ZStack {
            ZStack {
                ForEach(topics.indices, id: \.self) { index in
                    Image(topics[index].backgroundImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
                        .scaleEffect(
                            x: Layout.backgroundOverscanX,
                            y: Layout.backgroundOverscanY,
                            anchor: .center
                        )
                        .offset(y: Layout.backgroundYOffset)
                        .clipped()
                        .opacity(index == activeIndex ? 1 : 0)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
            )
            .animation(.easeInOut(duration: 0.24), value: activeIndex)

            topTitle
            bottomIndicator
            cardStack
        }
    }

    var topTitle: some View {
        Text("Explore topics for Luke")
            .shopTextStyle(.subtitle)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, Layout.titleTopPadding)
            .padding(.leading, Layout.titleLeadingPadding)
            .allowsHitTesting(false)
    }

    var bottomIndicator: some View {
        let dotCount = min(topics.count, Layout.indicatorDotCount)
        let activeDotIndex = activeIndex % max(dotCount, 1)

        return HStack(spacing: Layout.indicatorSpacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                let isActive = index == activeDotIndex
                RoundedRectangle(cornerRadius: Tokens.radiusMax)
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

    var cardStack: some View {
        ForEach(topics.indices, id: \.self) { index in
            let rangeStart = activeIndex - Layout.visibleBehind
            let rangeEnd = activeIndex + 2
            if (rangeStart...rangeEnd).contains(index) {
                TopicExplorerDeckCard(
                    topic: topics[index],
                    index: index,
                    selectedIndex: $selectedIndex,
                    totalCount: topics.count
                )
            }
        }
    }
}

// MARK: - Deck Card

private struct TopicExplorerDeckCard: View {
    let topic: TopicExplorerItem
    let index: Int
    @Binding var selectedIndex: Int
    let totalCount: Int

    @State private var dragOffsetX: CGFloat = 0
    @State private var dragAxis: DragAxis?
    @State private var isShowingBack: Bool = false
    @State private var typedDescription: String = ""
    @State private var hasTypedDescription: Bool = false

    private enum Layout {
        static let visibleBehind: Int = 4
        static let cornerRadius: CGFloat = Tokens.ShopClient.radius24
        static let width: CGFloat = 286
        static let height: CGFloat = 476
        static let stackedOffsetX: CGFloat = -160
        static let hiddenOffsetX: CGFloat = 520
        static let minScale: CGFloat = 0.76
        static let dragThreshold: CGFloat = 70
        static let contentTopPadding: CGFloat = 16
        static let contentHorizontalPadding: CGFloat = 14
        static let contentBottomPadding: CGFloat = 14
        static let sectionSpacing: CGFloat = 8
        static let titleSpacing: CGFloat = 7
        static let rowSpacing: CGFloat = 4
        static let productGridTopPadding: CGFloat = 4
        static let productGridSpacing: CGFloat = 8
        static let productGridLabelSpacing: CGFloat = 5
        static let productTileCornerRadius: CGFloat = 12
        static let exploreButtonTopPadding: CGFloat = 10
        static let detailsFadeInDuration: Double = 0.2
        static let detailsFadeOutDuration: Double = 0.12
        static let detailsFadeInDelay: Double = 0.08
        static let flipDuration: Double = 0.34
        static let flipPerspective: CGFloat = 0.78
        static let flipButtonTopPadding: CGFloat = 14
        static let flipButtonSidePadding: CGFloat = 14
        static let flipButtonSize: CGFloat = 24
        static let backFaceSpacing: CGFloat = 12
        static let backPanelSpacing: CGFloat = 6
        static let backPanelRadius: CGFloat = 12
        static let backPanelHorizontalPadding: CGFloat = 10
        static let backPanelVerticalPadding: CGFloat = 8
        static let descriptionLineLimit: Int = 3
        static let typingCharacterDelayNanoseconds: UInt64 = 17_000_000
        static let typingPunctuationDelayNanoseconds: UInt64 = 85_000_000

        static let titleColorOpacity: Double = 0.96
        static let subtitleColorOpacity: Double = 0.78
        static let bodyColorOpacity: Double = 0.84
        static let rowLabelColorOpacity: Double = 0.62
        static let sectionHeaderColorOpacity: Double = 0.88
    }

    private enum DragAxis { case horizontal, vertical }

    private var isActive: Bool { index == selectedIndex }

    // MARK: Stack math

    private func stackLerp(outMin: CGFloat, outMax: CGFloat) -> CGFloat {
        lerp(
            inMin: CGFloat(selectedIndex - Layout.visibleBehind),
            inMax: CGFloat(selectedIndex),
            outMin: outMin,
            outMax: outMax,
            CGFloat(index)
        )
    }

    private func baseOffsetX() -> CGFloat {
        index <= selectedIndex
            ? stackLerp(outMin: Layout.stackedOffsetX, outMax: 0)
            : Layout.hiddenOffsetX
    }

    private func brightness() -> CGFloat { stackLerp(outMin: -0.22, outMax: 0) }

    private func scale() -> CGFloat {
        index <= selectedIndex
            ? stackLerp(outMin: Layout.minScale, outMax: 1)
            : 1
    }

    private var visibleSourceChips: [String] { Array(topic.sourceChips.prefix(3)) }
    private var visibleInterestPills: [String] { Array(topic.interestPills.prefix(3)) }
    private var visibleTrendingMerchants: [String] { Array(topic.trendingMerchants.prefix(3)) }
    private var frontProductTileSize: CGFloat {
        (Layout.width - Layout.contentHorizontalPadding * 2 - Layout.productGridSpacing) / 2
    }

    private var productGridColumns: [GridItem] {
        [
            GridItem(.fixed(frontProductTileSize), spacing: Layout.productGridSpacing),
            GridItem(.fixed(frontProductTileSize), spacing: Layout.productGridSpacing),
        ]
    }

    private var frontProducts: [TopicCardProduct] {
        let products = topic.products
        if products.count >= 4 {
            return Array(products.prefix(4))
        }
        if products.count == 3 {
            return [products[0], products[1], products[2], products[0]]
        }
        if products.count == 2 {
            return [products[0], products[1], products[0], products[1]]
        }
        if products.count == 1, let first = products.first {
            return [first, first, first, first]
        }
        return [
            .init(id: "fallback-1", imageName: "BurgundyProductMug", price: "$58"),
            .init(id: "fallback-2", imageName: "PileSunglasses", price: "$58"),
            .init(id: "fallback-3", imageName: "PilePerfume", price: "$58"),
            .init(id: "fallback-4", imageName: "PileBeanie", price: "$58"),
        ]
    }

    private var frontDescriptionText: String {
        isActive ? typedDescription : topic.subtitle
    }

    private var detailsAnimation: Animation {
        if isActive {
            return .easeOut(duration: Layout.detailsFadeInDuration)
                .delay(Layout.detailsFadeInDelay)
        }
        return .easeOut(duration: Layout.detailsFadeOutDuration)
    }

    private var flipAnimation: Animation {
        .spring(response: Layout.flipDuration, dampingFraction: 0.86)
    }

    @MainActor
    private func animateFrontDescription() async {
        let fullText = topic.subtitle
        if hasTypedDescription {
            typedDescription = fullText
            return
        }

        guard isActive else {
            typedDescription = fullText
            return
        }

        hasTypedDescription = true
        typedDescription = ""
        for character in fullText {
            if Task.isCancelled || !isActive {
                typedDescription = fullText
                return
            }
            typedDescription.append(character)

            let delay = ".!?,".contains(character)
                ? Layout.typingPunctuationDelayNanoseconds
                : Layout.typingCharacterDelayNanoseconds
            try? await Task.sleep(nanoseconds: delay)
        }
    }

    private func detailPanel(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: Layout.rowSpacing) {
            Text(title)
                .shopTextStyle(.bodySmallBold)
                .foregroundStyle(.white.opacity(Layout.rowLabelColorOpacity))

            VStack(alignment: .leading, spacing: Layout.backPanelSpacing) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .shopTextStyle(.bodySmall)
                        .foregroundStyle(.white.opacity(Layout.bodyColorOpacity))
                        .lineLimit(2)
                        .minimumScaleFactor(0.88)
                }
            }
            .padding(.horizontal, Layout.backPanelHorizontalPadding)
            .padding(.vertical, Layout.backPanelVerticalPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: Layout.backPanelRadius, style: .continuous)
                    .fill(.white.opacity(0.10))
                    .overlay(
                        RoundedRectangle(cornerRadius: Layout.backPanelRadius, style: .continuous)
                            .stroke(.white.opacity(0.14), lineWidth: 0.5)
                    )
            )
        }
    }

    private var frontFace: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            VStack(alignment: .leading, spacing: Layout.titleSpacing) {
                Text(topic.title)
                    .shopTextStyle(.headerBold)
                    .foregroundStyle(.white.opacity(Layout.titleColorOpacity))
                    .lineLimit(2)
                    .minimumScaleFactor(0.74)
                    .allowsTightening(true)

                Text(frontDescriptionText)
                    .shopTextStyle(.bodySmall)
                    .foregroundStyle(.white.opacity(Layout.subtitleColorOpacity))
                    .lineLimit(Layout.descriptionLineLimit)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: Layout.productGridLabelSpacing) {
                LazyVGrid(columns: productGridColumns, spacing: Layout.productGridSpacing) {
                    ForEach(Array(frontProducts.enumerated()), id: \.offset) { _, product in
                        FeedProductCard(
                            imageName: product.imageName,
                            size: frontProductTileSize,
                            cornerRadius: Layout.productTileCornerRadius,
                            priceBadgeText: product.price,
                            showsFavorite: true,
                            imageOverlayOpacity: 0
                        )
                    }
                }

                ShopClientButton(
                    title: "Explore more",
                    variant: .outlined,
                    size: .s,
                    expandHorizontally: false
                ) {
                    Haptics.light()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, Layout.exploreButtonTopPadding)
            }
            .padding(.top, Layout.productGridTopPadding)
        }
        .padding(.top, Layout.contentTopPadding)
        .padding(.horizontal, Layout.contentHorizontalPadding)
        .padding(.bottom, Layout.contentBottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var backFace: some View {
        VStack(alignment: .leading, spacing: Layout.backFaceSpacing) {
            Text("Topic details")
                .shopTextStyle(.bodySmallBold)
                .foregroundStyle(.white.opacity(Layout.sectionHeaderColorOpacity))

            VStack(alignment: .leading, spacing: Layout.titleSpacing) {
                Text(topic.title)
                    .shopTextStyle(.headerBold)
                    .foregroundStyle(.white.opacity(Layout.titleColorOpacity))
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)

                Text(topic.subtitle)
                    .shopTextStyle(.bodySmall)
                    .foregroundStyle(.white.opacity(Layout.subtitleColorOpacity))
                    .lineLimit(2)
                    .minimumScaleFactor(0.88)
            }

            Text(topic.povText)
                .shopTextStyle(.bodySmall)
                .foregroundStyle(.white.opacity(Layout.bodyColorOpacity))
                .lineLimit(3)
                .minimumScaleFactor(0.86)

            detailPanel(title: "Signals", items: visibleSourceChips)
            detailPanel(title: "Because you're into", items: visibleInterestPills)
            detailPanel(title: "Trending merchants", items: visibleTrendingMerchants)
            Spacer(minLength: 0)
        }
        .padding(.top, Layout.contentTopPadding)
        .padding(.horizontal, Layout.contentHorizontalPadding)
        .padding(.bottom, Layout.contentBottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }

    private var facesOverlay: some View {
        ZStack {
            frontFace
                .opacity(isShowingBack ? 0 : 1)
            backFace
                .opacity(isShowingBack ? 1 : 0)
        }
        .opacity(isActive ? 1 : 0)
        .animation(detailsAnimation, value: isActive)
        .animation(.easeInOut(duration: Layout.flipDuration * 0.45), value: isShowingBack)
        .allowsHitTesting(false)
    }

    private var flipButton: some View {
        Button {
            withAnimation(flipAnimation) {
                isShowingBack.toggle()
            }
            Haptics.light()
        } label: {
            Image(systemName: isShowingBack ? "xmark" : "ellipsis")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
                .frame(width: Layout.flipButtonSize, height: Layout.flipButtonSize)
        }
        .buttonStyle(.plain)
        .opacity(isActive ? 1 : 0)
        .animation(detailsAnimation, value: isActive)
        .allowsHitTesting(isActive)
        .accessibilityLabel(isShowingBack ? "Close topic details" : "Show topic details")
    }

    // MARK: Body

    var body: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [topic.color, topic.accent],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .brightness(brightness())
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.14), lineWidth: 0.5)
            )
            .overlay {
                facesOverlay
            }
            .overlay(alignment: isShowingBack ? .topLeading : .topTrailing) {
                flipButton
                    .padding(.top, Layout.flipButtonTopPadding)
                    .padding(.horizontal, Layout.flipButtonSidePadding)
            }
            .frame(width: Layout.width, height: Layout.height)
            .rotation3DEffect(
                .degrees(isShowingBack ? 180 : 0),
                axis: (x: 0, y: 1, z: 0),
                perspective: Layout.flipPerspective
            )
            .animation(flipAnimation, value: isShowingBack)
            .scaleEffect(scale())
            .offset(x: baseOffsetX() + dragOffsetX)
            .shadow(
                color: (isActive ? Tokens.ShopClient.shadowLColor : Tokens.ShopClient.shadowMColor)
                    .opacity(isActive ? 1.0 : 0.85),
                radius: isActive ? Tokens.ShopClient.shadowLRadius : Tokens.ShopClient.shadowMRadius,
                x: 0,
                y: isActive ? Tokens.ShopClient.shadowLY : Tokens.ShopClient.shadowMY
            )
            .zIndex(isActive ? 100 : Double(index))
            .allowsHitTesting(isActive)
            .simultaneousGesture(
                DragGesture(minimumDistance: 8)
                    .onChanged { value in
                        if dragAxis == nil {
                            let tx = value.translation.width
                            let ty = value.translation.height
                            guard abs(tx) > 6 || abs(ty) > 6 else { return }
                            dragAxis = abs(tx) > abs(ty) ? .horizontal : .vertical
                        }
                        guard dragAxis == .horizontal else { return }
                        dragOffsetX = value.translation.width
                    }
                    .onEnded { value in
                        defer { dragAxis = nil }
                        guard dragAxis == .horizontal else { return }

                        let projected = value.predictedEndTranslation.width
                        let travel = abs(projected) > abs(value.translation.width) ? projected : value.translation.width

                        withAnimation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 60, initialVelocity: 3)) {
                            let previous = selectedIndex
                            if travel < -Layout.dragThreshold {
                                selectedIndex = min(totalCount - 1, selectedIndex + 1)
                            } else if travel > Layout.dragThreshold {
                                selectedIndex = max(0, selectedIndex - 1)
                            }
                            if selectedIndex != previous { Haptics.selection() }
                            dragOffsetX = 0
                        }
                    }
            )
            .onChange(of: isActive) { _, newValue in
                if !newValue, isShowingBack {
                    isShowingBack = false
                }
            }
            .task(id: isActive) {
                await animateFrontDescription()
            }
    }
}

