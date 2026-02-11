//
//  ContentView.swift
//  Shop feed playground
//
//  Created by Luke Dupont on 2/11/26.
//

import SwiftUI

// MARK: - Design Tokens (from Figma)

private enum Tokens {
    // Colors
    static let bg = Color(hex: 0xFCFCFC)
    static let overlayLight75 = Color.white.opacity(0.75)
    static let overlayDark04 = Color.black.opacity(0.04)
    static let shadowColor = Color.black.opacity(0.12)
    static let textPlaceholder = Color.black.opacity(0.35)
    static let textPrimary = Color.black
    static let chipBorder = Color(red: 24 / 255, green: 59 / 255, blue: 78 / 255).opacity(0.06)
    static let chipFill = Color.white.opacity(0.85)

    // Gradient
    static let gradientPurple = Color(hex: 0x5433EB)
    static let gradientYellow = Color(hex: 0xD8CB32)
    static let gradientRed = Color(hex: 0xD83232)

    // Spacing
    static let space2: CGFloat = 2
    static let space4: CGFloat = 4
    static let space6: CGFloat = 6
    static let space8: CGFloat = 8
    static let space10: CGFloat = 10
    static let space12: CGFloat = 12
    static let space16: CGFloat = 16
    static let space20: CGFloat = 20
    static let space24: CGFloat = 24

    // Radii
    static let radius28: CGFloat = 28
    static let radiusPhone: CGFloat = 40

    // Typography
    static let bodySize: CGFloat = 16
    static let bodySmSize: CGFloat = 14
    static let bodyTracking: CGFloat = -0.5
    static let cozyTracking: CGFloat = -0.2
    static let lineHeightSection: CGFloat = 22

    // Shadow
    static let shadowRadius: CGFloat = 12
    static let shadowY: CGFloat = 4
    static let shadowColor400 = Color.black.opacity(0.24)
    static let shadowRadiusL: CGFloat = 20
    static let shadowYL: CGFloat = 8

    // Layout
    static let phoneWidth: CGFloat = 393
    static let phoneHeight: CGFloat = 852
    static let chipSize: CGFloat = 40
    static let iconSmall: CGFloat = 16
}

// MARK: - Main View

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var isSearchFocused: Bool = false
    @State private var showTypeahead: Bool = false

    var body: some View {
        ZStack {
            // Background
            Tokens.bg
                .ignoresSafeArea()

            // Page content based on selected tab
            switch selectedTab {
            case 0:
                HomePageContent()
            case 1:
                SearchPageContent()
            default:
                // Orders placeholder
                VStack {
                    Spacer()
                    Text("Orders")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Tokens.textPlaceholder)
                    Spacer()
                }
            }

            // Large decorative gradient — overlay so it doesn't expand layout
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

            // White overlay when search is focused (covers content cleanly)
            if isSearchFocused {
                Tokens.bg
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            // Search bar + typeahead pinned to top
            VStack(spacing: 0) {
                // Search bar — fixed at top, expands downward only
                SearchBarView(isSearchFocused: $isSearchFocused)
                    .background(
                        Group {
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
                    )
                    .padding(.bottom, isSearchFocused ? 0 : Tokens.space4)
                    .background(
                        Group {
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
                    )
                    .zIndex(1)

                // Typeahead content below search bar
                if showTypeahead {
                    TypeaheadContent()
                        .transition(.opacity)
                }

                Spacer(minLength: 0)
            }

            // Bottom navigation — fixed at bottom (hidden when searching)
            if !isSearchFocused {
                VStack {
                    Spacer()
                    BottomNavBar(selectedTab: $selectedTab)
                }
                .ignoresSafeArea(edges: .bottom)
            } else {
                // Close button above keyboard
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                isSearchFocused = false
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 11, weight: .bold))
                                Text("Close")
                                    .font(.system(size: 14, weight: .semibold))
                                    .tracking(-0.2)
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                            )
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 8)
                    }
                }
            }
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

// MARK: - Home Page Content

struct HomePageContent: View {
    var body: some View {
        FeedView()
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
                // Spacer for search bar
                Color.clear.frame(height: 54)

                // Category chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(0..<categories.count, id: \.self) { i in
                            CategoryChip(
                                label: categories[i].0,
                                color: categories[i].1
                            )
                        }
                    }
                    .padding(.horizontal, Tokens.space16)
                    .padding(.vertical, Tokens.space8)
                }
                .scrollClipDisabled()

                // Content sections
                VStack(spacing: 24) {
                    KeepShoppingSection()
                    RecentSearchesSection()
                    ForYouSection()
                    RefreshBannerSection()
                    NewBackInStockSection()
                    ExploreBeautySection()
                    EverythingOnShopSection()
                }

                // Bottom padding for nav bar
                Color.clear.frame(height: 120)
            }
        }
    }
}

// MARK: - Category Chip

struct CategoryChip: View {
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            // Circular category image placeholder
            Circle()
                .fill(color)
                .frame(width: 28, height: 28)

            Text(label)
                .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                .tracking(Tokens.cozyTracking)
                .foregroundColor(Tokens.textPrimary)
        }
        .padding(.leading, Tokens.space4)
        .padding(.trailing, Tokens.space12)
        .frame(height: Tokens.chipSize)
        .background(
            Capsule()
                .fill(Tokens.chipFill)
                .overlay(
                    Capsule()
                        .stroke(Tokens.chipBorder, lineWidth: 0.5)
                )
                .shadow(
                    color: Tokens.shadowColor,
                    radius: Tokens.shadowRadius,
                    x: 0,
                    y: Tokens.shadowY
                )
        )
    }
}

// MARK: - Bottom Navigation Bar

struct BottomNavBar: View {
    @Binding var selectedTab: Int
    @Namespace private var tabAnimation

    private let tabs = ["HomeIcon", "SearchIcon", "OrdersIcon"]

    var body: some View {
        VStack(spacing: 0) {
            // Floating pill tab bar
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Image(tabs[index])
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(selectedTab == index ? Tokens.textPrimary : Tokens.textPlaceholder)
                        .frame(width: 50, height: 44)
                        .background(
                            Group {
                                if selectedTab == index {
                                    Capsule()
                                        .fill(.white)
                                        .shadow(
                                            color: Tokens.shadowColor,
                                            radius: Tokens.shadowRadius,
                                            x: 0,
                                            y: Tokens.shadowY
                                        )
                                        .matchedGeometryEffect(id: "activeTab", in: tabAnimation)
                                }
                            }
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedTab = index
                            }
                        }
                }
            }
            .padding(Tokens.space6)
            .background(
                Capsule()
                    .fill(Tokens.overlayLight75)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.75), lineWidth: 0.5)
                    )
                    .shadow(
                        color: Tokens.shadowColor400,
                        radius: Tokens.shadowRadiusL,
                        x: 0,
                        y: Tokens.shadowYL
                    )
            )
        }
        .padding(.horizontal, Tokens.space20)
        .padding(.top, Tokens.space16)
        .padding(.bottom, Tokens.space24)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0),
                            .init(color: .black.opacity(0.5), location: 0.35),
                            .init(color: .black, location: 0.6),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// TabBarItem is now inline in BottomNavBar

// MARK: - Search Bar

struct SearchBarView: View {
    @Binding var isSearchFocused: Bool
    @FocusState private var textFieldFocused: Bool
    @State private var searchText: String = ""

    @Namespace private var searchAnimation
    private let spring = Animation.spring(response: 0.3, dampingFraction: 0.8)

    var body: some View {
        VStack(spacing: 0) {
            // Main input row
            HStack(spacing: 0) {
                // Plus icon in top row (only when collapsed)
                if !isSearchFocused {
                    Image("PlusIcon")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Tokens.textPrimary)
                        .frame(width: Tokens.chipSize, height: Tokens.chipSize)
                        .matchedGeometryEffect(id: "plusIcon", in: searchAnimation)
                }

                // Text field
                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text("Ask anything")
                            .font(.system(size: Tokens.bodySize, weight: .regular))
                            .tracking(Tokens.bodyTracking)
                            .foregroundColor(Tokens.textPlaceholder)
                            .padding(.leading, isSearchFocused ? 16 : 0)
                    }

                    TextField("", text: $searchText)
                        .font(.system(size: Tokens.bodySize, weight: .regular))
                        .tracking(Tokens.bodyTracking)
                        .foregroundColor(Tokens.textPrimary)
                        .padding(.leading, isSearchFocused ? 16 : 0)
                        .focused($textFieldFocused)
                        .allowsHitTesting(isSearchFocused)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Voice icon
                Image("VoiceIcon")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Tokens.textPrimary)
                    .frame(width: Tokens.chipSize, height: Tokens.chipSize)
            }
            .padding(Tokens.space4)

            // Action row — grows in height when focused
            HStack {
                // Plus icon morphs to this position
                if isSearchFocused {
                    Image("PlusIcon")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Tokens.textPrimary)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .stroke(Color.black.opacity(0.12), lineWidth: 1)
                        )
                        .matchedGeometryEffect(id: "plusIcon", in: searchAnimation)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.2))
                    )
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
            .frame(maxHeight: isSearchFocused ? nil : 0)
            .clipped()
            .opacity(isSearchFocused ? 1 : 0)
        }
        .opacity(isSearchFocused ? 1.0 : 0.75)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(isSearchFocused ? .white : Tokens.overlayLight75)
                .shadow(
                    color: Tokens.shadowColor,
                    radius: Tokens.shadowRadius,
                    x: 0,
                    y: Tokens.shadowY
                )
        )
        .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .onTapGesture {
            if !isSearchFocused {
                withAnimation(spring) {
                    isSearchFocused = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    textFieldFocused = true
                }
            }
        }
        .padding(.horizontal, Tokens.space16)
        .animation(spring, value: isSearchFocused)
        .onChange(of: isSearchFocused) { _, newValue in
            if !newValue {
                textFieldFocused = false
                searchText = ""
            }
        }
    }
}

// MARK: - Filter Chips Row

struct FilterChipsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Tokens.space4) {
                AvatarChip()
                IconOnlyChip(assetName: "BellIcon")
                GlassTextChip(assetName: "TagIcon", label: "Deals")
                GlassTextChip(assetName: "VerifyIcon", label: "Following")
                GlassTextChip(assetName: "HeartIcon", label: "Saved")
            }
            .padding(.horizontal, Tokens.space16)
            .padding(.top, Tokens.space4)
            .padding(.bottom, Tokens.space16)
        }
        .scrollClipDisabled()
    }
}

// MARK: - Avatar Chip

struct AvatarChip: View {
    var body: some View {
        Image("Avatar")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: Tokens.chipSize, height: Tokens.chipSize)
            .clipShape(Circle())
            .shadow(
                color: Tokens.shadowColor,
                radius: Tokens.shadowRadius,
                x: 0,
                y: Tokens.shadowY
            )
    }
}

// MARK: - Icon‑Only Chip

struct IconOnlyChip: View {
    let assetName: String

    var body: some View {
        Image(assetName)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
            .foregroundColor(Tokens.textPrimary)
            .frame(width: Tokens.chipSize, height: Tokens.chipSize)
            .background(
                Circle()
                    .fill(Tokens.chipFill)
                    .overlay(
                        Circle()
                            .stroke(Tokens.chipBorder, lineWidth: 0.5)
                    )
                    .shadow(
                        color: Tokens.shadowColor,
                        radius: Tokens.shadowRadius,
                        x: 0,
                        y: Tokens.shadowY
                    )
            )
    }
}

// MARK: - Glass Text Chip

struct GlassTextChip: View {
    let assetName: String
    let label: String

    var body: some View {
        HStack(spacing: Tokens.space2) {
            Image(assetName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .foregroundColor(Tokens.textPrimary)

            Text(label)
                .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                .tracking(Tokens.cozyTracking)
                .foregroundColor(Tokens.textPrimary)
        }
        .padding(.leading, Tokens.space12)
        .padding(.trailing, Tokens.space16)
        .frame(height: Tokens.chipSize)
        .background(
            Capsule()
                .fill(Tokens.chipFill)
                .overlay(
                    Capsule()
                        .stroke(Tokens.chipBorder, lineWidth: 0.5)
                )
                .shadow(
                    color: Tokens.shadowColor,
                    radius: Tokens.shadowRadius,
                    x: 0,
                    y: Tokens.shadowY
                )
        )
    }
}

// MARK: - Color Hex Helper

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
