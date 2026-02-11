//
//  FeedCards.swift
//  Shop feed playground
//

import SwiftUI

// MARK: - Feed View (TikTok-style vertical paging)

struct FeedView: View {
    private let cardColors: [Color] = [
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
                // Spacer for search bar
                Color.clear.frame(height: Tokens.searchBarTopOffset)

                // Filter chips
                FilterChipsView()

                // Cards — snap targets
                LazyVStack(spacing: Tokens.space8) {
                    ForEach(0..<cardColors.count, id: \.self) { i in
                        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                            .fill(cardColors[i])
                            .frame(height: Tokens.cardHeight)
                            .padding(.horizontal, Tokens.cardPadding)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .scrollTargetBehavior(.viewAligned)
    }
}
