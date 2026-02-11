//
//  SearchContent.swift
//  Shop feed playground
//
//  Created by Luke Dupont on 2/11/26.
//

import SwiftUI

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var showArrow: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .tracking(-0.5)
                .lineSpacing(20 - 18)
                .foregroundColor(.black)

            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 16, height: 16)
                    .padding(2)
                    .background(
                        Circle()
                            .fill(Color(hex: 0xF2F4F5))
                    )
            }

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - Keep Shopping Section

struct KeepShoppingSection: View {
    private let items: [(String, String, Color)] = [
        ("Warm ambient lighting", "Rug & Weave, MoMA", Color(hex: 0xD4C4A8)),
        ("Brew at home", "Eight Ounce, Fellow, Hario", Color(hex: 0xE8DED0)),
        ("Pantry to table", "kinto, Areaware, Great Jones", Color(hex: 0xC4D8E0)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Keep shopping")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<items.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 0) {
                            // Image area
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(items[i].2)
                                .frame(width: 172.5, height: 148)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color(red: 5/255, green: 41/255, blue: 77/255).opacity(0.1), lineWidth: 0.5)
                                )
                                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)

                            // Content
                            VStack(alignment: .leading, spacing: 0) {
                                Text(items[i].0)
                                    .font(.system(size: 14, weight: .semibold))
                                    .tracking(-0.2)
                                    .lineLimit(1)
                                    .foregroundColor(.black)

                                Text(items[i].1)
                                    .font(.system(size: 12, weight: .regular))
                                    .tracking(-0.2)
                                    .lineLimit(1)
                                    .foregroundColor(.black.opacity(0.75))
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                        }
                        .frame(width: 172.5)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Recent Searches Section

struct RecentSearchesSection: View {
    private let searches: [(String, String, Color)] = [
        ("running shoes", "Just now", Color(hex: 0xC4C0B6)),
        ("Summer trip", "1 hour ago", Color(hex: 0x5588CC)),
        ("Back to school shopping", "June 4", Color(hex: 0xA0A0A0)),
        ("ANAGRAM teddy fur vest", "June 3", Color(hex: 0x8B6040)),
        ("Espresso setup under $3k", "June 3", Color(hex: 0x4A4A4A)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Recent searches")

            // Flowing wrap layout
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { i in
                            recentSearchItem(searches[i])
                        }
                    }
                    HStack(spacing: 8) {
                        ForEach(3..<searches.count, id: \.self) { i in
                            recentSearchItem(searches[i])
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
            }
            .scrollClipDisabled()
        }
        .padding(.bottom, 8)
    }

    private func recentSearchItem(_ item: (String, String, Color)) -> some View {
        HStack(spacing: 8) {
            // Stacked gallery thumbnails
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(item.2.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(4))
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)

                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(item.2)
                    .frame(width: 40, height: 40)
                    .rotationEffect(.degrees(-3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color(red: 5/255, green: 41/255, blue: 77/255).opacity(0.1), lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            }
            .frame(width: 42, height: 42)

            // Content
            VStack(alignment: .leading, spacing: 0) {
                Text(item.0)
                    .font(.system(size: 12, weight: .medium))
                    .tracking(-0.2)
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text(item.1)
                    .font(.system(size: 10, weight: .regular))
                    .tracking(-0.2)
                    .lineSpacing(13 - 10)
                    .foregroundColor(.black.opacity(0.56))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(red: 5/255, green: 41/255, blue: 77/255).opacity(0.1), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - For You Section

struct ForYouSection: View {
    private let brands: [(String, String, Color, Bool)] = [
        ("Veronica Beard", "4.7 ★ (85)", Color(hex: 0xE8DED0), false),
        ("Sea, New York", "4.7 ★ (85)", Color(hex: 0xF0EDE8), false),
        ("LEISET", "4.7 ★ (1141)", Color(hex: 0x3A3A3A), true),
        ("KHAITE", "4.7 ★ (1540)", Color(hex: 0xF5F0E8), false),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "For you")

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                ],
                spacing: 8
            ) {
                ForEach(0..<brands.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(brands[i].2)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(
                                Text(brands[i].0)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(brands[i].3 ? .white : .black)
                                    .multilineTextAlignment(.center)
                                    .padding(16)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(Color(red: 5/255, green: 41/255, blue: 77/255).opacity(0.1), lineWidth: 0.5)
                            )
                            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)

                        Text(brands[i].0)
                            .font(.system(size: 14, weight: .semibold))
                            .tracking(-0.2)
                            .foregroundColor(.black)
                            .lineLimit(1)

                        Text(brands[i].1)
                            .font(.system(size: 12, weight: .regular))
                            .tracking(-0.2)
                            .foregroundColor(.black.opacity(0.75))
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Refresh Banner

struct RefreshBannerSection: View {
    var body: some View {
        VStack(spacing: 4) {
            Text("Refresh your bedroom")
                .font(.system(size: 22, weight: .bold))
                .tracking(-0.5)
                .foregroundColor(.black)

            Text("Thoughtfully designed for everyday")
                .font(.system(size: 14, weight: .regular))
                .tracking(-0.2)
                .foregroundColor(.black.opacity(0.56))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(hex: 0xF0EDE8))
        )
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
}

// MARK: - New & Back in Stock Section

struct NewBackInStockSection: View {
    private let products: [(String, String, String, Color)] = [
        ("Merchant Name", "Product Name", "$56.00", Color(hex: 0xE8DED0)),
        ("Merchant Name", "Product Name", "$56.00", Color(hex: 0xF0EDE8)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "New & back in stock")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(0..<products.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 0) {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(products[i].3)
                                .frame(width: 190, height: 190)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(Color(red: 5/255, green: 41/255, blue: 77/255).opacity(0.1), lineWidth: 0.5)
                                )
                                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(products[i].0)
                                    .font(.system(size: 12, weight: .regular))
                                    .tracking(-0.2)
                                    .foregroundColor(.black.opacity(0.75))

                                Text(products[i].1)
                                    .font(.system(size: 14, weight: .semibold))
                                    .tracking(-0.2)
                                    .foregroundColor(.black)

                                Text(products[i].2)
                                    .font(.system(size: 14, weight: .bold))
                                    .tracking(-0.2)
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 8)
                        }
                        .frame(width: 190)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Explore Beauty Section

struct ExploreBeautySection: View {
    private let categories: [(String, Color)] = [
        ("Toners", Color(hex: 0x7BA68C)),
        ("Foundation & concealers", Color(hex: 0xD4956A)),
        ("Highlighters & luminizers", Color(hex: 0xC4B090)),
        ("Masks & peels", Color(hex: 0x8BAA9C)),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Explore beauty")

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                ],
                spacing: 8
            ) {
                ForEach(0..<categories.count, id: \.self) { i in
                    Text(categories[i].0)
                        .font(.system(size: 14, weight: .semibold))
                        .tracking(-0.2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .frame(height: 99)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(categories[i].1)
                        )
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Everything on Shop Section

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
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Everything on Shop", showArrow: false)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                ],
                spacing: 12
            ) {
                ForEach(0..<categories.count, id: \.self) { i in
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(categories[i].1)
                            .frame(height: 80)

                        Text(categories[i].0)
                            .font(.system(size: 14, weight: .semibold))
                            .tracking(-0.2)
                            .foregroundColor(.black)
                            .padding(.top, 8)
                    }
                }
            }
            .padding(.horizontal, 16)

            // More button
            HStack {
                Spacer()
                Text("More")
                    .font(.system(size: 16, weight: .semibold))
                    .tracking(-0.5)
                    .foregroundColor(.black)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: 0xF2F4F5))
            )
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
    }
}
