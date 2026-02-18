//
//  SearchContent.swift
//  Shop feed playground
//
//  Search page content sections. Each section is self-contained.
//

import SwiftUI

// MARK: - Section Header (shared)

struct SectionHeader: View {
    let title: String
    var showArrow: Bool = true

    var body: some View {
        HStack(spacing: Tokens.space4) {
            Text(title)
                .shopTextStyle(.subtitle)
                .foregroundColor(Tokens.textPrimary)

            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: Tokens.ShopClient.textSpec(.badgeBold).fontSize, weight: .bold))
                    .foregroundColor(Tokens.textPrimary)
                    .frame(width: Tokens.iconSmall, height: Tokens.iconSmall)
                    .padding(Tokens.space2)
                    .background(Circle().fill(Tokens.ShopClient.bgFillSecondary))
            }

            Spacer()
        }
        .padding(.horizontal, Tokens.space16)
    }
}

// MARK: - Keep Shopping

struct KeepShoppingSection: View {
    private struct Item: Identifiable {
        let id = UUID()
        let title: String
        let brands: String
        let color: Color
    }

    private let items: [Item] = [
        .init(title: "Warm ambient lighting", brands: "Rug & Weave, MoMA", color: Color(hex: 0xD4C4A8)),
        .init(title: "Brew at home", brands: "Eight Ounce, Fellow, Hario", color: Color(hex: 0xE8DED0)),
        .init(title: "Pantry to table", brands: "kinto, Areaware, Great Jones", color: Color(hex: 0xC4D8E0)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Keep shopping")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Tokens.space8) {
                    ForEach(items) { item in
                        VStack(alignment: .leading, spacing: 0) {
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(item.color)
                                .frame(width: 172.5, height: 148)
                                .smallCardStyle()

                            VStack(alignment: .leading, spacing: 0) {
                                Text(item.title)
                                    .shopTextStyle(.bodySmallBold)
                                    .lineLimit(1)
                                    .foregroundColor(Tokens.textPrimary)

                                Text(item.brands)
                                    .shopTextStyle(.caption)
                                    .lineLimit(1)
                                    .foregroundColor(Tokens.textSecondary)
                            }
                            .padding(.horizontal, Tokens.space4)
                            .padding(.vertical, Tokens.space8)
                        }
                        .frame(width: 172.5)
                    }
                }
                .padding(.horizontal, Tokens.space16)
            }
        }
        .padding(.bottom, Tokens.space8)
    }
}

// MARK: - Recent Searches

struct RecentSearchesSection: View {
    private struct SearchItem: Identifiable {
        let id = UUID()
        let query: String
        let time: String
        let color: Color
    }

    private let searches: [SearchItem] = [
        .init(query: "running shoes", time: "Just now", color: Color(hex: 0xC4C0B6)),
        .init(query: "Summer trip", time: "1 hour ago", color: Color(hex: 0x5588CC)),
        .init(query: "Back to school shopping", time: "June 4", color: Color(hex: 0xA0A0A0)),
        .init(query: "ANAGRAM teddy fur vest", time: "June 3", color: Color(hex: 0x8B6040)),
        .init(query: "Espresso setup under $3k", time: "June 3", color: Color(hex: 0x4A4A4A)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Recent searches")

            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Tokens.space8) {
                    HStack(spacing: Tokens.space8) {
                        ForEach(searches.prefix(3)) { item in
                            recentSearchItem(item)
                        }
                    }
                    HStack(spacing: Tokens.space8) {
                        ForEach(searches.dropFirst(3)) { item in
                            recentSearchItem(item)
                        }
                    }
                }
                .padding(.horizontal, Tokens.space16)
                .padding(.vertical, Tokens.space4)
            }
            .scrollClipDisabled()
        }
        .padding(.bottom, Tokens.space8)
    }

    private func galleryThumb(_ color: Color, rotation: Double) -> some View {
        RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
            .fill(.white)
            .frame(width: 40, height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .fill(color).padding(4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .stroke(Tokens.imageBorder, lineWidth: 0.5)
            )
            .rotationEffect(.degrees(rotation))
            .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)
    }

    private func recentSearchItem(_ item: SearchItem) -> some View {
        HStack(spacing: Tokens.space8) {
            ZStack {
                galleryThumb(item.color.opacity(0.5), rotation: 4)
                galleryThumb(item.color, rotation: -3)
            }
            .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 0) {
                Text(item.query)
                    .shopTextStyle(.captionBold)
                    .foregroundColor(Tokens.textPrimary)
                    .lineLimit(1)

                Text(item.time)
                    .shopTextStyle(.badge)
                    .foregroundColor(Tokens.textTertiary)
            }
        }
        .padding(.horizontal, Tokens.space12)
        .padding(.vertical, Tokens.space6)
        .background(
            RoundedRectangle(cornerRadius: Tokens.radius16, style: .continuous)
                .fill(.white)
                .smallCardStyle(radius: Tokens.radius16)
        )
    }
}

// MARK: - For You

struct ForYouSection: View {
    private struct Brand: Identifiable {
        let id = UUID()
        let name: String
        let rating: String
        let bgColor: Color
        let productColor: Color
        let isDark: Bool
    }

    private let brands: [Brand] = [
        .init(name: "VERONICA BEARD", rating: "4.7 ★ (948)", bgColor: Color(hex: 0x5A6A5A), productColor: Color(hex: 0xF0EDE8), isDark: true),
        .init(name: "Sea, New York", rating: "4.7 ★ (948)", bgColor: Color(hex: 0x8A9A7A), productColor: Color(hex: 0xF5F0E8), isDark: true),
        .init(name: "LESET", rating: "4.7 ★ (948)", bgColor: Color(hex: 0x6A8AAA), productColor: Color(hex: 0xF0EDE8), isDark: true),
        .init(name: "KHAITE", rating: "4.7 ★ (948)", bgColor: Color(hex: 0xF5F0E8), productColor: Color(hex: 0xFFFFFF), isDark: false),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "For you")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.space8), GridItem(.flexible(), spacing: Tokens.space8)],
                spacing: Tokens.space8
            ) {
                ForEach(brands) { brand in
                    let textColor: Color = brand.isDark ? .white : .black

                    ZStack {
                        RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous).fill(brand.bgColor)

                        VStack(spacing: Tokens.space8) {
                            Text(brand.name)
                                .shopTextStyle(.bodySmallBold)
                                .foregroundColor(textColor.opacity(0.7))
                                .lineLimit(1)
                                .padding(.top, Tokens.space16)

                            RoundedRectangle(cornerRadius: Tokens.radius16, style: .continuous)
                                .fill(brand.productColor)
                                .frame(width: 110, height: 110)
                                .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)

                            Text(brand.name.capitalized.components(separatedBy: " ").prefix(2).joined(separator: " "))
                                .shopTextStyle(.captionBold)
                                .foregroundColor(textColor)

                            Text(brand.rating)
                                .shopTextStyle(.caption)
                                .foregroundColor(textColor.opacity(0.7))

                            Spacer().frame(height: Tokens.space4)
                        }
                    }
                    .aspectRatio(176.5 / 235.6, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
                    .smallCardStyle()
                }
            }
            .padding(.horizontal, Tokens.space16)
        }
        .padding(.bottom, Tokens.space8)
    }
}

// MARK: - Refresh Banner

struct RefreshBannerSection: View {
    private struct Tile: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let color: Color
    }

    private let tiles: [Tile] = [
        .init(title: "Refresh your bedroom", subtitle: "Thoughtfully designed for everyday", color: Color(hex: 0x5A5C58)),
        .init(title: "Ready to host", subtitle: "Everything for the perfect night in", color: Color(hex: 0x0E141A)),
        .init(title: "Cozy season is here", subtitle: "Warmth in every detail", color: Color(hex: 0x6B7DA7)),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Tokens.space8) {
                ForEach(tiles) { tile in
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous).fill(tile.color)
                        LinearGradient(colors: [.clear, tile.color], startPoint: .top, endPoint: .bottom)
                            .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))

                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(tile.title)
                                    .shopTextStyle(.sectionTitle)
                                    .foregroundColor(.white)
                                Text(tile.subtitle)
                                    .shopTextStyle(.captionBold)
                                    .foregroundColor(.white.opacity(0.75))
                            }
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(width: 32, height: 32)
                                .background(Circle().fill(.white))
                        }
                        .padding(Tokens.space20)
                    }
                    .frame(width: 361, height: 203)
                    .shadow(color: Tokens.shadowColor, radius: Tokens.shadowRadius, x: 0, y: Tokens.shadowY)
                }
            }
            .padding(.horizontal, Tokens.space16)
            .padding(.vertical, Tokens.space8)
        }
        .scrollClipDisabled()
    }
}

// MARK: - New & Back in Stock

struct NewBackInStockSection: View {
    private struct Product: Identifiable {
        let id = UUID()
        let merchant: String
        let name: String
        let price: String
        let color: Color
    }

    private let products: [Product] = [
        .init(merchant: "Merchant Name", name: "Product Name", price: "$56.00", color: Color(hex: 0xE8DED0)),
        .init(merchant: "Merchant Name", name: "Product Name", price: "$56.00", color: Color(hex: 0xF0EDE8)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "New & back in stock")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Tokens.space8) {
                    ForEach(products) { product in
                        VStack(alignment: .leading, spacing: 0) {
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(product.color)
                                .frame(width: 190, height: 190)
                                .smallCardStyle()

                            VStack(alignment: .leading, spacing: Tokens.space2) {
                                Text(product.merchant)
                                    .shopTextStyle(.caption)
                                    .foregroundColor(Tokens.textSecondary)
                                Text(product.name)
                                    .shopTextStyle(.bodySmallBold)
                                    .foregroundColor(Tokens.textPrimary)
                                Text(product.price)
                                    .shopTextStyle(.bodySmallBold)
                                    .foregroundColor(Tokens.textPrimary)
                            }
                            .padding(.horizontal, Tokens.space4)
                            .padding(.vertical, Tokens.space8)
                        }
                        .frame(width: 190)
                    }
                }
                .padding(.horizontal, Tokens.space16)
            }
        }
        .padding(.bottom, Tokens.space8)
    }
}

// MARK: - Explore Beauty

struct ExploreBeautySection: View {
    private struct Category: Identifiable {
        let id = UUID()
        let name: String
        let colorA: Color
        let colorB: Color
    }

    private let categories: [Category] = [
        .init(name: "Toners", colorA: Color(hex: 0xC4868A), colorB: Color(hex: 0xA06A6E)),
        .init(name: "Foundation & concealers", colorA: Color(hex: 0xAA8468), colorB: Color(hex: 0x8A6A50)),
        .init(name: "Highlighters & luminizers", colorA: Color(hex: 0xB09A80), colorB: Color(hex: 0x8A7A64)),
        .init(name: "Masks & peels", colorA: Color(hex: 0x9A8878), colorB: Color(hex: 0x7A6858)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Explore beauty")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.space8), GridItem(.flexible(), spacing: Tokens.space8)],
                spacing: Tokens.space8
            ) {
                ForEach(categories) { cat in
                    Text(cat.name)
                        .shopTextStyle(.bodyLargeBold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(Tokens.space16)
                        .frame(height: 99)
                        .background(
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(LinearGradient(colors: [cat.colorA, cat.colorB], startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
                        .shadow(color: Tokens.shadowColor, radius: 6, x: 0, y: Tokens.shadowY)
                }
            }
            .padding(.horizontal, Tokens.space16)
        }
        .padding(.bottom, Tokens.space8)
    }
}

// MARK: - Everything on Shop

struct EverythingOnShopSection: View {
    private struct Category: Identifiable {
        let id = UUID()
        let name: String
        let colorA: Color
        let colorB: Color
    }

    private let categories: [Category] = [
        .init(name: "Women", colorA: Color(hex: 0x1A5A3A), colorB: Color(hex: 0x2A6A4A)),
        .init(name: "Men", colorA: Color(hex: 0xD4613A), colorB: Color(hex: 0xE47A4A)),
        .init(name: "Home", colorA: Color(hex: 0xC4A87C), colorB: Color(hex: 0xB09868)),
        .init(name: "Beauty", colorA: Color(hex: 0x7A3A20), colorB: Color(hex: 0x8A4A30)),
        .init(name: "Baby & toddler", colorA: Color(hex: 0xC4AA78), colorB: Color(hex: 0xB09A68)),
        .init(name: "Fitness & nutrition", colorA: Color(hex: 0x8A9AAA), colorB: Color(hex: 0x7A8A9A)),
        .init(name: "Food & drinks", colorA: Color(hex: 0x8A6A40), colorB: Color(hex: 0x7A5A30)),
        .init(name: "Accessories", colorA: Color(hex: 0x9AAA20), colorB: Color(hex: 0x8A9A10)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Everything on Shop", showArrow: false)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.space12), GridItem(.flexible(), spacing: Tokens.space12)],
                spacing: Tokens.space12
            ) {
                ForEach(categories) { cat in
                    Text(cat.name)
                        .shopTextStyle(.bodySmallBold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 80)
                        .background(
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(LinearGradient(colors: [cat.colorA, cat.colorB], startPoint: .leading, endPoint: .trailing))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
                }
            }
            .padding(.horizontal, Tokens.space16)

            // More button
            HStack {
                Spacer()
                Text("More")
                    .shopTextStyle(.bodyLargeBold)
                    .foregroundColor(Tokens.textPrimary)
                Spacer()
            }
            .frame(height: Tokens.chipSize)
            .background(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .fill(.white)
                    .smallCardStyle(radius: Tokens.radiusCard)
            )
            .padding(.horizontal, Tokens.space16)
        }
        .padding(.bottom, Tokens.space8)
    }
}
