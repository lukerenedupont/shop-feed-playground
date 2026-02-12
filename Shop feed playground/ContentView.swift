//
//  ContentView.swift
//  Shop feed playground
//
//  Root view — orchestrates tabs, search bar, and bottom nav.
//

import SwiftUI

// MARK: - Main View

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var isSearchFocused: Bool = false
    @State private var showTypeahead: Bool = false

    var body: some View {
        ZStack {
            Tokens.bg.ignoresSafeArea()

            pageContent
            decorativeGradient

            if isSearchFocused {
                Tokens.bg
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            searchLayer
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
        case 0:  FeedView()
        case 1:  SearchPageContent()
        default: OrdersPageContent()
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
                    withAnimation(Tokens.springSnappy) {
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

// MARK: - Preview

#Preview {
    ContentView()
}
