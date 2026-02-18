//
//  CategoryExplorerCard.swift
//  Shop feed playground
//
//  Category deck that uses the TimeMachine-style flick interaction.
//

import SwiftUI

// MARK: - Main Card

struct CategoryExplorerCard: View {
    @State private var selectedIndex: Int = 4

    private let categories = CategoryExplorerItem.defaults

    private enum Layout {
        static let visibleBehind: Int = 4
        static let indicatorDotCount: Int = 5
        static let indicatorSpacing: CGFloat = 5
        static let indicatorSelectedWidth: CGFloat = 18
        static let indicatorDefaultWidth: CGFloat = 5
        static let indicatorHeight: CGFloat = 5
        static let indicatorBottomPadding: CGFloat = 18
        static let titleTopPadding: CGFloat = 22
        static let titleLeadingPadding: CGFloat = 20
    }

    var body: some View {
        let selectedCategory = categories[selectedIndex]

        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [selectedCategory.color.opacity(0.94), selectedCategory.accent.opacity(0.82)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
                )
                .animation(.easeInOut(duration: 0.22), value: selectedIndex)

            topTitle
            bottomIndicator
            cardStack
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Subviews

private extension CategoryExplorerCard {
    var topTitle: some View {
        Text("Explore categories")
            .shopTextStyle(.subtitle)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.top, Layout.titleTopPadding)
            .padding(.leading, Layout.titleLeadingPadding)
            .allowsHitTesting(false)
    }

    var bottomIndicator: some View {
        let dotCount = min(categories.count, Layout.indicatorDotCount)
        let activeIndex = selectedIndex % dotCount

        return HStack(spacing: Layout.indicatorSpacing) {
            ForEach(0..<dotCount, id: \.self) { index in
                let isActive = index == activeIndex
                RoundedRectangle(cornerRadius: Tokens.radiusMax)
                    .fill(.white.opacity(isActive ? 0.95 : 0.45))
                    .frame(
                        width: isActive ? Layout.indicatorSelectedWidth : Layout.indicatorDefaultWidth,
                        height: Layout.indicatorHeight
                    )
                    .animation(.spring(response: 0.24, dampingFraction: 0.8), value: selectedIndex)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, Layout.indicatorBottomPadding)
        .allowsHitTesting(false)
    }

    var cardStack: some View {
        ForEach(categories.indices, id: \.self) { index in
            let rangeStart = selectedIndex - Layout.visibleBehind
            let rangeEnd = selectedIndex + 2
            if (rangeStart...rangeEnd).contains(index) {
                CategoryExplorerDeckCard(
                    category: categories[index],
                    index: index,
                    selectedIndex: $selectedIndex,
                    totalCount: categories.count
                )
            }
        }
    }
}

// MARK: - Deck Card

private struct CategoryExplorerDeckCard: View {
    let category: CategoryExplorerItem
    let index: Int
    @Binding var selectedIndex: Int
    let totalCount: Int

    @State private var dragOffsetX: CGFloat = 0
    @State private var dragAxis: DragAxis?

    private enum Layout {
        static let visibleBehind: Int = 4
        static let cornerRadius: CGFloat = Tokens.ShopClient.radius24
        static let width: CGFloat = 274
        static let height: CGFloat = 356
        static let stackedOffsetX: CGFloat = -160
        static let hiddenOffsetX: CGFloat = 520
        static let minScale: CGFloat = 0.76
        static let dragThreshold: CGFloat = 70
        static let textPadding: CGFloat = 18
        static let productGridPaddingH: CGFloat = 16
        static let productGridSpacing: CGFloat = 8
        static let productGridPaddingB: CGFloat = 16
        static let productTileCornerRadius: CGFloat = 14
    }

    private enum DragAxis { case horizontal, vertical }

    private var isActive: Bool { index == selectedIndex }

    // MARK: Stack math

    private func stackLerp(outMin: CGFloat, outMax: CGFloat) -> CGFloat {
        lerp(
            inMin: CGFloat(selectedIndex - Layout.visibleBehind),
            inMax: CGFloat(selectedIndex),
            outMin: outMin, outMax: outMax,
            CGFloat(index)
        )
    }

    private func baseOffsetX() -> CGFloat {
        index <= selectedIndex
            ? stackLerp(outMin: Layout.stackedOffsetX, outMax: 0)
            : Layout.hiddenOffsetX
    }

    private func brightness() -> CGFloat { stackLerp(outMin: -0.22, outMax: 0) }

    private func scale() -> CGFloat {
        index <= selectedIndex
            ? stackLerp(outMin: Layout.minScale, outMax: 1)
            : 1
    }

    // MARK: Product grid

    private var productGridColumns: [GridItem] {
        [
            GridItem(.fixed(productTileSize), spacing: Layout.productGridSpacing),
            GridItem(.fixed(productTileSize), spacing: Layout.productGridSpacing),
        ]
    }

    private var productTileSize: CGFloat {
        (Layout.width - Layout.productGridPaddingH * 2 - Layout.productGridSpacing) / 2
    }

    // MARK: Body

    var body: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [category.color, category.accent],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .brightness(brightness())
            .overlay(
                RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.14), lineWidth: 0.5)
            )
            .overlay(alignment: .topLeading) {
                Text(category.title)
                    .shopTextStyle(.headerBold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .allowsTightening(true)
                    .padding(.top, Layout.textPadding)
                    .padding(.leading, Layout.textPadding)
            }
            .overlay(alignment: .bottomLeading) {
                LazyVGrid(columns: productGridColumns, spacing: Layout.productGridSpacing) {
                    ForEach(0..<4, id: \.self) { idx in
                        FeedProductCard(
                            imageName: category.productImages[idx],
                            size: productTileSize,
                            cornerRadius: Layout.productTileCornerRadius,
                            showsFavorite: false,
                            imageOverlayOpacity: 0
                        )
                    }
                }
                .padding(.horizontal, Layout.productGridPaddingH)
                .padding(.bottom, Layout.productGridPaddingB)
                .frame(maxWidth: .infinity, alignment: .center)
                .allowsHitTesting(false)
            }
            .frame(width: Layout.width, height: Layout.height)
            .scaleEffect(scale())
            .offset(x: baseOffsetX() + dragOffsetX)
            .shadow(
                color: isActive ? Tokens.ShopClient.shadowMColor : Tokens.ShopClient.shadowSColor,
                radius: isActive ? Tokens.ShopClient.shadowMRadius : Tokens.ShopClient.shadowSRadius,
                x: 0,
                y: isActive ? Tokens.ShopClient.shadowMY : Tokens.ShopClient.shadowSY
            )
            .zIndex(isActive ? 100 : Double(index))
            .allowsHitTesting(isActive)
            .simultaneousGesture(
                DragGesture(minimumDistance: 8)
                    .onChanged { value in
                        if dragAxis == nil {
                            let tx = value.translation.width
                            let ty = value.translation.height
                            guard abs(tx) > 6 || abs(ty) > 6 else { return }
                            dragAxis = abs(tx) > abs(ty) ? .horizontal : .vertical
                        }
                        guard dragAxis == .horizontal else { return }
                        dragOffsetX = value.translation.width
                    }
                    .onEnded { value in
                        defer { dragAxis = nil }
                        guard dragAxis == .horizontal else { return }

                        let projected = value.predictedEndTranslation.width
                        let travel = abs(projected) > abs(value.translation.width) ? projected : value.translation.width

                        withAnimation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 60, initialVelocity: 3)) {
                            let previous = selectedIndex
                            if travel < -Layout.dragThreshold {
                                selectedIndex = min(totalCount - 1, selectedIndex + 1)
                            } else if travel > Layout.dragThreshold {
                                selectedIndex = max(0, selectedIndex - 1)
                            }
                            if selectedIndex != previous { Haptics.selection() }
                            dragOffsetX = 0
                        }
                    }
            )
    }
}
