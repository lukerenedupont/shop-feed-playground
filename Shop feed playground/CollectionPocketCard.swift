//
//  CollectionPocketCard.swift
//  Shop feed playground
//
//  Color-curated shoe collections on an arc carousel.
//  Swipe to browse. Tap a glass card to expand into a product grid.
//

import SwiftUI

// MARK: - Layout Constants

private enum Layout {
    // Arc carousel
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

    // Product grid (expanded)
    static let gridSize: CGFloat    = 160
    static let gridSpacing: CGFloat = 12
    static let gridPadH: CGFloat    = 18

    // Close button
    static let closeSize: CGFloat = 44

    // Logo
    static let logoHeight: CGFloat  = 38
    static let logoPadTop: CGFloat  = 20
}

// MARK: - Card Data

private struct CardData {
    let color: Color
    let label: String
    let images: [String]
    let prices: [String]
}

private let allCards: [CardData] = [
    .init(color: Color(hex: 0x3A6FB5), label: "Blue",
          images: ["BlueShoe1", "BlueShoe2", "BlueShoe3", "BlueShoe4", "BlueShoe5", "BlueShoe6"],
          prices: ["$129", "$185", "$160", "$175", "$195", "$95"]),
    .init(color: Color(hex: 0xB0B0B0), label: "Silver",
          images: ["SilverShoe1", "SilverShoe2", "SilverShoe3", "SilverShoe4", "SilverShoe5", "SilverShoe6"],
          prices: ["$210", "$165", "$180", "$145", "$155", "$190"]),
    .init(color: Color(hex: 0x3A7D4A), label: "Green",
          images: ["GreenShoe1", "GreenShoe2", "GreenShoe3", "GreenShoe4", "GreenShoe5", "GreenShoe6"],
          prices: ["$175", "$195", "$140", "$210", "$95", "$165"]),
    .init(color: Color(hex: 0xE8E4DF), label: "White",
          images: ["WhiteShoe1", "WhiteShoe2", "WhiteShoe3", "WhiteShoe4", "WhiteShoe5", "WhiteShoe6"],
          prices: ["$135", "$120", "$85", "$175", "$160", "$150"]),
    .init(color: Color(hex: 0x8B6F4E), label: "Brown",
          images: ["BrownShoe1", "BrownShoe2", "BrownShoe3", "BrownShoe4", "BrownShoe5", "BrownShoe6"],
          prices: ["$155", "$190", "$110", "$145", "$220", "$170"]),
    .init(color: Color(hex: 0x2A2A2A), label: "Black",
          images: ["BlackShoe1", "BlackShoe2", "BlackShoe3", "BlackShoe4", "BlackShoe5", "BlackShoe6"],
          prices: ["$130", "$210", "$165", "$95", "$185", "$175"]),
]

// MARK: - Pile Layout

private struct PileSlot {
    let image: String
    let rot: Double
    let x: CGFloat
    let y: CGFloat
}

private let pileOffsets: [[(rot: Double, x: CGFloat, y: CGFloat)]] = [
    [(-12, -40, -134), (  8,  35, -130), ( -4,  -8, -138), ( 15,  48, -132), ( -9, -44, -136), (  6,  20, -140)],
    [( 10,  42, -132), ( -7, -36, -136), ( 14,   6, -130), ( -5, -48, -134), ( 11,  38, -138), ( -3, -16, -142)],
    [( -8, -44, -136), ( 12,  40, -130), ( -6,  -6, -134), ( 10,  46, -138), (-14, -38, -132), (  5,  22, -140)],
    [(  7,  36, -134), (-11, -42, -130), (  5,  10, -138), ( -9, -46, -132), ( 13,  44, -136), ( -6, -18, -140)],
    [(-13, -38, -132), (  9,  44, -136), ( -5,   8, -130), ( 11,  40, -138), ( -8, -46, -134), (  4,  14, -142)],
    [( 11, -42, -130), ( -6,  38, -136), (  8, -10, -134), (-12,  46, -138), (  5, -44, -132), ( -9,  18, -140)],
]

private let allPiles: [[PileSlot]] = {
    (0..<allCards.count).map { ci in
        let card = allCards[ci]
        let offsets = pileOffsets[ci]
        return (0..<card.images.count).map { pi in
            PileSlot(image: card.images[pi], rot: offsets[pi].rot, x: offsets[pi].x, y: offsets[pi].y)
        }
    }
}()

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
    @State private var currentIndex: Int = 2
    @State private var dragOffset: CGFloat = 0
    @State private var expandedIndex: Int? = nil
    @State private var favorites: Set<String> = []
    @State private var showOverlays = false
    @Namespace private var hero

    private var isExpanded: Bool { expandedIndex != nil }
    private let expandSpring = Animation.spring(response: 0.35, dampingFraction: 0.78)

    private var continuousPosition: CGFloat {
        CGFloat(currentIndex) - dragOffset / Layout.dragPerCard
    }

    private var bgColor: Color {
        if let idx = expandedIndex { return allCards[idx].color }
        let pos = max(0, min(continuousPosition, CGFloat(allCards.count - 1)))
        let lo = Int(pos), hi = min(lo + 1, allCards.count - 1)
        return allCards[lo].color.interpolate(to: allCards[hi].color, fraction: pos - CGFloat(lo))
    }

    // MARK: Body

    var body: some View {
        ZStack {
            background
            content
            glassLayer.simultaneousGesture(isExpanded ? nil : swipeGesture)
            logo
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .animation(expandSpring, value: expandedIndex)
    }
}

// MARK: - Background

private extension CollectionPocketCard {
    var background: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [bgColor.opacity(0.85), bgColor, bgColor.opacity(0.9)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.12), .clear, .black.opacity(0.08)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
            )
    }
}

// MARK: - Content Switcher

private extension CollectionPocketCard {
    @ViewBuilder var content: some View {
        if let idx = expandedIndex {
            productGrid(for: idx)
        } else {
            productPiles.allowsHitTesting(false)
        }
    }
}

// MARK: - Logo

private extension CollectionPocketCard {
    var logo: some View {
        Image("LogoKith")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: Layout.logoHeight)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, Layout.logoPadTop)
            .offset(y: isExpanded ? -60 : 0)
            .opacity(isExpanded ? 0 : 1)
            .animation(expandSpring, value: expandedIndex)
    }
}

// MARK: - Collapsed Product Piles

private extension CollectionPocketCard {
    var productPiles: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                ForEach(0..<allCards.count, id: \.self) { ci in
                    let s = arcState(for: ci)
                    pile(cardIndex: ci, peek: s.peekFraction, time: t)
                        .rotationEffect(.degrees(s.angle))
                        .offset(x: s.x, y: s.y)
                        .zIndex(s.zIndex)
                }
            }
        }
        .animation(dragOffset == 0 ? Tokens.springDefault : .interactiveSpring(), value: continuousPosition)
    }

    func pile(cardIndex ci: Int, peek: CGFloat, time t: Double) -> some View {
        ZStack {
            ForEach(0..<allPiles[ci].count, id: \.self) { pi in
                pileProduct(cardIndex: ci, productIndex: pi, peek: peek, time: t)
            }
        }
    }

    func pileProduct(cardIndex ci: Int, productIndex pi: Int, peek: CGFloat, time t: Double) -> some View {
        let slot = allPiles[ci][pi]
        let p = Double(peek)
        let phase = Double(pi) * 1.4

        let px = slot.x * (0.3 + 0.7 * peek)
        let py = slot.y * (0.25 + 0.75 * peek)
        let pr = slot.rot * (0.4 + 0.6 * p)

        let fx = cos(t * 0.8 + phase * 1.6) * 2.5 * p
        let fy = sin(t * 1.1 + phase) * 4.0 * p
        let fr = sin(t * 0.6 + phase * 0.9) * 2.0 * p
        let fs = 1.0 + sin(t * 0.9 + phase * 1.2) * 0.03 * p

        return Image(slot.image)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.pileSize, height: Layout.pileSize)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 2)
            .matchedGeometryEffect(id: "product-\(ci)-\(pi)", in: hero)
            .scaleEffect(fs)
            .rotationEffect(.degrees(pr + fr))
            .offset(x: px + CGFloat(fx), y: py + CGFloat(fy))
            .opacity(0.4 + 0.6 * p)
            .zIndex(Double(pi))
    }
}

// MARK: - Expanded Product Grid

private extension CollectionPocketCard {
    func productGrid(for ci: Int) -> some View {
        let pile = allPiles[ci]
        let columns = Array(repeating: GridItem(.fixed(Layout.gridSize), spacing: Layout.gridSpacing), count: 2)

        return VStack(spacing: 0) {
            LazyVGrid(columns: columns, spacing: Layout.gridSpacing) {
                ForEach(0..<pile.count, id: \.self) { pi in
                    gridTile(cardIndex: ci, productIndex: pi)
                }
            }
            .padding(.top, 28)
            .padding(.horizontal, Layout.gridPadH)
            Spacer()
        }
    }

    func gridTile(cardIndex ci: Int, productIndex pi: Int) -> some View {
        let favKey = "\(ci)-\(pi)"
        let isFav = favorites.contains(favKey)

        return Image(allPiles[ci][pi].image)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.gridSize, height: Layout.gridSize)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .matchedGeometryEffect(id: "product-\(ci)-\(pi)", in: hero)
            .overlay(alignment: .topLeading) { priceTag(ci: ci, pi: pi) }
            .overlay(alignment: .bottomTrailing) { heartButton(favKey: favKey, isFav: isFav) }
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
    }

    func priceTag(ci: Int, pi: Int) -> some View {
        Text(allCards[ci].prices[pi])
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(.black.opacity(0.15)))
            .padding(8)
            .opacity(showOverlays ? 1 : 0)
    }

    func heartButton(favKey: String, isFav: Bool) -> some View {
        Button {
            Haptics.light()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                if isFav { favorites.remove(favKey) } else { favorites.insert(favKey) }
            }
        } label: {
            Image(isFav ? "HeartIcon" : "HeartOutlineIcon")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(.black.opacity(0.15)))
        }
        .padding(8)
        .opacity(showOverlays ? 1 : 0)
    }
}

// MARK: - Glass Layer

private extension CollectionPocketCard {
    var glassLayer: some View {
        ZStack {
            ForEach(0..<allCards.count, id: \.self) { index in
                glassCard(for: index)
            }
        }
        .animation(isExpanded ? expandSpring : (dragOffset == 0 ? Tokens.springDefault : .interactiveSpring()), value: continuousPosition)
        .animation(expandSpring, value: expandedIndex)
    }

    func glassCard(for index: Int) -> some View {
        let s = arcState(for: index)
        let morphed = expandedIndex == index
        let hidden = isExpanded && !morphed

        let w: CGFloat = morphed ? Layout.closeSize : Layout.glassW
        let h: CGFloat = morphed ? Layout.closeSize : Layout.glassH
        let r: CGFloat = morphed ? Layout.closeSize / 2 : Tokens.radiusCard

        let px: CGFloat = morphed ? 0 : s.x
        let py: CGFloat = morphed ? Tokens.cardHeight / 2 - 60 : s.y
        let rot: Double  = morphed ? 0 : s.angle
        let dx: CGFloat  = hidden ? (index < (expandedIndex ?? 0) ? -500 : 500) : 0

        return ZStack {
            RoundedRectangle(cornerRadius: r, style: .continuous)
                .fill(allCards[index].color.opacity(0.22))
                .background(
                    RoundedRectangle(cornerRadius: r, style: .continuous)
                        .fill(.ultraThinMaterial.opacity(0.85))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: r, style: .continuous)
                        .stroke(Color.white.opacity(morphed ? 0.3 : 0.5), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: -6) {
                Text("The")
                Text(allCards[index].label)
                Text("Edit")
            }
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(.white)
            .tracking(-1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(16)
            .opacity(morphed ? 0 : Double(s.peekFraction))

            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white.opacity(0.8))
                .opacity(morphed ? 1 : 0)
        }
        .frame(width: w, height: h)
        .clipShape(RoundedRectangle(cornerRadius: r, style: .continuous))
        .shadow(color: .black.opacity(morphed ? 0.2 : 0.08), radius: morphed ? 8 : 12, x: 0, y: morphed ? 4 : 4)
        .rotationEffect(.degrees(rot))
        .offset(x: px, y: py)
        .zIndex(morphed ? 200 : s.zIndex)
        .offset(x: dx)
        .opacity(hidden ? 0 : 1)
        .allowsHitTesting(morphed || (!isExpanded && s.isCentered))
        .onTapGesture { tapGlass(index: index, morphed: morphed, isCentered: s.isCentered) }
    }

    func tapGlass(index: Int, morphed: Bool, isCentered: Bool) {
        if morphed {
            Haptics.light()
            withAnimation(.easeOut(duration: 0.12)) { showOverlays = false }
            withAnimation(expandSpring) { expandedIndex = nil }
        } else if isCentered {
            Haptics.light()
            withAnimation(expandSpring) { expandedIndex = index }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeInOut(duration: 0.35)) { showOverlays = true }
            }
        }
    }
}

// MARK: - Swipe Gesture & Arc Math

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
                if value.translation.width < -Layout.swipeThreshold && currentIndex < allCards.count - 1 {
                    next += 1
                } else if value.translation.width > Layout.swipeThreshold && currentIndex > 0 {
                    next -= 1
                }
                if next != currentIndex { Haptics.selection() }
                withAnimation(Tokens.springDefault) { currentIndex = next; dragOffset = 0 }
            }
    }

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
