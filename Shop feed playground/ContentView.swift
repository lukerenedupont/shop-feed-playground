//
//  ContentView.swift
//  Shop feed playground
//
//  Created by Luke Dupont on 2/11/26.
//

import SwiftUI

// MARK: - Main View

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var isSearchFocused: Bool = false
    @State private var showTypeahead: Bool = false

    var body: some View {
        ZStack {
            // Background
            Tokens.bg.ignoresSafeArea()

            // Page content
            pageContent

            // Decorative gradient
            decorativeGradient

            // Search focused overlay
            if isSearchFocused {
                Tokens.bg
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            // Search bar + typeahead
            searchLayer

            // Bottom controls
            bottomControls
        }
        .onChange(of: isSearchFocused) { _, focused in
            if focused {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        showTypeahead = true
                    }
                }
            } else {
                showTypeahead = false
            }
        }
    }
}

// MARK: - Subviews

private extension ContentView {
    @ViewBuilder
    var pageContent: some View {
        switch selectedTab {
        case 0:
            FeedView()
        case 1:
            SearchPageContent()
        default:
            VStack {
                Spacer()
                Text("Orders")
                    .font(.system(size: Tokens.space24, weight: .semibold))
                    .foregroundColor(Tokens.textPlaceholder)
                Spacer()
            }
        }
    }

    var decorativeGradient: some View {
        Color.clear
            .ignoresSafeArea()
            .overlay(
                Ellipse()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Tokens.gradientPurple, location: 0.28),
                                .init(color: Tokens.gradientYellow, location: 0.67),
                                .init(color: Tokens.gradientRed, location: 0.89),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 480, height: 480)
                    .blur(radius: 200)
                    .opacity(0.3)
                    .offset(x: 55.5, y: -379)
            )
            .allowsHitTesting(false)
    }

    var searchLayer: some View {
        VStack(spacing: 0) {
            SearchBarView(isSearchFocused: $isSearchFocused)
                .background(searchBarGlow)
                .padding(.bottom, isSearchFocused ? 0 : Tokens.space4)
                .background(searchBarBlur)
                .zIndex(1)

            if showTypeahead {
                TypeaheadContent()
                    .transition(.opacity)
            }

            Spacer(minLength: 0)
        }
    }

    @ViewBuilder
    var searchBarGlow: some View {
        if !isSearchFocused {
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Tokens.gradientPurple, location: 0.14),
                            .init(color: Tokens.gradientYellow, location: 0.58),
                            .init(color: Tokens.gradientRed, location: 0.91),
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 265, height: 10)
                .blur(radius: 16)
                .opacity(0.5)
                .offset(y: 15)
        }
    }

    @ViewBuilder
    var searchBarBlur: some View {
        if !isSearchFocused {
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .black, location: 0.5),
                            .init(color: .black.opacity(0.5), location: 0.8),
                            .init(color: .clear, location: 1.0),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .ignoresSafeArea(edges: .top)
        }
    }

    @ViewBuilder
    var bottomControls: some View {
        if !isSearchFocused {
            VStack {
                Spacer()
                BottomNavBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        } else {
            VStack {
                Spacer()
                CloseKeyboardButton {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isSearchFocused = false
                    }
                }
            }
        }
    }
}

// MARK: - Close Keyboard Button

private struct CloseKeyboardButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
                HStack(spacing: Tokens.space4) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                    Text("Close")
                        .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                        .tracking(Tokens.cozyTracking)
                }
                .foregroundColor(.black)
                .padding(.horizontal, Tokens.space16)
                .frame(height: Tokens.chipSize)
                .background(
                    Capsule()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: Tokens.shadowRadiusS, x: 0, y: Tokens.shadowYS)
                )
            }
            .padding(.trailing, Tokens.space16)
            .padding(.bottom, Tokens.space8)
        }
    }
}

// MARK: - Search Page Content

struct SearchPageContent: View {
    private let categories: [(String, Color)] = [
        ("Women", Color(hex: 0xC4956A)),
        ("Men", Color(hex: 0xD4714A)),
        ("Beauty", Color(hex: 0xC47840)),
        ("Home", Color(hex: 0x9BAA7E)),
        ("Food & drinks", Color(hex: 0xD48B5A)),
        ("Baby & toddler", Color(hex: 0xE8B090)),
        ("Towels", Color(hex: 0x8BAABC)),
        ("Household appliances", Color(hex: 0xA09880)),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Color.clear.frame(height: Tokens.searchBarTopOffset)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Tokens.space4) {
                        ForEach(0..<categories.count, id: \.self) { i in
                            CategoryChip(label: categories[i].0, color: categories[i].1)
                        }
                    }
                    .padding(.horizontal, Tokens.space16)
                    .padding(.vertical, Tokens.space8)
                }
                .scrollClipDisabled()

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

// MARK: - Preview

#Preview {
    ContentView()
}
