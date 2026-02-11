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

    private func recentSearchItem(_ item: (String, String, Color)) -> some View {
        HStack(spacing: Tokens.space8) {
            // Stacked gallery thumbnails
            ZStack {
                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .fill(item.2.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(4))
                    .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)

                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .fill(item.2)
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-3))
                    .overlay(
                        RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                            .stroke(Tokens.imageBorder, lineWidth: 0.5)
                    )
                    .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)
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
    private let brands: [(String, String, Color, Bool)] = [
        ("Veronica Beard", "4.7 ★ (85)", Color(hex: 0xE8DED0), false),
        ("Sea, New York", "4.7 ★ (85)", Color(hex: 0xF0EDE8), false),
        ("LEISET", "4.7 ★ (1141)", Color(hex: 0x3A3A3A), true),
        ("KHAITE", "4.7 ★ (1540)", Color(hex: 0xF5F0E8), false),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "For you")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.space8), GridItem(.flexible(), spacing: Tokens.space8)],
                spacing: Tokens.space8
            ) {
                ForEach(0..<brands.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                            .fill(brands[i].2)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Text(brands[i].0)
                                    .font(.system(size: Tokens.bodySmSize, weight: .bold))
                                    .foregroundColor(brands[i].3 ? .white : .black)
                                    .multilineTextAlignment(.center)
                                    .padding(Tokens.space16)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                    .stroke(Tokens.imageBorder, lineWidth: 0.5)
                            )
                            .shadow(color: Tokens.shadowColorS, radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)

                        Text(brands[i].0)
                            .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                            .tracking(Tokens.cozyTracking)
                            .foregroundColor(Tokens.textPrimary)
                            .lineLimit(1)

                        Text(brands[i].1)
                            .font(.system(size: Tokens.captionSize, weight: .regular))
                            .tracking(Tokens.cozyTracking)
                            .foregroundColor(Tokens.textSecondary)
                    }
                }
            }
            .padding(.horizontal, Tokens.space16)
        }
        .padding(.bottom, Tokens.space8)
    }
}

// MARK: - Refresh Banner

struct RefreshBannerSection: View {
    var body: some View {
        VStack(spacing: Tokens.space4) {
            Text("Refresh your bedroom")
                .font(.system(size: 22, weight: .bold))
                .tracking(Tokens.bodyTracking)
                .foregroundColor(Tokens.textPrimary)

            Text("Thoughtfully designed for everyday")
                .font(.system(size: Tokens.bodySmSize, weight: .regular))
                .tracking(Tokens.cozyTracking)
                .foregroundColor(Tokens.textTertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Tokens.space32)
        .padding(.horizontal, Tokens.space16)
        .background(
            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                .fill(Color(hex: 0xF0EDE8))
        )
        .padding(.horizontal, Tokens.space16)
        .padding(.top, Tokens.space24)
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
    private let categories: [(String, Color)] = [
        ("Toners", Color(hex: 0x7BA68C)),
        ("Foundation & concealers", Color(hex: 0xD4956A)),
        ("Highlighters & luminizers", Color(hex: 0xC4B090)),
        ("Masks & peels", Color(hex: 0x8BAA9C)),
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
                        .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                        .tracking(Tokens.cozyTracking)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Tokens.space16)
                        .frame(height: 99)
                        .background(
                            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                                .fill(categories[i].1)
                        )
                }
            }
            .padding(.horizontal, Tokens.space16)
        }
        .padding(.bottom, Tokens.space8)
    }
}

// MARK: - Everything on Shop

struct EverythingOnShopSection: View {
    private let categories: [(String, Color)] = [
        ("Women", Color(hex: 0x4A7A5A)),
        ("Men", Color(hex: 0xD4714A)),
        ("Home", Color(hex: 0x9BAA7E)),
        ("Beauty", Color(hex: 0xD48B5A)),
        ("Baby & toddler", Color(hex: 0xC4B090)),
        ("Fitness & sports", Color(hex: 0x6A8A9A)),
        ("Food & drinks", Color(hex: 0x8B7355)),
        ("Accessories", Color(hex: 0x7BA68C)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Everything on Shop", showArrow: false)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.space12), GridItem(.flexible(), spacing: Tokens.space12)],
                spacing: Tokens.space12
            ) {
                ForEach(0..<categories.count, id: \.self) { i in
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: Tokens.radius16, style: .continuous)
                            .fill(categories[i].1)
                            .frame(height: 80)

                        Text(categories[i].0)
                            .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                            .tracking(Tokens.cozyTracking)
                            .foregroundColor(Tokens.textPrimary)
                            .padding(.top, Tokens.space8)
                    }
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
                Image(systemName: "chevron.down")
                    .font(.system(size: Tokens.captionSize, weight: .semibold))
                    .foregroundColor(Tokens.textPrimary)
                Spacer()
            }
            .padding(.vertical, Tokens.space10)
            .background(
                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .fill(Tokens.fillSecondary)
            )
            .padding(.horizontal, Tokens.space16)
        }
        .padding(.bottom, Tokens.space8)
    }
}
