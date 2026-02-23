//
//  ShoeSwipeCard.swift
//  Shop feed playground
//
//  Three-shoe swipe card with snap paging and color-changing background.
//  Tap a shoe to flip it 90° onto a product card tile.
//

import SwiftUI

struct ShoeSwipeCard: View {
    @State private var selectedIndex: Int = 0
    @State private var dragTranslation: CGFloat = 0
    @State private var hitEdge: Bool = false
    @State private var isExpanded: Bool = false
    @State private var showSimilarCards: Bool = false
    @State private var pressedSimilarCardID: Int? = nil
    @State private var isPushingThread: Bool = false

    private let shoes: [ShoeSlide] = [
        .init(imageName: "ShoeSwipeGreen", background: Color(hex: 0x2F3218)),
        .init(imageName: "ShoeSwipeBlack", background: Color(hex: 0x262525)),
        .init(imageName: "ShoeSwipeWhiteRed", background: Color(hex: 0x331515)),
    ]

    private let shoeWidth: CGFloat = 336
    private let shoeHeight: CGFloat = 504
    private let shoeSpacing: CGFloat = -110
    private let tileSize: CGFloat = 170
    private let similarCardSize: CGFloat = 126

    private let similarImagePool: [String] = [
        "SimilarShoe1", "SimilarShoe2", "SimilarShoe3", "SimilarShoe4",
        "SimilarShoe5", "SimilarShoe6", "SimilarShoe7", "SimilarShoe8",
    ]
    private let similarPricePool: [String] = [
        "$96.00", "$108.00", "$132.00", "$118.00", "$145.00", "$124.00", "$88.00", "$156.00",
    ]

    private let similarSlots: [ShoeSimilarSlot] = [
        .init(
            id: 0,
            offset: CGSize(width: -112, height: -182),
            entryOffset: CGSize(width: -250, height: -300),
            rotation: -11,
            entryRotation: -26,
            scale: 0.86,
            delay: 0.00
        ),
        .init(
            id: 1,
            offset: CGSize(width: 108, height: -176),
            entryOffset: CGSize(width: 258, height: -296),
            rotation: 9,
            entryRotation: 24,
            scale: 0.84,
            delay: 0.04
        ),
        .init(
            id: 2,
            offset: CGSize(width: -118, height: -40),
            entryOffset: CGSize(width: -304, height: -44),
            rotation: -7,
            entryRotation: -19,
            scale: 0.92,
            delay: 0.08
        ),
        .init(
            id: 3,
            offset: CGSize(width: 116, height: -24),
            entryOffset: CGSize(width: 306, height: -8),
            rotation: 8,
            entryRotation: 18,
            scale: 0.90,
            delay: 0.12
        ),
        .init(
            id: 4,
            offset: CGSize(width: -88, height: 146),
            entryOffset: CGSize(width: -240, height: 310),
            rotation: -6,
            entryRotation: -15,
            scale: 0.88,
            delay: 0.16
        ),
        .init(
            id: 5,
            offset: CGSize(width: 94, height: 152),
            entryOffset: CGSize(width: 242, height: 316),
            rotation: 7,
            entryRotation: 16,
            scale: 0.86,
            delay: 0.20
        ),
    ]

    private var similarCardsForSelection: [ShoeSimilarCard] {
        let start = selectedIndex * 2
        return similarSlots.enumerated().map { index, slot in
            let poolIndex = (start + index) % similarImagePool.count
            return .init(
                id: slot.id,
                imageName: similarImagePool[poolIndex],
                price: similarPricePool[poolIndex],
                slot: slot
            )
        }
    }

    private var centerCardOrganicAngle: Double {
        let angles: [Double] = [-4.5, 3.6, -2.8]
        return angles[selectedIndex % angles.count]
    }

    private var shoeThreadProducts: [TopicCardProduct] {
        similarCardsForSelection.map { card in
            TopicCardProduct.make(
                id: "shoe-thread-\(selectedIndex)-\(card.id)",
                imageName: card.imageName,
                price: card.price
            )
        }
    }

    private var shoeThreadTopic: TopicExplorerItem {
        let activeShoe = shoes[selectedIndex]
        return TopicExplorerItem.make(
            id: "shoe-similar-thread-\(selectedIndex)",
            title: "Similar shoe options",
            subtitle: "We shopped this shoe style across the app to show close alternatives you can buy right now.",
            povText: "Matched by shape, color blocking, and everyday-wear profile from your selected pair.",
            backgroundImageName: activeShoe.imageName,
            color: 0x232323,
            accent: 0x404040,
            sourceChips: ["In-app catalog", "Saved looks", "Recent drops"],
            interestPills: ["Nike Cortez", "Low profile", "Everyday pairs"],
            trendingMerchants: ["Nike", "Kith", "END."],
            products: shoeThreadProducts
        )
    }

    var body: some View {
        let selectedShoe = shoes[selectedIndex]

        ZStack {
            // Background
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(selectedShoe.background)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )
                .animation(.easeInOut(duration: 0.25), value: selectedIndex)

            // Carousel layer
            let stride = shoeWidth + shoeSpacing

            ZStack {
                // Ground shadow
                if !isExpanded {
                    Ellipse()
                        .fill(.black.opacity(0.12))
                        .frame(width: 220, height: 28)
                        .blur(radius: 24)
                        .offset(y: 196)
                }

                // White product tile (behind the shoe when expanded)
                if isExpanded {
                    productTile
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                        .zIndex(4)
                }

                if isExpanded {
                    similarProductCluster
                        .zIndex(3)
                        .allowsHitTesting(showSimilarCards)
                }

                ForEach(shoes.indices, id: \.self) { index in
                    let relative = CGFloat(index - selectedIndex)
                    let isActive = index == selectedIndex

                    shoeView(index: index, isActive: isActive, relative: relative, stride: stride)
                }
                .animation(Tokens.springExpand, value: isExpanded)
                .animation(Tokens.springSnappy, value: selectedIndex)
            }

            // Top lockup
            VStack {
                HStack(alignment: .center, spacing: 12) {
                    Text("Shop similar")
                        .shopTextStyle(.subtitle)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 26)
                .padding(.horizontal, 22)

                Spacer()
            }
            .allowsHitTesting(false)

            // Bottom CTA (shown with similar grid)
            VStack {
                Spacer()
                Button(action: {
                    Haptics.light()
                    isPushingThread = true
                }) {
                    Text("Explore more")
                        .shopTextStyle(.bodyLargeBold)
                        .foregroundStyle(selectedShoe.background)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(.white))
                }
                .padding(.bottom, 40)
            }
            .opacity(showSimilarCards ? 1 : 0)
            .scaleEffect(showSimilarCards ? 1 : 0.94)
            .offset(y: showSimilarCards ? 0 : 12)
            .zIndex(12)
            .animation(
                .spring(response: 0.52, dampingFraction: 0.86).delay(showSimilarCards ? 0.1 : 0),
                value: showSimilarCards
            )
            .allowsHitTesting(showSimilarCards)

            // Tap-to-dismiss overlay when expanded
            if isExpanded {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        collapseExpandedView()
                    }
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .contentShape(Rectangle())
        .onAppear {
            showSimilarCards = false
            pressedSimilarCardID = nil
        }
        .onChange(of: selectedIndex) { _, _ in
            showSimilarCards = false
            pressedSimilarCardID = nil
        }
        .simultaneousGesture(
            isExpanded ? nil :
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    guard abs(value.translation.width) > abs(value.translation.height) else { return }

                    let translation = value.translation.width
                    let isPushingLeftEdge = selectedIndex == 0 && translation > 0
                    let isPushingRightEdge = selectedIndex == shoes.count - 1 && translation < 0
                    let isAtEdge = isPushingLeftEdge || isPushingRightEdge

                    if isAtEdge && !hitEdge {
                        Haptics.soft(intensity: 0.5)
                        hitEdge = true
                    } else if !isAtEdge {
                        hitEdge = false
                    }

                    dragTranslation = isAtEdge ? translation * 0.24 : translation
                }
                .onEnded { value in
                    hitEdge = false

                    guard abs(value.translation.width) > abs(value.translation.height) else {
                        withAnimation(Tokens.springDefault) {
                            dragTranslation = 0
                        }
                        return
                    }

                    let projected = value.predictedEndTranslation.width
                    let threshold: CGFloat = 70
                    var newIndex = selectedIndex

                    if projected < -threshold {
                        newIndex += 1
                    } else if projected > threshold {
                        newIndex -= 1
                    }

                    newIndex = max(0, min(shoes.count - 1, newIndex))

                    if newIndex != selectedIndex {
                        Haptics.selection()
                    }

                    withAnimation(Tokens.springSnappy) {
                        selectedIndex = newIndex
                        dragTranslation = 0
                    }
                }
        )
        .navigationDestination(isPresented: $isPushingThread) {
            ThreadBlankView(topic: shoeThreadTopic) {
                isPushingThread = false
            }
        }
    }

    // MARK: - Individual shoe view

    @ViewBuilder
    private func shoeView(index: Int, isActive: Bool, relative: CGFloat, stride: CGFloat) -> some View {
        let expandedActive = isExpanded && isActive

        Image(shoes[index].imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: expandedActive ? 278 : shoeWidth,
                height: expandedActive ? 186 : shoeHeight
            )
            .rotationEffect(.degrees(expandedActive ? 90 : 0))
            .scaleEffect(expandedActive ? 1.0 : (isActive ? 1.0 : 0.9))
            .opacity(isExpanded ? (isActive ? 1.0 : 0) : (isActive ? 1.0 : 0.98))
            .shadow(
                color: .black.opacity(isActive ? 0.10 : 0.05),
                radius: isActive ? 20 : 12,
                x: 0,
                y: isActive ? 12 : 6
            )
            .offset(
                x: isExpanded
                    ? (isActive ? 0 : (relative < 0 ? -500 : 500))
                    : (relative * stride + dragTranslation),
                y: expandedActive ? -6 : -32
            )
            .zIndex(isActive ? 10 : 1)
            .onTapGesture {
                guard isActive && !isExpanded else { return }
                expandSelectedShoe()
            }
    }

    // MARK: - Product tile (white card behind the shoe when expanded)

    private var productTile: some View {
        SpotlightProductTile(size: tileSize, price: "$50.00")
            .rotationEffect(.degrees(isExpanded ? centerCardOrganicAngle : 0))
            .offset(x: isExpanded ? -6 : 0, y: isExpanded ? 2 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.84), value: isExpanded)
            .animation(.spring(response: 0.5, dampingFraction: 0.84), value: selectedIndex)
            .zIndex(5)
    }

    private var similarProductCluster: some View {
        ZStack {
            ForEach(similarCardsForSelection) { card in
                let isPressed = pressedSimilarCardID == card.id
                let restingScale = showSimilarCards ? card.slot.scale : 0.62

                FeedProductCard(
                    imageName: card.imageName,
                    size: similarCardSize,
                    cornerRadius: 20,
                    priceBadgeText: card.price,
                    showsFavorite: true,
                    imageOverlayOpacity: 0
                )
                .scaleEffect(isPressed ? restingScale * 2.0 : restingScale)
                .rotationEffect(
                    .degrees(
                        showSimilarCards
                            ? (isPressed ? 0 : card.slot.rotation)
                            : card.slot.entryRotation
                    )
                )
                .offset(
                    x: showSimilarCards ? card.slot.offset.width : card.slot.entryOffset.width,
                    y: showSimilarCards ? card.slot.offset.height : card.slot.entryOffset.height
                )
                .opacity(showSimilarCards ? 1 : 0)
                .blur(radius: showSimilarCards ? 0 : 4)
                .zIndex(isPressed ? 20 : 1)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            guard showSimilarCards else { return }
                            guard pressedSimilarCardID != card.id else { return }
                            withAnimation(.spring(response: 0.26, dampingFraction: 0.8)) {
                                pressedSimilarCardID = card.id
                            }
                        }
                        .onEnded { _ in
                            guard pressedSimilarCardID == card.id else { return }
                            withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                                pressedSimilarCardID = nil
                            }
                        }
                )
                .animation(
                    .spring(response: 0.56, dampingFraction: 0.82).delay(card.slot.delay),
                    value: showSimilarCards
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.82), value: pressedSimilarCardID)
            }
        }
    }

    private func expandSelectedShoe() {
        Haptics.light()
        showSimilarCards = false
        pressedSimilarCardID = nil
        withAnimation(Tokens.springExpand) {
            isExpanded = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            guard isExpanded else { return }
            withAnimation(.spring(response: 0.52, dampingFraction: 0.84)) {
                showSimilarCards = true
            }
        }
    }

    private func collapseExpandedView() {
        Haptics.light()
        pressedSimilarCardID = nil
        withAnimation(.spring(response: 0.3, dampingFraction: 0.86)) {
            showSimilarCards = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            withAnimation(Tokens.springExpand) {
                isExpanded = false
            }
        }
    }
}

private struct ShoeSlide {
    let imageName: String
    let background: Color
}

private struct ShoeSimilarSlot {
    let id: Int
    let offset: CGSize
    let entryOffset: CGSize
    let rotation: Double
    let entryRotation: Double
    let scale: CGFloat
    let delay: Double
}

private struct ShoeSimilarCard: Identifiable {
    let id: Int
    let imageName: String
    let price: String
    let slot: ShoeSimilarSlot
}
