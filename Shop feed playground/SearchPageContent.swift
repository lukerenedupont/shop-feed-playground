//
//  SearchPageContent.swift
//  Shop feed playground
//
//  Search tab — category chips + content sections.
//

import SwiftUI

// MARK: - Search Page

struct SearchPageContent: View {
    private let categories: [CategoryItem] = [
        .init(name: "Women", color: Color(hex: 0xC4956A)),
        .init(name: "Men", color: Color(hex: 0xD4714A)),
        .init(name: "Beauty", color: Color(hex: 0xC47840)),
        .init(name: "Home", color: Color(hex: 0x9BAA7E)),
        .init(name: "Food & drinks", color: Color(hex: 0xD48B5A)),
        .init(name: "Baby & toddler", color: Color(hex: 0xE8B090)),
        .init(name: "Towels", color: Color(hex: 0x8BAABC)),
        .init(name: "Household appliances", color: Color(hex: 0xA09880)),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Color.clear.frame(height: Tokens.searchBarTopOffset)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Tokens.space4) {
                        ForEach(categories) { cat in
                            CategoryChip(label: cat.name, color: cat.color)
                        }
                    }
                    .padding(.horizontal, Tokens.space16)
                    .padding(.vertical, Tokens.space8)
                }
                .scrollClipDisabled()
                .padding(.bottom, 25)

                VStack(spacing: Tokens.space24) {
                    KeepShoppingSection()
                    RecentSearchesSection()
                    ForYouSection()
                    RefreshBannerSection()
                    NewBackInStockSection()
                    ExploreBeautySection()
                    EverythingOnShopSection()
                }

                Color.clear.frame(height: 120)
            }
        }
    }
}

// MARK: - Category Item

struct CategoryItem: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}
