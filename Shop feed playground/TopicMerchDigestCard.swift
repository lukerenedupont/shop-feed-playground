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
            .foregroundStyle(.white)
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
    @State private var isPushingThread: Bool = false
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
                    title: "Continue thread",
                    variant: .outlined,
                    size: .s,
                    expandHorizontally: false
                ) {
                    isPushingThread = true
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
        .allowsHitTesting(isActive)
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
            .navigationDestination(isPresented: $isPushingThread) {
                ThreadBlankView(topic: topic) {
                    isPushingThread = false
                }
            }
    }
}

struct ThreadBlankView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var chromeState: AppChromeState
    @State private var query: String = ""
    @State private var isIntroContentVisible: Bool = false

    let topic: TopicExplorerItem
    let onClose: (() -> Void)?

    init(topic: TopicExplorerItem, onClose: (() -> Void)? = nil) {
        self.topic = topic
        self.onClose = onClose
    }

    private enum Layout {
        static let topControlsHorizontalPadding: CGFloat = 16
        static let topControlsTopPadding: CGFloat = 67

        static let iconButtonSize: CGFloat = 44
        static let iconTint = Color.black.opacity(0.72)
        static let iconBg = Color.white.opacity(0.56)
        static let iconBorder = Color.black.opacity(0.05)
        static let centerControlWidth: CGFloat = 93.31966400146484
        static let centerControlHeight: CGFloat = 40.65985107421875
        static let centerOuterSize: CGFloat = 40.65984718359323
        static let centerMiddleSize: CGFloat = 36
        static let centerOverlapSpacing: CGFloat = -20.0

        static let followUpInputHeight: CGFloat = 56
        static let followUpCloseSize: CGFloat = 56
        static let followUpSpacing: CGFloat = 8
        static let followUpHorizontalPadding: CGFloat = 16
        static let followUpBottomPadding: CGFloat = 24
        static let headerBackdropHeight: CGFloat = 112
        static let footerBackdropHeight: CGFloat = 90

        static let chapterWidth: CGFloat = 353
        static let chapterHorizontalOffset: CGFloat = -10
        static let chapterTopPadding: CGFloat = 94
        static let chapterBottomPadding: CGFloat = 160
        static let chapterOuterBottomPadding: CGFloat = 12
        static let chapterSpacing: CGFloat = 16
        static let categorySpacing: CGFloat = 24
        static let textBlockPadding: CGFloat = 4
        static let sectionTitleBottomSpacing: CGFloat = 0

        static let shelfRowHeight: CGFloat = 230
        static let shelfCardWidth: CGFloat = 156
        static let shelfCardHeight: CGFloat = 230
        static let shelfImageHeight: CGFloat = 156
        static let shelfImageRadius: CGFloat = 12
        static let shelfSpacing: CGFloat = 8
        static let shelfCardTextSpacing: CGFloat = 0
        static let shelfOverlayButtonSize: CGFloat = 24
        static let shelfOverlayButtonStackSpacing: CGFloat = 4
        static let shelfOverlayPadding: CGFloat = 8

        static let recCardRadius: CGFloat = 28
        static let recCardPadding: CGFloat = 12
        static let recCardSpacing: CGFloat = 8
        static let recPrimaryHeroHeight: CGFloat = 353
        static let recSecondaryHeroHeight: CGFloat = 240
        static let recSecondaryImageSpacing: CGFloat = 2
        static let recActionSpacing: CGFloat = 8
        static let recActionHeight: CGFloat = 32
        static let recBulletSpacing: CGFloat = 4
        static let recTopChipHeight: CGFloat = 32

        static let followUpSuggestionsSpacing: CGFloat = 8
        static let followUpSuggestionHeight: CGFloat = 32
        static let metaRowTopPadding: CGFloat = 0
        static let metaIconSize: CGFloat = 16
        static let metaIconSpacing: CGFloat = 12
        static let sourceChipHeight: CGFloat = 21
        static let sourceDotSize: CGFloat = 12
    }

    var body: some View {
        ZStack {
            Color(hex: 0xF4F5F7)
                .ignoresSafeArea()

            ScrollView(.vertical) {
                chapterContent
                    .frame(width: Layout.chapterWidth, alignment: .leading)
                    .padding(.top, Layout.chapterTopPadding)
                    .padding(.bottom, Layout.chapterBottomPadding)
                    .frame(maxWidth: .infinity)
                    .offset(x: Layout.chapterHorizontalOffset)
                    .padding(.bottom, Layout.chapterOuterBottomPadding)
            }
            .scrollIndicators(.hidden)

            headerBackdrop
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)

            topControls
                .padding(.horizontal, Layout.topControlsHorizontalPadding)
                .padding(.top, Layout.topControlsTopPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)

            footerBackdrop
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)

            followUpBar
                .padding(.horizontal, Layout.followUpHorizontalPadding)
                .padding(.bottom, Layout.followUpBottomPadding)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            chromeState.hideGlobalFeedChrome = true
            isIntroContentVisible = false
            DispatchQueue.main.async {
                isIntroContentVisible = true
            }
        }
        .onDisappear {
            chromeState.hideGlobalFeedChrome = false
            isIntroContentVisible = false
        }
    }

    private var footerBackdrop: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: Layout.footerBackdropHeight)
            .background(.ultraThinMaterial)
            .mask(
                LinearGradient(
                    colors: [
                        .black.opacity(0),
                        .black.opacity(0.65),
                        .black,
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                LinearGradient(
                    colors: [
                        Color(hex: 0xF4F5F7, opacity: 0),
                        Color(hex: 0xF4F5F7, opacity: 0.55),
                        Color(hex: 0xF4F5F7, opacity: 0.9),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .allowsHitTesting(false)
    }

    private var headerBackdrop: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: Layout.headerBackdropHeight)
            .background(.ultraThinMaterial)
            .mask(
                LinearGradient(
                    colors: [
                        .black,
                        .black.opacity(0.65),
                        .black.opacity(0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                LinearGradient(
                    colors: [
                        Color(hex: 0xF4F5F7, opacity: 0.9),
                        Color(hex: 0xF4F5F7, opacity: 0.55),
                        Color(hex: 0xF4F5F7, opacity: 0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .allowsHitTesting(false)
    }

    private var chapterContent: some View {
        VStack(alignment: .leading, spacing: Layout.chapterSpacing) {
            Text(threadTitle)
                .shopTextStyle(.headerBold)
                .foregroundStyle(.black.opacity(0.92))
                .padding(.horizontal, 4)
                .opacity(isIntroContentVisible ? 1 : 0)
                .offset(y: isIntroContentVisible ? 0 : 24)
                .animation(introEntranceAnimation(delay: 0.02), value: isIntroContentVisible)

            textBlock(introBodyText)
                .opacity(isIntroContentVisible ? 1 : 0)
                .offset(y: isIntroContentVisible ? 0 : 24)
                .animation(introEntranceAnimation(delay: 0.08), value: isIntroContentVisible)

            VStack(alignment: .leading, spacing: Layout.categorySpacing) {
                ForEach(Array(shelfSections.enumerated()), id: \.offset) { index, section in
                    shelfSection(section)
                        .opacity(isIntroContentVisible ? 1 : 0)
                        .offset(y: isIntroContentVisible ? 0 : 24)
                        .animation(introEntranceAnimation(delay: 0.14 + (Double(index) * 0.06)), value: isIntroContentVisible)
                }
            }

            textBlock(recommendationLeadText)

            primaryRecommendationCard
            secondaryRecommendationCard
            followUpContent
            metaRow
        }
    }

    private func introEntranceAnimation(delay: Double) -> Animation {
        .spring(response: 0.44, dampingFraction: 0.86).delay(delay)
    }

    private var shelfSections: [ThreadShelfSection] {
        let sectionTitles: [(String, String)] = [
            ("Top picks", "More similar to \(primaryProductName)"),
            ("Because you're into \(firstInterestLabel)", "Curated from your saved signals"),
            ("Trending merchants", topic.trendingMerchants.prefix(2).joined(separator: " and ")),
        ]

        return sectionTitles.enumerated().map { index, header in
            ThreadShelfSection(
                title: header.0,
                subtitle: header.1,
                products: shelfProducts(startingAt: index)
            )
        }
    }

    private var threadTitle: String {
        topic.title
    }

    private var introBodyText: String {
        topic.subtitle
    }

    private var recommendationLeadText: String {
        "Recommendation after considering your \(topic.title.lowercased()) preferences:"
    }

    private var firstInterestLabel: String {
        shortChipText(topic.interestPills.first ?? topic.title)
    }

    private var topicProductsForThread: [TopicCardProduct] {
        if topic.products.isEmpty {
            return TopicExplorerItem.defaults.first?.products ?? [
                .init(id: "fallback-thread-1", imageName: "TopicAkariProductRedPaper", price: "$50.00"),
                .init(id: "fallback-thread-2", imageName: "TopicAkariProductRoundPaper", price: "$50.00"),
                .init(id: "fallback-thread-3", imageName: "TopicAkariProductCylinderPaper", price: "$50.00"),
                .init(id: "fallback-thread-4", imageName: "TopicAkariProductStackedPaper", price: "$50.00"),
            ]
        }
        return topic.products
    }

    private var topStackImageNames: [String] {
        let source = topicProductsForThread
        guard !source.isEmpty else {
            return ["TopicAkariProductRoundPaper", "TopicAkariProductStackedPaper", "TopicAkariProductCylinderPaper"]
        }
        return [
            source[1 % source.count].imageName,
            source[0].imageName,
            source[2 % source.count].imageName,
        ]
    }

    private func shelfProducts(startingAt start: Int) -> [ThreadShelfProduct] {
        let source = topicProductsForThread
        let merchants = topic.trendingMerchants.isEmpty ? ["Merchant Name"] : topic.trendingMerchants

        return (0..<3).map { offset in
            let index = (start + offset) % source.count
            let product = source[index]
            let merchant = merchants[(start + offset) % merchants.count]
            return ThreadShelfProduct(
                imageName: product.imageName,
                merchant: merchant,
                productName: productDisplayName(for: product.imageName),
                price: product.price,
                sourceCount: "(38)"
            )
        }
    }

    private var primaryProduct: TopicCardProduct {
        topicProductsForThread[0]
    }

    private var secondaryProduct: TopicCardProduct {
        topicProductsForThread[min(1, topicProductsForThread.count - 1)]
    }

    private var primaryProductName: String {
        productDisplayName(for: primaryProduct.imageName)
    }

    private var secondaryProductName: String {
        productDisplayName(for: secondaryProduct.imageName)
    }

    private var secondaryRecommendationImages: [String] {
        let source = topicProductsForThread
        return [source[1 % source.count].imageName, source[2 % source.count].imageName, source[3 % source.count].imageName]
    }

    private var primaryMerchantBadge: String {
        topic.trendingMerchants.first.map(shortMerchantLabel) ?? "SHOP"
    }

    private var secondaryMerchantBadge: String {
        topic.trendingMerchants.dropFirst().first.map(shortMerchantLabel) ?? primaryMerchantBadge
    }

    private var primaryInsightLines: [String] {
        [
            topic.povText,
            "Trending across \(topic.trendingMerchants.prefix(2).joined(separator: " and ")).",
        ]
    }

    private var secondaryInsightLines: [String] {
        [
            "Aligned with your interest in \(firstInterestLabel.lowercased()).",
            "Similar picks from your \(topic.title.lowercased()) exploration.",
        ]
    }

    private var followUpPrompt: String {
        "Do you want to keep exploring \(topic.title.lowercased()), or branch into nearby styles?"
    }

    private var followUpSuggestionTitles: [String] {
        let suggestions = topic.interestPills.prefix(2).map(shortChipText)
        if suggestions.count == 2 { return suggestions }
        if suggestions.count == 1 { return [suggestions[0], "Show alternatives"] }
        return ["Keep this style", "Show alternatives"]
    }

    private func productDisplayName(for imageName: String) -> String {
        let cleaned = imageName
            .replacingOccurrences(of: "TopicAkariProduct", with: "")
            .replacingOccurrences(of: "TopicWallArtProduct", with: "")
            .replacingOccurrences(of: "TopicHatProduct", with: "")
            .replacingOccurrences(of: "TopicRunningProduct", with: "")
            .replacingOccurrences(of: "TopicCoffeeProduct", with: "")
            .replacingOccurrences(of: "TopicCandyProduct", with: "")
            .replacingOccurrences(of: "BurgundyProduct", with: "")
            .replacingOccurrences(of: "Product", with: "")

        let spaced = cleaned.replacingOccurrences(
            of: "([a-z])([A-Z])",
            with: "$1 $2",
            options: .regularExpression
        )
        let normalized = spaced.trimmingCharacters(in: .whitespacesAndNewlines)
        return normalized.isEmpty ? "Product Name" : normalized
    }

    private func shortMerchantLabel(_ merchant: String) -> String {
        merchant
            .split(separator: " ")
            .prefix(1)
            .joined()
            .uppercased()
            .prefix(4)
            .description
    }

    private func shortChipText(_ text: String) -> String {
        let words = text.split(separator: " ")
        if words.count <= 2 { return text }
        return words.prefix(2).joined(separator: " ")
    }

    private func textBlock(_ text: String) -> some View {
        Text(text)
            .shopTextStyle(.bodyLarge)
            .foregroundStyle(Tokens.ShopClient.text)
            .padding(.horizontal, Layout.textBlockPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func shelfSection(_ section: ThreadShelfSection) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: Layout.sectionTitleBottomSpacing) {
                HStack(spacing: 4) {
                    Text(section.title)
                        .shopTextStyle(.subtitle)
                        .foregroundStyle(Tokens.ShopClient.text)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(Tokens.ShopClient.textTertiary)
                }

                Text(section.subtitle)
                    .shopTextStyle(.bodySmall)
                    .foregroundStyle(Tokens.ShopClient.text)
            }
            .padding(.horizontal, 4)

            ScrollView(.horizontal) {
                HStack(spacing: Layout.shelfSpacing) {
                    ForEach(section.products) { product in
                        shelfProductCard(product)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: Layout.shelfRowHeight)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, -20)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }

    private func shelfProductCard(_ product: ThreadShelfProduct) -> some View {
        VStack(alignment: .leading, spacing: Layout.shelfCardTextSpacing) {
            FeedProductCard(
                imageName: product.imageName,
                size: Layout.shelfCardWidth,
                cornerRadius: Layout.shelfImageRadius,
                showsFavorite: false,
                imageOverlayOpacity: 0
            )
                .overlay(alignment: .bottomTrailing) {
                    VStack(spacing: Layout.shelfOverlayButtonStackSpacing) {
                        shelfActionCircle(systemName: "message")
                        shelfActionCircle(systemName: "heart")
                    }
                    .padding(Layout.shelfOverlayPadding)
                }
                .frame(width: Layout.shelfCardWidth, height: Layout.shelfImageHeight)

            Text(product.merchant)
                .shopTextStyle(.caption)
                .foregroundStyle(Tokens.ShopClient.textSecondary)
                .lineLimit(1)
                .padding(.top, 8)
            Text(product.productName)
                .shopTextStyle(.captionBold)
                .foregroundStyle(Tokens.ShopClient.text)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
            HStack(spacing: 4) {
                shelfRatingStars
                Text(product.sourceCount)
                    .shopTextStyle(.caption)
                    .foregroundStyle(Tokens.ShopClient.text)
            }
            .padding(.top, 2)

            Text(product.price)
                .shopTextStyle(.captionBold)
                .foregroundStyle(Tokens.ShopClient.text)
                .padding(.top, 1)
        }
        .frame(width: Layout.shelfCardWidth, height: Layout.shelfCardHeight, alignment: .topLeading)
    }

    private var shelfRatingStars: some View {
        HStack(spacing: 2) {
            ForEach(0..<4, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color(hex: 0xE3BE2B))
            }
            Image(systemName: "star.leadinghalf.filled")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(hex: 0xE3BE2B))
        }
    }

    private func shelfActionCircle(systemName: String) -> some View {
        Circle()
            .fill(.black.opacity(0.28))
            .frame(width: Layout.shelfOverlayButtonSize, height: Layout.shelfOverlayButtonSize)
            .overlay {
                Image(systemName: systemName)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white)
            }
    }

    private var primaryRecommendationCard: some View {
        recommendationCardContainer {
            VStack(alignment: .leading, spacing: Layout.recCardSpacing) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Tokens.ShopClient.bgFillSecondary)
                        .frame(height: Layout.recPrimaryHeroHeight)
                        .overlay {
                            Image(topic.backgroundImageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: Layout.recPrimaryHeroHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }

                    recommendationTopChip(firstInterestLabel)
                        .padding(.leading, 12)
                        .padding(.bottom, 12)
                }

                HStack(spacing: 8) {
                    Text(primaryProductName)
                        .shopTextStyle(.bodyLargeBold)
                        .foregroundStyle(Tokens.ShopClient.text)
                        .lineLimit(1)

                    Spacer(minLength: 0)
                    recommendationMetaBadge(primaryMerchantBadge)
                    recommendationHeartButton
                }

                HStack(spacing: 4) {
                    recommendationRatingStars
                    Text("(38)")
                        .shopTextStyle(.bodySmall)
                        .foregroundStyle(Tokens.ShopClient.text)
                }

                HStack(spacing: 6) {
                    Text(primaryProduct.price)
                        .shopTextStyle(.bodySmall)
                        .foregroundStyle(Tokens.ShopClient.text)
                    recommendationSaveChip("Save")
                }

                recommendationBubble(primaryInsightLines)

                recommendationActionRow
            }
        }
    }

    private var secondaryRecommendationCard: some View {
        recommendationCardContainer {
            VStack(alignment: .leading, spacing: Layout.recCardSpacing) {
                ScrollView(.horizontal) {
                    HStack(spacing: Layout.recSecondaryImageSpacing) {
                        ForEach(secondaryRecommendationImages, id: \.self) { imageName in
                            recommendationShelfImage(imageName)
                        }
                    }
                }
                .frame(height: Layout.recSecondaryHeroHeight)
                .scrollIndicators(.hidden)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                recommendationTopChip(shortChipText(topic.interestPills.dropFirst().first ?? "Similar picks"))

                HStack(spacing: 8) {
                    Text(secondaryProductName)
                        .shopTextStyle(.bodyLargeBold)
                        .foregroundStyle(Tokens.ShopClient.text)
                        .lineLimit(1)

                    Spacer(minLength: 0)
                    recommendationMetaBadge(secondaryMerchantBadge)
                    recommendationHeartButton
                }

                HStack(spacing: 4) {
                    recommendationRatingStars
                    Text("(38)")
                        .shopTextStyle(.bodySmall)
                        .foregroundStyle(Tokens.ShopClient.text)
                }

                Text(secondaryProduct.price)
                    .shopTextStyle(.bodySmall)
                    .foregroundStyle(Tokens.ShopClient.text)

                recommendationBubble(secondaryInsightLines)

                recommendationActionRow
            }
        }
    }

    private func recommendationShelfImage(_ imageName: String) -> some View {
        RoundedRectangle(cornerRadius: 0, style: .continuous)
            .fill(Tokens.ShopClient.bgFillSecondary)
            .frame(width: Layout.recSecondaryHeroHeight, height: Layout.recSecondaryHeroHeight)
            .overlay {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
            }
    }

    private func recommendationCardContainer<Content: View>(
        @ViewBuilder _ content: () -> Content
    ) -> some View {
        content()
            .padding(Layout.recCardPadding)
            .background(
                RoundedRectangle(cornerRadius: Layout.recCardRadius, style: .continuous)
                    .fill(Tokens.ShopClient.bgFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Layout.recCardRadius, style: .continuous)
                    .stroke(Tokens.ShopClient.borderSecondary, lineWidth: 0.5)
            )
            .shadow(color: Tokens.ShopClient.shadowSColor, radius: Tokens.ShopClient.shadowSRadius, x: 0, y: Tokens.ShopClient.shadowSY)
            .shadow(color: Tokens.ShopClient.bgFillSecondary, radius: 30, x: 0, y: -1)
    }

    private var recommendationActionRow: some View {
        HStack(spacing: Layout.recActionSpacing) {
            ShopClientButton(
                title: "View details",
                variant: .outlined,
                size: .s,
                expandHorizontally: true
            ) {}

            ShopClientButton(
                title: "Compare",
                variant: .outlined,
                size: .s,
                expandHorizontally: true
            ) {}

            ShopClientButton(
                title: "Add to cart",
                variant: .primary,
                size: .s,
                expandHorizontally: true
            ) {}
        }
    }

    private func recommendationTopChip(_ title: String) -> some View {
        ShopClientButton(title: title, variant: .outlined, size: .s) {}
            .shadow(color: Tokens.ShopClient.shadowSColor, radius: Tokens.ShopClient.shadowSRadius, x: 0, y: Tokens.ShopClient.shadowSY)
    }

    private var recommendationHeartButton: some View {
        Circle()
            .fill(Tokens.ShopClient.bgFill)
            .frame(width: 24, height: 24)
            .overlay(
                Circle()
                    .stroke(Tokens.ShopClient.borderSecondary, lineWidth: 0.5)
            )
            .overlay {
                Image(systemName: "heart")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Tokens.ShopClient.text)
            }
    }

    private func recommendationMetaBadge(_ title: String) -> some View {
        ShopClientBadge(text: title, variant: .neutral)
    }

    private func recommendationSaveChip(_ title: String) -> some View {
        ShopClientBadge(text: title, variant: .brand)
    }

    private var recommendationRatingStars: some View {
        HStack(spacing: 2) {
            ForEach(0..<4, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Color(hex: 0xE3BE2B))
            }
            Image(systemName: "star.leadinghalf.filled")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color(hex: 0xE3BE2B))
        }
    }

    private func recommendationBubble(_ lines: [String]) -> some View {
        VStack(alignment: .leading, spacing: Layout.recBulletSpacing) {
            ForEach(lines, id: \.self) { line in
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(Color(hex: 0x545071))
                        .frame(width: 3, height: 3)
                        .padding(.top, 8)

                    Text(line)
                        .shopTextStyle(.bodySmall)
                        .foregroundStyle(Color(hex: 0x545071))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: Tokens.radius28, style: .continuous)
                .fill(Color(hex: 0xEFEFF2))
        )
    }

    private var followUpContent: some View {
        VStack(alignment: .leading, spacing: Layout.followUpSuggestionsSpacing) {
            Text(followUpPrompt)
                .shopTextStyle(.bodyLarge)
                .foregroundStyle(Tokens.ShopClient.text)
                .padding(.horizontal, 4)

            HStack(spacing: Layout.followUpSuggestionsSpacing) {
                ForEach(followUpSuggestionTitles, id: \.self) { title in
                    suggestionChip(title)
                }
            }
        }
    }

    private func suggestionChip(_ title: String) -> some View {
        ShopClientButton(title: title, variant: .outlined, size: .s) {}
            .shadow(color: Tokens.ShopClient.shadowSColor, radius: Tokens.ShopClient.shadowSRadius, x: 0, y: Tokens.ShopClient.shadowSY)
            .shadow(color: Tokens.ShopClient.bgFillSecondary, radius: 30, x: 0, y: -1)
    }

    private var metaRow: some View {
        HStack(spacing: Layout.metaIconSpacing) {
            metaIcon("hand.thumbsup")
            metaIcon("hand.thumbsdown")
            metaIcon("arrow.triangle.2.circlepath")
            metaIcon("ellipsis")
            sourcesChip
            Spacer(minLength: 0)
        }
        .padding(.top, Layout.metaRowTopPadding)
        .padding(.horizontal, 4)
    }

    private func metaIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: Layout.metaIconSize, weight: .regular))
            .foregroundStyle(Tokens.ShopClient.textSecondary)
    }

    private var sourcesChip: some View {
        HStack(spacing: 8) {
            HStack(spacing: -6) {
                sourceAvatar("ShopLookAvatar01")
                sourceAvatar("ShopLookAvatar02")
                sourceAvatar("ShopLookAvatar03")
            }
            Text("Sources")
                .shopTextStyle(.badgeBold)
                .foregroundStyle(Tokens.ShopClient.textSecondary)
        }
        .padding(.leading, 4)
        .padding(.trailing, 8)
        .frame(height: Layout.sourceChipHeight)
        .background(
            Capsule(style: .continuous)
                .fill(Tokens.overlayDark04)
        )
    }

    private func sourceAvatar(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.sourceDotSize, height: Layout.sourceDotSize)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Tokens.ShopClient.borderImage, lineWidth: 1)
            )
            .background(
                Circle().fill(.white)
            )
    }

    private var topControls: some View {
        HStack(alignment: .top) {
            iconCircle(systemName: "clock.arrow.circlepath")
            Spacer()
            centerModeControl
            Spacer()
            iconCircle(systemName: "square.and.pencil")
        }
    }

    private var centerModeControl: some View {
        HStack(spacing: Layout.centerOverlapSpacing) {
            topStackProductCard(imageName: topStackImageNames[0], size: Layout.centerOuterSize, tintOpacity: 0.12)
            topStackProductCard(imageName: topStackImageNames[1], size: Layout.centerMiddleSize, tintOpacity: 0.04)
            topStackProductCard(imageName: topStackImageNames[2], size: Layout.centerOuterSize, tintOpacity: 0.12)
        }
        .frame(width: Layout.centerControlWidth, height: Layout.centerControlHeight)
    }

    private func topStackProductCard(imageName: String, size: CGFloat, tintOpacity: Double) -> some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.white)
            .frame(width: size, height: size)
            .overlay {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black.opacity(tintOpacity))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Layout.iconBorder, lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
    }

    private func iconCircle(systemName: String) -> some View {
        topIconBackground
            .frame(width: Layout.iconButtonSize, height: Layout.iconButtonSize)
            .overlay {
                Image(systemName: systemName)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(Layout.iconTint)
            }
    }

    private var topIconBackground: some View {
        Group {
            if #available(iOS 26.0, *) {
                Circle()
                    .fill(.clear)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.35), lineWidth: 0.5)
                    )
            } else {
                Circle()
                    .fill(Color(hex: 0xE8E9EC))
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.05), lineWidth: 0.5)
                    )
            }
        }
    }

    private var followUpBar: some View {
        HStack(spacing: Layout.followUpSpacing) {
            ZStack(alignment: .leading) {
                if query.isEmpty {
                    Text("Ask a follow-up")
                        .shopTextStyle(.bodyLarge)
                        .foregroundStyle(Tokens.ShopClient.textPlaceholder)
                }

                TextField("", text: $query)
                    .shopTextStyle(.bodyLarge)
                    .foregroundStyle(Tokens.ShopClient.text)
            }
            .padding(.horizontal, 18)
            .frame(maxWidth: .infinity)
            .frame(height: Layout.followUpInputHeight)
            .background(followUpInputBackground)

            Button {
                onClose?()
                dismiss()
                Haptics.light()
            } label: {
                followUpCloseBackground
                    .frame(width: Layout.followUpCloseSize, height: Layout.followUpCloseSize)
                    .overlay {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .regular))
                            .foregroundStyle(Tokens.ShopClient.text)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close thread")
        }
    }

    private var followUpInputBackground: some View {
        Group {
            if #available(iOS 26.0, *) {
                Capsule(style: .continuous)
                    .fill(.clear)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Color.white.opacity(0.35), lineWidth: 0.5)
                    )
            } else {
                Capsule(style: .continuous)
                    .fill(Tokens.ShopClient.bgFillSecondary)
                    .background(.ultraThinMaterial, in: Capsule(style: .continuous))
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(Tokens.ShopClient.borderSecondary, lineWidth: 0.5)
                    )
            }
        }
    }

    private var followUpCloseBackground: some View {
        Group {
            if #available(iOS 26.0, *) {
                Circle()
                    .fill(.clear)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.35), lineWidth: 0.5)
                    )
            } else {
                Circle()
                    .fill(Tokens.ShopClient.bgFillSecondary)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .stroke(Tokens.ShopClient.borderSecondary, lineWidth: 0.5)
                    )
            }
        }
    }
}

private struct ThreadShelfSection: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let products: [ThreadShelfProduct]
}

private struct ThreadShelfProduct: Identifiable {
    let id = UUID()
    let imageName: String
    let merchant: String
    let productName: String
    let price: String
    let sourceCount: String
}
