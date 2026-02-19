//
//  FeedCards.swift
//  Shop feed playground
//
//  Home feed with vertically scrolling cards.
//  To add a new card, add one entry to FeedCardRegistry.feed.
//

import SwiftUI

// MARK: - Feed Card Registry

struct FeedCardDefinition: Identifiable {
    let id: String
    private let buildView: () -> AnyView

    init<Content: View>(id: String, @ViewBuilder buildView: @escaping () -> Content) {
        self.id = id
        self.buildView = { AnyView(buildView()) }
    }

    func makeView() -> some View {
        buildView()
    }
}

enum FeedCardRegistry {
    /// Ordered list of cards shown in the home feed.
    static let feed: [FeedCardDefinition] = [
        .init(id: "clothes-pile-swipe-top") { ClothesPileSwipeCard() },
        .init(id: "topic-merch-digest-top") { CoffeeTopicDeckCard() },
        .init(id: "topic-merch-digest") { TopicMerchDigestCard() },
        .init(id: "blank-top") { BlankTopCard() },
        .init(id: "vibe-board") { VibeBoardCard() },
        .init(id: "category-explorer") { CategoryExplorerCard() },
        .init(id: "collection-pocket") { CollectionPocketCard() },
        .init(id: "shop-the-look-focus") { ShopTheLookFocusCard() },
        .init(id: "price-check") { PriceCheckCard() },
        .init(id: "shoe-swipe") { ShoeSwipeCard() },
        .init(id: "next-card") { NextFeedCard() },
        .init(id: "f1-carousel") { F1DriverCarouselCard() },
        .init(id: "arc-carousel") { ArcCarouselCard() },
        .init(id: "pile") { PileCard() },
        .init(id: "placeholder-1") { PlaceholderFeedCard(color: Color(hex: 0xC4C0B6)) },
        .init(id: "placeholder-2") { PlaceholderFeedCard(color: Color(hex: 0x1A3328)) },

        // Late-night explorations (kept at bottom of feed)
        .init(id: "magnify-grid") { MagnifyGridCard() },
        .init(id: "collection-pocket-v2") { CollectionPocketCardV2() },
        .init(id: "spread") { SpreadCard() },
        .init(id: "fidget") { FidgetCard() },
        .init(id: "boomerang") { BoomerangCard() },
        .init(id: "slinky") { SlinkyCard() },
        .init(id: "pantone") { PantoneSpreadCard() },
        .init(id: "phyllotaxis") { PhyllotaxisCard() },
        .init(id: "radial-dial") { RadialDialCard() },
        .init(id: "touch-pad") { DynamicTouchPadCard() },
        .init(id: "time-machine") { TimeMachineCard() },
        .init(id: "easing-shadow") { EasingShadowCard() },
        .init(id: "tab-recording") { TabBarRecordingCard() },
        .init(id: "widget-expand") { WidgetExpansionCard() },
        .init(id: "stateful-btn") { StatefulButtonCard() },
        .init(id: "rollout-menu") { RolloutMenuCard() },
        .init(id: "half-sheet") { HalfSheetCard() },
        .init(id: "spatial-tap") { SpatialTapCard() },
        .init(id: "touch-canvas") { TouchCanvasCard() },
    ]
}

// MARK: - Feed View

struct FeedView: View {
    @State private var focusedCardID: String? = FeedCardRegistry.feed.first?.id

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Color.clear.frame(height: Tokens.searchBarTopOffset)

                LazyVStack(spacing: Tokens.space8) {
                    ForEach(FeedCardRegistry.feed) { card in
                        card.makeView()
                            .id(card.id)
                            .scrollTransition(.interactive, axis: .vertical) { content, phase in
                                content
                                    .scaleEffect(phase.isIdentity ? 1 : 0.985)
                                    .opacity(phase.isIdentity ? 1 : 0.92)
                            }
                    }
                }
                .scrollTargetLayout()

                Color.clear.frame(height: Tokens.feedBottomScrollPadding)
            }
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .alwaysByOne))
        .scrollPosition(id: $focusedCardID, anchor: .center)
    }
}

// MARK: - Placeholder Card

private struct PlaceholderFeedCard: View {
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(color)
            .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
    }
}
