//
//  FeedCards.swift
//  Shop feed playground
//
//  Home feed with vertically scrolling cards.
//  To add a new card type:
//    1. Create a new SwiftUI View file (e.g. MyNewCard.swift)
//    2. Add a case to FeedCardType below
//    3. Add the case to FeedCardType.allCards
//  That's it — no other files need changing.
//

import SwiftUI

// MARK: - Card Type Registry

/// Each case represents one card in the feed, in display order.
/// Add new card types here — the feed renders them automatically.
enum FeedCardType: Int, Identifiable, CaseIterable {
    case pile = 0
    case arcCarousel
    case priceCheck
    case placeholder1
    case placeholder2
    case placeholder3

    var id: Int { rawValue }

    /// The ordered list of cards shown in the home feed.
    static let allCards: [FeedCardType] = [
        .priceCheck,
        .arcCarousel,
        .pile,
        .placeholder1, .placeholder2, .placeholder3,
    ]
}

// MARK: - Feed View

struct FeedView: View {
    /// Placeholder colors for cards that haven't been designed yet.
    private let placeholderColors: [Color] = [
        Color(hex: 0xC4C0B6),
        Color(hex: 0x1A3328),
        Color(hex: 0x3520A0),
        Color(hex: 0x4A1A12),
        Color(hex: 0xE8DED0),
        Color(hex: 0x2C4A3A),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Color.clear.frame(height: Tokens.searchBarTopOffset)

                FilterChipsView()
                    .padding(.bottom, Tokens.space8)

                LazyVStack(spacing: Tokens.space8) {
                    ForEach(FeedCardType.allCards) { card in
                        feedCard(for: card)
                    }
                }
            }
        }
    }

    // MARK: Card Factory

    @ViewBuilder
    private func feedCard(for type: FeedCardType) -> some View {
        switch type {
        case .pile:
            PileCard()

        case .arcCarousel:
            ArcCarouselCard()

        case .priceCheck:
            PriceCheckCard()

        // Placeholder cards — replace these with real card views
        default:
            let index = max(type.rawValue - 1, 0) % placeholderColors.count
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(placeholderColors[index])
                .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        }
    }
}
