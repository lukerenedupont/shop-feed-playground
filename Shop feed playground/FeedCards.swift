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
        .init(id: "collection-pocket") { CollectionPocketCard() },
        .init(id: "shop-similar") { ShopSimilarCard() },
        .init(id: "category-stack") { CategoryStackCard() },
        .init(id: "price-check") { PriceCheckCard() },
        .init(id: "shoe-swipe") { ShoeSwipeCard() },
        .init(id: "next-card") { NextFeedCard() },
        .init(id: "f1-carousel") { F1DriverCarouselCard() },
        .init(id: "arc-carousel") { ArcCarouselCard() },
        .init(id: "pile") { PileCard() },
        .init(id: "placeholder-1") { PlaceholderFeedCard(color: Color(hex: 0xC4C0B6)) },
        .init(id: "placeholder-2") { PlaceholderFeedCard(color: Color(hex: 0x1A3328)) },
    ]
}

// MARK: - Feed View

struct FeedView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Color.clear.frame(height: Tokens.searchBarTopOffset)

                FilterChipsView()
                    .padding(.bottom, Tokens.space8)

                LazyVStack(spacing: Tokens.space8) {
                    ForEach(FeedCardRegistry.feed) { card in
                        card.makeView()
                    }
                }
            }
        }
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
