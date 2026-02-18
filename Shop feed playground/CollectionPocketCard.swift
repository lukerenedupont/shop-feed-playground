//
//  CollectionPocketCard.swift
//  Shop feed playground
//
//  Color-curated shoe collections on an arc carousel.
//  Swipe to browse. Tap a glass card to expand into a product grid.
//
//  Data: CollectionPocketData.swift
//  Shared: SharedComponents.swift
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    // Arc
    static let arcRadius: CGFloat    = 900
    static let anglePerCard: CGFloat = 16.25
    static let dragPerCard: CGFloat  = 132
    static let arcYOffset: CGFloat   = 132
    static let swipeThreshold: CGFloat       = 30
    static let centeredThreshold: CGFloat    = 0.3
    static let centeredDragThreshold: CGFloat = 15

    // Glass card
    static let glassW: CGFloat = 208
    static let glassH: CGFloat = 240

    // Product pile (collapsed)
    static let pileSize: CGFloat = 80
    static let pileCorner: CGFloat = 10

    // Product grid (expanded)
    static let gridSize: CGFloat    = 160
    static let gridSpacing: CGFloat = 12
    static let gridPadH: CGFloat    = 18
    static let gridPadTop: CGFloat  = 28

    // Close button
    static let closeSize: CGFloat = 44
    static let closeY: CGFloat    = -60   // from center-bottom

    // Expand spring
    static let expandSpring = Animation.spring(response: 0.35, dampingFraction: 0.78)
}

// MARK: - Arc State

private struct ArcState {
    let x: CGFloat
    let y: CGFloat
    let angle: Double
    let zIndex: Double
    let isCentered: Bool
    let peekFraction: CGFloat
}

// MARK: - Collection Pocket Card

struct CollectionPocketCard: View {
    @State private var currentIndex = 2
    @State private var dragOffset: CGFloat = 0
    @State private var expandedIndex: Int?
    @State private var favorites: Set<String> = []
    @State private var showOverlays = false
    @Namespace private var hero

    private let collections = PocketCollection.defaults
    private let pileLayouts = PocketPileSlot.layouts

    private var isExpanded: Bool { expandedIndex != nil }

    private var continuousPosition: CGFloat {
        CGFloat(currentIndex) - dragOffset / Layout.dragPerCard
    }

    private var bgColor: Color {
        if let idx = expandedIndex { return collections[idx].color }
        let pos = max(0, min(continuousPosition, CGFloat(collections.count - 1)))
        let lo = Int(pos), hi = min(lo + 1, collections.count - 1)
        return collections[lo].color.interpolate(to: collections[hi].color, fraction: pos - CGFloat(lo))
    }

    // MARK: Body

    var body: some View {
        ZStack {
            GradientCardFill(color: bgColor)
            content
            glassLayer.simultaneousGesture(isExpanded ? nil : swipeGesture)
            logo
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .animation(Layout.expandSpring, value: expandedIndex)
    }
}

// MARK: - Content Switcher

private extension CollectionPocketCard {
    @ViewBuilder var content: some View {
        if let idx = expandedIndex {
            expandedGrid(for: idx)
        } else {
            collapsedPiles.allowsHitTesting(false)
        }
    }
}

// MARK: - Logo

private extension CollectionPocketCard {
    var logo: some View {
        MerchantLogo(image: "LogoKith")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 20)
            .offset(y: isExpanded ? -60 : 0)
            .opacity(isExpanded ? 0 : 1)
            .animation(Layout.expandSpring, value: expandedIndex)
    }
}

// MARK: - Collapsed Piles (Arc Carousel)

private extension CollectionPocketCard {
    var collapsedPiles: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                ForEach(collections.indices, id: \.self) { ci in
                    let s = arcState(for: ci)
                    pileGroup(collectionIndex: ci, peek: s.peekFraction, time: time)
                        .rotationEffect(.degrees(s.angle))
                        .offset(x: s.x, y: s.y)
                        .zIndex(s.zIndex)
                }
            }
        }
        .animation(dragOffset == 0 ? Tokens.springDefault : .interactiveSpring(), value: continuousPosition)
    }

    func pileGroup(collectionIndex ci: Int, peek: CGFloat, time: Double) -> some View {
        let products = collections[ci].products
        let slots = pileLayouts[ci]

        return ZStack {
            ForEach(products.indices, id: \.self) { pi in
                pileProduct(
                    image: products[pi].image,
                    slot: slots[pi],
                    matchID: "product-\(ci)-\(pi)",
                    index: pi,
                    peek: peek,
                    time: time
                )
            }
        }
    }

    func pileProduct(image: String, slot: PocketPileSlot, matchID: String,
                     index: Int, peek: CGFloat, time: Double) -> some View {
        let p = Double(peek)
        let phase = Double(index) * 1.4

        let px = slot.x * (0.3 + 0.7 * peek)
        let py = slot.y * (0.25 + 0.75 * peek)
        let pr = slot.rotation * (0.4 + 0.6 * p)

        let fx = cos(time * 0.8 + phase * 1.6) * 2.5 * p
        let fy = sin(time * 1.1 + phase) * 4.0 * p
        let fr = sin(time * 0.6 + phase * 0.9) * 2.0 * p
        let fs = 1.0 + sin(time * 0.9 + phase * 1.2) * 0.03 * p

        return Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.pileSize, height: Layout.pileSize)
            .clipShape(RoundedRectangle(cornerRadius: Layout.pileCorner, style: .continuous))
            .shadow(
                color: Tokens.ShopClient.shadowSColor,
                radius: Tokens.ShopClient.shadowSRadius,
                x: 0,
                y: Tokens.ShopClient.shadowSY
            )
            .matchedGeometryEffect(id: matchID, in: hero)
            .scaleEffect(fs)
            .rotationEffect(.degrees(pr + fr))
            .offset(x: px + CGFloat(fx), y: py + CGFloat(fy))
            .opacity(0.4 + 0.6 * p)
            .zIndex(Double(index))
    }
}

// MARK: - Expanded Grid

private extension CollectionPocketCard {
    func expandedGrid(for ci: Int) -> some View {
        let products = collections[ci].products
        let columns = Array(repeating: GridItem(.fixed(Layout.gridSize), spacing: Layout.gridSpacing), count: 2)

        return VStack(spacing: 0) {
            LazyVGrid(columns: columns, spacing: Layout.gridSpacing) {
                ForEach(products.indices, id: \.self) { pi in
                    gridTile(collectionIndex: ci, productIndex: pi)
                }
            }
            .padding(.top, Layout.gridPadTop)
            .padding(.horizontal, Layout.gridPadH)
            Spacer()
        }
    }

    func gridTile(collectionIndex ci: Int, productIndex pi: Int) -> some View {
        let product = collections[ci].products[pi]
        let favKey = "\(ci)-\(pi)"
        let isFav = favorites.contains(favKey)

        return ProductTile(image: product.image, size: Layout.gridSize)
            .matchedGeometryEffect(id: "product-\(ci)-\(pi)", in: hero)
            .overlay(alignment: .topLeading) {
                PriceTag(text: product.price)
                    .padding(8)
                    .opacity(showOverlays ? 1 : 0)
            }
            .overlay(alignment: .bottomTrailing) {
                FavoriteButton(isFavorite: isFav) {
                    Haptics.light()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        if isFav { favorites.remove(favKey) } else { favorites.insert(favKey) }
                    }
                }
                .padding(8)
                .opacity(showOverlays ? 1 : 0)
            }
    }
}

// MARK: - Glass Layer

private extension CollectionPocketCard {
    var glassLayer: some View {
        ZStack {
            ForEach(collections.indices, id: \.self) { i in
                glassCard(for: i)
            }
        }
        .animation(isExpanded ? Layout.expandSpring : (dragOffset == 0 ? Tokens.springDefault : .interactiveSpring()), value: continuousPosition)
        .animation(Layout.expandSpring, value: expandedIndex)
    }

    func glassCard(for index: Int) -> some View {
        let s = arcState(for: index)
        let collection = collections[index]
        let morphed = expandedIndex == index
        let hidden = isExpanded && !morphed

        let w: CGFloat = morphed ? Layout.closeSize : Layout.glassW
        let h: CGFloat = morphed ? Layout.closeSize : Layout.glassH
        let r: CGFloat = morphed ? Layout.closeSize / 2 : Tokens.radiusCard

        let px: CGFloat = morphed ? 0 : s.x
        let py: CGFloat = morphed ? Tokens.cardHeight / 2 + Layout.closeY : s.y
        let rot: Double  = morphed ? 0 : s.angle
        let dx: CGFloat  = hidden ? (index < (expandedIndex ?? 0) ? -500 : 500) : 0

        return ZStack {
            glassBackground(color: collection.color, radius: r, morphed: morphed)
            glassLabel(label: collection.label, morphed: morphed, peek: s.peekFraction)
            glassCloseIcon(morphed: morphed)
        }
        .frame(width: w, height: h)
        .clipShape(RoundedRectangle(cornerRadius: r, style: .continuous))
        .shadow(
            color: morphed ? Tokens.ShopClient.shadowMColor : Tokens.ShopClient.shadowSColor,
            radius: morphed ? Tokens.ShopClient.shadowMRadius : Tokens.ShopClient.shadowSRadius,
            x: 0,
            y: morphed ? Tokens.ShopClient.shadowMY : Tokens.ShopClient.shadowSY
        )
        .rotationEffect(.degrees(rot))
        .offset(x: px, y: py)
        .zIndex(morphed ? 200 : s.zIndex)
        .offset(x: dx)
        .opacity(hidden ? 0 : 1)
        .allowsHitTesting(morphed || (!isExpanded && s.isCentered))
        .onTapGesture { handleGlassTap(index: index, morphed: morphed, isCentered: s.isCentered) }
    }

    func glassBackground(color: Color, radius: CGFloat, morphed: Bool) -> some View {
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(color.opacity(0.22))
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.white.opacity(morphed ? 0.3 : 0.5), lineWidth: 1)
            )
    }

    func glassLabel(label: String, morphed: Bool, peek: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: -6) {
            Text("The")
            Text(label)
            Text("Edit")
        }
        .shopTextStyle(.heroBold)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .padding(16)
        .opacity(morphed ? 0 : Double(peek))
    }

    func glassCloseIcon(morphed: Bool) -> some View {
        Image(systemName: "xmark")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.white.opacity(0.8))
            .opacity(morphed ? 1 : 0)
    }

    func handleGlassTap(index: Int, morphed: Bool, isCentered: Bool) {
        if morphed {
            Haptics.light()
            withAnimation(.easeOut(duration: 0.12)) { showOverlays = false }
            withAnimation(Layout.expandSpring) { expandedIndex = nil }
        } else if isCentered {
            Haptics.light()
            withAnimation(Layout.expandSpring) { expandedIndex = index }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 0.35)) { showOverlays = true }
            }
        }
    }
}

// MARK: - Swipe Gesture

private extension CollectionPocketCard {
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 16)
            .onChanged { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                dragOffset = value.translation.width
            }
            .onEnded { value in
                guard abs(value.translation.width) > abs(value.translation.height) else {
                    withAnimation(Tokens.springDefault) { dragOffset = 0 }
                    return
                }
                var next = currentIndex
                if value.translation.width < -Layout.swipeThreshold, currentIndex < collections.count - 1 {
                    next += 1
                } else if value.translation.width > Layout.swipeThreshold, currentIndex > 0 {
                    next -= 1
                }
                if next != currentIndex { Haptics.selection() }
                withAnimation(Tokens.springDefault) { currentIndex = next; dragOffset = 0 }
            }
    }
}

// MARK: - Arc Math

private extension CollectionPocketCard {
    func arcState(for index: Int) -> ArcState {
        let rel = CGFloat(index) - continuousPosition
        let angle = rel * Layout.anglePerCard
        let rad = angle * .pi / 180

        return ArcState(
            x: sin(rad) * Layout.arcRadius,
            y: (1 - cos(rad)) * Layout.arcRadius + Layout.arcYOffset,
            angle: Double(angle),
            zIndex: 100 - Double(abs(angle)),
            isCentered: abs(rel) < Layout.centeredThreshold && abs(dragOffset) < Layout.centeredDragThreshold,
            peekFraction: max(0, 1 - abs(rel) * 1.5)
        )
    }
}
