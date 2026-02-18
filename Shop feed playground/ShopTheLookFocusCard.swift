//
//  ShopTheLookFocusCard.swift
//  Shop feed playground
//
//  Swipeable "Shop the look" carousel with tappable product hotspots.
//

import SwiftUI

// MARK: - Main Card

struct ShopTheLookFocusCard: View {
    @State private var selectedIndex: Int = 0
    @State private var dragTranslation: CGFloat = 0
    @State private var hitEdge: Bool = false
    @State private var isScrubbing: Bool = false

    @State private var showHotspots: Bool = false
    @State private var floatPhase: Bool = false
    @State private var activeProductDot: Int? = nil
    @State private var shirtPosition: CGPoint = Layout.randomPosition(in: Layout.shirtXRange, Layout.shirtYRange)
    @State private var pantsPosition: CGPoint = Layout.randomPosition(in: Layout.pantsXRange, Layout.pantsYRange)

    private let outfits = LookOutfit.defaults

    // MARK: Layout

    private enum Layout {
        // Card chrome
        static let cardShadowOpacity: Double = 0.18
        static let cardShadowRadius: CGFloat = 16
        static let cardShadowY: CGFloat = 8

        // Hero avatar
        static let heroScale: CGFloat = 0.85
        static let heroOffsetY: CGFloat = -50
        static let heroWidthRatio: CGFloat = 0.96
        static let heroHeightRatio: CGFloat = 0.95
        static let inactiveOpacity: Double = 0.85

        // Swipe gesture
        static let stride: CGFloat = Tokens.cardWidth
        static let swipeMinDistance: CGFloat = 20
        static let swipeThreshold: CGFloat = 70
        static let edgeDamping: CGFloat = 0.24

        // Hotspot dots
        static let hotspotSize: CGFloat = 12
        static let hotspotDelay: Double = 0.45
        static let hotspotFloatAmount: CGFloat = 4
        static let hotspotShadowOpacity: Double = 0.30
        static let hotspotShadowRadius: CGFloat = 6
        static let hotspotShadowY: CGFloat = 3
        static let floatDuration: Double = 1.8

        static let shirtXRange: ClosedRange<CGFloat> = 0.38...0.62
        static let shirtYRange: ClosedRange<CGFloat> = 0.34...0.48
        static let pantsXRange: ClosedRange<CGFloat> = 0.40...0.60
        static let pantsYRange: ClosedRange<CGFloat> = 0.58...0.70

        // Floating product card
        static let productCardWidth: CGFloat = 178
        static let productCardHeight: CGFloat = 68
        static let productCardOffsetY: CGFloat = 38
        static let productCardCornerRadius: CGFloat = 12
        static let productImageSize: CGFloat = 44
        static let productCardShadowOpacity: Double = 0.18
        static let productCardShadowRadius: CGFloat = 14
        static let productCardShadowY: CGFloat = 6

        // Thumbnail strip
        static let thumbWidth: CGFloat = 18
        static let thumbHeight: CGFloat = 42
        static let thumbSpacing: CGFloat = 4
        static let thumbPaddingH: CGFloat = 10
        static let thumbPaddingV: CGFloat = 6
        static let thumbBottomPadding: CGFloat = 10

        static func randomPosition(in xRange: ClosedRange<CGFloat>, _ yRange: ClosedRange<CGFloat>) -> CGPoint {
            CGPoint(x: .random(in: xRange), y: .random(in: yRange))
        }
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color.white)

            avatarCarousel

            hotspotDotView(index: 0, position: shirtPosition)
            hotspotDotView(index: 1, position: pantsPosition)

            dismissOverlay

            floatingProductCardView(index: 0, position: shirtPosition)
            floatingProductCardView(index: 1, position: pantsPosition)

            CardHeader(subtitle: "Shop the look", title: "Swipe looks", lightText: false)
                .allowsHitTesting(false)

            thumbnailStrip
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .shadow(
            color: Tokens.ShopClient.shadowMColor,
            radius: Tokens.ShopClient.shadowMRadius,
            x: 0,
            y: Tokens.ShopClient.shadowMY
        )
        .contentShape(Rectangle())
        .onChange(of: selectedIndex) { _, _ in resetHotspots() }
        .onAppear { scheduleHotspotReveal() }
        .simultaneousGesture(carouselDragGesture)
    }
}

// MARK: - Subviews

private extension ShopTheLookFocusCard {

    // MARK: Avatar carousel

    var avatarCarousel: some View {
        ZStack {
            ForEach(outfits.indices, id: \.self) { index in
                let relative = CGFloat(index - selectedIndex)

                Image(outfits[index].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: Tokens.cardWidth * Layout.heroWidthRatio,
                        height: Tokens.cardHeight * Layout.heroHeightRatio
                    )
                    .scaleEffect(Layout.heroScale, anchor: .bottom)
                    .offset(
                        x: relative * Layout.stride + dragTranslation,
                        y: Layout.heroOffsetY
                    )
                    .opacity(index == selectedIndex ? 1.0 : Layout.inactiveOpacity)
                    .zIndex(index == selectedIndex ? 10 : 1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .animation(isScrubbing ? nil : Tokens.springSnappy, value: selectedIndex)
    }

    // MARK: Hotspot dots

    @ViewBuilder
    func hotspotDotView(index: Int, position: CGPoint) -> some View {
        if showHotspots && dragTranslation == 0 {
            Circle()
                .fill(Color.white)
                .frame(width: Layout.hotspotSize, height: Layout.hotspotSize)
                .shadow(
                    color: .black.opacity(Layout.hotspotShadowOpacity),
                    radius: Layout.hotspotShadowRadius,
                    x: 0, y: Layout.hotspotShadowY
                )
                .offset(y: floatPhase ? -Layout.hotspotFloatAmount : Layout.hotspotFloatAmount)
                .position(
                    x: Tokens.cardWidth * position.x,
                    y: Tokens.cardHeight * position.y + Layout.heroOffsetY
                )
                .transition(.scale(scale: 0.4).combined(with: .opacity))
                .onTapGesture {
                    Haptics.selection()
                    withAnimation(Tokens.springDefault) {
                        activeProductDot = activeProductDot == index ? nil : index
                    }
                }
        }
    }

    // MARK: Dismiss overlay

    @ViewBuilder
    var dismissOverlay: some View {
        if activeProductDot != nil {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(Tokens.springDefault) {
                        activeProductDot = nil
                    }
                }
        }
    }

    // MARK: Floating product card

    @ViewBuilder
    func floatingProductCardView(index: Int, position: CGPoint) -> some View {
        let products = outfits[selectedIndex].products
        if activeProductDot == index, index < products.count {
            let product = products[index]

            HStack(spacing: 9) {
                FeedProductCard(
                    imageName: product.imageName,
                    size: Layout.productImageSize,
                    cornerRadius: Layout.productCardCornerRadius,
                    showsFavorite: false
                )
                .shadow(color: .clear, radius: 0)

                VStack(alignment: .leading, spacing: 2) {
                    Text(product.merchant)
                        .shopTextStyle(.badge)
                        .foregroundColor(.black.opacity(0.56))
                        .lineLimit(1)

                    Text(product.name)
                        .shopTextStyle(.captionBold)
                        .foregroundColor(.black)
                        .lineLimit(1)

                    Text(product.price)
                        .shopTextStyle(.captionBold)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black.opacity(0.68))
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(width: Layout.productCardWidth, height: Layout.productCardHeight)
            .background(
                RoundedRectangle(cornerRadius: Layout.productCardCornerRadius, style: .continuous)
                    .fill(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: Layout.productCardCornerRadius, style: .continuous)
                            .stroke(Tokens.ShopClient.borderSecondary, lineWidth: 0.5)
                    )
                    .shadow(
                        color: Tokens.ShopClient.shadowMColor,
                        radius: Tokens.ShopClient.shadowMRadius,
                        x: 0,
                        y: Tokens.ShopClient.shadowMY
                    )
            )
            .position(
                x: Tokens.cardWidth * position.x,
                y: Tokens.cardHeight * position.y + Layout.heroOffsetY + Layout.productCardOffsetY
            )
            .transition(.scale(scale: 0.88).combined(with: .opacity))
            .onTapGesture { Haptics.light() }
        }
    }

    // MARK: Thumbnail strip

    var thumbnailStrip: some View {
        GeometryReader { geo in
            let thumbTotal = Layout.thumbWidth * CGFloat(outfits.count)
                + Layout.thumbSpacing * CGFloat(outfits.count - 1)
                + Layout.thumbPaddingH * 2
            let stripOriginX = (geo.size.width - thumbTotal) / 2

            HStack(spacing: Layout.thumbSpacing) {
                ForEach(Array(outfits.enumerated()), id: \.element.id) { index, look in
                    Image(look.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Layout.thumbWidth, height: Layout.thumbHeight)
                        .onTapGesture { scrubTo(index) }
                }
            }
            .padding(.horizontal, Layout.thumbPaddingH)
            .padding(.vertical, Layout.thumbPaddingV)
            .frame(maxWidth: .infinity, alignment: .center)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isScrubbing = true
                        let localX = value.location.x - stripOriginX - Layout.thumbPaddingH
                        let cellWidth = Layout.thumbWidth + Layout.thumbSpacing
                        let clamped = max(0, min(outfits.count - 1, Int(localX / cellWidth)))
                        if clamped != selectedIndex {
                            selectedIndex = clamped
                            Haptics.selection()
                        }
                    }
                    .onEnded { _ in isScrubbing = false }
            )
        }
        .frame(height: Layout.thumbHeight + Layout.thumbPaddingV * 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, Layout.thumbBottomPadding)
    }
}

// MARK: - Gestures & Helpers

private extension ShopTheLookFocusCard {

    var carouselDragGesture: some Gesture {
        DragGesture(minimumDistance: Layout.swipeMinDistance)
            .onChanged { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }

                let tx = value.translation.width
                let atLeftEdge = selectedIndex == 0 && tx > 0
                let atRightEdge = selectedIndex == outfits.count - 1 && tx < 0
                let isAtEdge = atLeftEdge || atRightEdge

                if isAtEdge && !hitEdge {
                    Haptics.soft(intensity: 0.5)
                    hitEdge = true
                } else if !isAtEdge {
                    hitEdge = false
                }

                dragTranslation = isAtEdge ? tx * Layout.edgeDamping : tx
            }
            .onEnded { value in
                hitEdge = false

                guard abs(value.translation.width) > abs(value.translation.height) else {
                    withAnimation(Tokens.springDefault) { dragTranslation = 0 }
                    return
                }

                let projected = value.predictedEndTranslation.width
                var newIndex = selectedIndex

                if projected < -Layout.swipeThreshold { newIndex += 1 }
                else if projected > Layout.swipeThreshold { newIndex -= 1 }

                newIndex = max(0, min(outfits.count - 1, newIndex))

                if newIndex != selectedIndex { Haptics.selection() }

                withAnimation(Tokens.springSnappy) {
                    selectedIndex = newIndex
                    dragTranslation = 0
                }
            }
    }

    func scrubTo(_ index: Int) {
        isScrubbing = true
        selectedIndex = index
        Haptics.selection()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { isScrubbing = false }
    }

    func resetHotspots() {
        showHotspots = false
        activeProductDot = nil
        floatPhase = false
        shirtPosition = Layout.randomPosition(in: Layout.shirtXRange, Layout.shirtYRange)
        pantsPosition = Layout.randomPosition(in: Layout.pantsXRange, Layout.pantsYRange)
        scheduleHotspotReveal()
    }

    func scheduleHotspotReveal() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Layout.hotspotDelay) {
            withAnimation(.easeOut(duration: 0.3)) { showHotspots = true }
            withAnimation(.easeInOut(duration: Layout.floatDuration).repeatForever(autoreverses: true)) {
                floatPhase = true
            }
        }
    }
}
