//
//  SearchContent.swift
//  Shop feed playground
//
//  Search page content sections.
//

import SwiftUI

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var showArrow: Bool = true

    var body: some View {
        HStack(spacing: Tokens.space4) {
            Text(title)
                .font(.system(size: Tokens.subtitleSize, weight: .semibold))
                .tracking(Tokens.bodyTracking)
                .lineSpacing(Tokens.lineHeightSubtitle - Tokens.subtitleSize)
                .foregroundColor(Tokens.textPrimary)

            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Tokens.textPrimary)
                    .frame(width: Tokens.iconSmall, height: Tokens.iconSmall)
                    .padding(Tokens.space2)
                    .background(Circle().fill(Tokens.fillSecondary))
            }

            Spacer()
        }
        .padding(.horizontal, Tokens.space16)
    }
}

// MARK: - Keep Shopping

struct KeepShoppingSection: View {
    private let items: [(String, String, Color)] = [
        ("Warm ambient lighting", "Rug & Weave, MoMA", Color(hex: 0xD4C4A8)),
        ("Brew at home", "Eight Ounce, Fellow, Hario", Color(hex: 0xE8DED0)),
        ("Pantry to table", "kinto, Areaware, Great Jones", Color(hex: 0xC4D8E0)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Keep shopping")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Tokens.space8) {
                    ForEach(0..<items.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 0) {
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(items[i].2)
                                .frame(width: 172.5, height: 148)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                        .stroke(Tokens.imageBorder, lineWidth: 0.5)
                                )
                                .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)

                            VStack(alignment: .leading, spacing: 0) {
                                Text(items[i].0)
                                    .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                                    .tracking(Tokens.cozyTracking)
                                    .lineLimit(1)
                                    .foregroundColor(Tokens.textPrimary)

                                Text(items[i].1)
                                    .font(.system(size: Tokens.captionSize, weight: .regular))
                                    .tracking(Tokens.cozyTracking)
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
    private let searches: [(String, String, Color)] = [
        ("running shoes", "Just now", Color(hex: 0xC4C0B6)),
        ("Summer trip", "1 hour ago", Color(hex: 0x5588CC)),
        ("Back to school shopping", "June 4", Color(hex: 0xA0A0A0)),
        ("ANAGRAM teddy fur vest", "June 3", Color(hex: 0x8B6040)),
        ("Espresso setup under $3k", "June 3", Color(hex: 0x4A4A4A)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Recent searches")

            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: Tokens.space8) {
                    HStack(spacing: Tokens.space8) {
                        ForEach(0..<3, id: \.self) { i in
                            recentSearchItem(searches[i])
                        }
                    }
                    HStack(spacing: Tokens.space8) {
                        ForEach(3..<searches.count, id: \.self) { i in
                            recentSearchItem(searches[i])
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
                    .fill(color)
                    .padding(4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .stroke(Tokens.imageBorder, lineWidth: 0.5)
            )
            .rotationEffect(.degrees(rotation))
            .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)
    }

    private func recentSearchItem(_ item: (String, String, Color)) -> some View {
        HStack(spacing: Tokens.space8) {
            // Stacked gallery thumbnails
            ZStack {
                galleryThumb(item.2.opacity(0.5), rotation: 4)
                galleryThumb(item.2, rotation: -3)
            }
            .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 0) {
                Text(item.0)
                    .font(.system(size: Tokens.captionSize, weight: .medium))
                    .tracking(Tokens.cozyTracking)
                    .foregroundColor(Tokens.textPrimary)
                    .lineLimit(1)

                Text(item.1)
                    .font(.system(size: Tokens.badgeSize, weight: .regular))
                    .tracking(Tokens.cozyTracking)
                    .foregroundColor(Tokens.textTertiary)
            }
        }
        .padding(.horizontal, Tokens.space12)
        .padding(.vertical, Tokens.space6)
        .background(
            RoundedRectangle(cornerRadius: Tokens.radius16, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radius16, style: .continuous)
                        .stroke(Tokens.imageBorder, lineWidth: 0.5)
                )
                .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)
        )
    }
}

// MARK: - For You

struct ForYouSection: View {
    private let brands: [(name: String, rating: String, bgColor: Color, productColor: Color, isDark: Bool)] = [
        ("VERONICA BEARD", "4.7 ★ (948)", Color(hex: 0x5A6A5A), Color(hex: 0xF0EDE8), true),
        ("Sea, New York", "4.7 ★ (948)", Color(hex: 0x8A9A7A), Color(hex: 0xF5F0E8), true),
        ("LESET", "4.7 ★ (948)", Color(hex: 0x6A8AAA), Color(hex: 0xF0EDE8), true),
        ("KHAITE", "4.7 ★ (948)", Color(hex: 0xF5F0E8), Color(hex: 0xFFFFFF), false),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "For you")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.space8), GridItem(.flexible(), spacing: Tokens.space8)],
                spacing: Tokens.space8
            ) {
                ForEach(0..<brands.count, id: \.self) { i in
                    let brand = brands[i]
                    let textColor: Color = brand.isDark ? .white : .black

                    ZStack {
                        // Background
                        RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                            .fill(brand.bgColor)

                        VStack(spacing: Tokens.space8) {
                            // Brand name at top
                            Text(brand.name)
                                .font(.system(size: Tokens.bodySmSize, weight: .bold))
                                .tracking(Tokens.cozyTracking)
                                .foregroundColor(textColor.opacity(0.7))
                                .lineLimit(1)
                                .padding(.top, Tokens.space16)

                            // Product image placeholder
                            RoundedRectangle(cornerRadius: Tokens.radius16, style: .continuous)
                                .fill(brand.productColor)
                                .frame(width: 110, height: 110)
                                .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)

                            // Merchant name
                            Text(brand.name.capitalized.components(separatedBy: " ").prefix(2).joined(separator: " "))
                                .font(.system(size: Tokens.captionSize, weight: .semibold))
                                .tracking(Tokens.cozyTracking)
                                .foregroundColor(textColor)

                            // Rating
                            Text(brand.rating)
                                .font(.system(size: Tokens.captionSize, weight: .regular))
                                .tracking(Tokens.cozyTracking)
                                .foregroundColor(textColor.opacity(0.7))

                            Spacer().frame(height: Tokens.space4)
                        }
                    }
                    .aspectRatio(176.5 / 235.6, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                            .stroke(Tokens.imageBorder, lineWidth: 0.5)
                    )
                    .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)
                }
            }
            .padding(.horizontal, Tokens.space16)
        }
        .padding(.bottom, Tokens.space8)
    }
}

// MARK: - Refresh Banner

struct RefreshBannerSection: View {
    private let tiles: [(String, String, Color)] = [
        ("Refresh your bedroom", "Thoughtfully designed for everyday", Color(hex: 0x5A5C58)),
        ("Ready to host", "Everything for the perfect night in", Color(hex: 0x0E141A)),
        ("Cozy season is here", "Warmth in every detail", Color(hex: 0x6B7DA7)),
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Tokens.space8) {
                ForEach(0..<tiles.count, id: \.self) { i in
                    ZStack(alignment: .bottom) {
                        // Background
                        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                            .fill(tiles[i].2)

                        // Gradient overlay
                        LinearGradient(
                            colors: [.clear, tiles[i].2],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))

                        // Content
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(tiles[i].0)
                                    .font(.system(size: 20, weight: .semibold))
                                    .tracking(-1.0)
                                    .foregroundColor(.white)

                                Text(tiles[i].1)
                                    .font(.system(size: Tokens.captionSize, weight: .medium))
                                    .tracking(Tokens.cozyTracking)
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
                    .shadow(
                        color: Tokens.shadowColor,
                        radius: Tokens.shadowRadius,
                        x: 0,
                        y: Tokens.shadowY
                    )
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
    private let products: [(String, String, String, Color)] = [
        ("Merchant Name", "Product Name", "$56.00", Color(hex: 0xE8DED0)),
        ("Merchant Name", "Product Name", "$56.00", Color(hex: 0xF0EDE8)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "New & back in stock")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Tokens.space8) {
                    ForEach(0..<products.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 0) {
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(products[i].3)
                                .frame(width: 190, height: 190)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                        .stroke(Tokens.imageBorder, lineWidth: 0.5)
                                )
                                .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)

                            VStack(alignment: .leading, spacing: Tokens.space2) {
                                Text(products[i].0)
                                    .font(.system(size: Tokens.captionSize, weight: .regular))
                                    .tracking(Tokens.cozyTracking)
                                    .foregroundColor(Tokens.textSecondary)

                                Text(products[i].1)
                                    .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                                    .tracking(Tokens.cozyTracking)
                                    .foregroundColor(Tokens.textPrimary)

                                Text(products[i].2)
                                    .font(.system(size: Tokens.bodySmSize, weight: .bold))
                                    .tracking(Tokens.cozyTracking)
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
    private let categories: [(String, Color, Color)] = [
        ("Toners", Color(hex: 0xC4868A), Color(hex: 0xA06A6E)),
        ("Foundation & concealers", Color(hex: 0xAA8468), Color(hex: 0x8A6A50)),
        ("Highlighters & luminizers", Color(hex: 0xB09A80), Color(hex: 0x8A7A64)),
        ("Masks & peels", Color(hex: 0x9A8878), Color(hex: 0x7A6858)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Explore beauty")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.space8), GridItem(.flexible(), spacing: Tokens.space8)],
                spacing: Tokens.space8
            ) {
                ForEach(0..<categories.count, id: \.self) { i in
                    Text(categories[i].0)
                        .font(.system(size: Tokens.bodySize, weight: .semibold))
                        .tracking(Tokens.bodyTracking)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(Tokens.space16)
                        .frame(height: 99)
                        .background(
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [categories[i].1, categories[i].2],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
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
    private let categories: [(String, Color, Color)] = [
        ("Women", Color(hex: 0x1A5A3A), Color(hex: 0x2A6A4A)),
        ("Men", Color(hex: 0xD4613A), Color(hex: 0xE47A4A)),
        ("Home", Color(hex: 0xC4A87C), Color(hex: 0xB09868)),
        ("Beauty", Color(hex: 0x7A3A20), Color(hex: 0x8A4A30)),
        ("Baby & toddler", Color(hex: 0xC4AA78), Color(hex: 0xB09A68)),
        ("Fitness & nutrition", Color(hex: 0x8A9AAA), Color(hex: 0x7A8A9A)),
        ("Food & drinks", Color(hex: 0x8A6A40), Color(hex: 0x7A5A30)),
        ("Accessories", Color(hex: 0x9AAA20), Color(hex: 0x8A9A10)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Everything on Shop", showArrow: false)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.space12), GridItem(.flexible(), spacing: Tokens.space12)],
                spacing: Tokens.space12
            ) {
                ForEach(0..<categories.count, id: \.self) { i in
                    Text(categories[i].0)
                        .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                        .tracking(Tokens.cozyTracking)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 80)
                        .background(
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [categories[i].1, categories[i].2],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
                }
            }
            .padding(.horizontal, Tokens.space16)

            // More button
            HStack {
                Spacer()
                Text("More")
                    .font(.system(size: Tokens.bodySize, weight: .semibold))
                    .tracking(Tokens.bodyTracking)
                    .foregroundColor(Tokens.textPrimary)
                Spacer()
            }
            .frame(height: Tokens.chipSize)
            .background(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .fill(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                            .stroke(Tokens.imageBorder, lineWidth: 0.5)
                    )
                    .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)
            )
            .padding(.horizontal, Tokens.space16)
        }
        .padding(.bottom, Tokens.space8)
    }
}
