//
//  CollectionPocketCardV2.swift
//  Shop feed playground
//
//  Category folder grid — 2x2 folders, each holding a brand collection.
//  Long-press to peek inside. Tap to expand into a product grid.
//
//  Data: CollectionPocketData.swift
//  Shared: SharedComponents.swift
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    // Folder card
    static let folderW: CGFloat    = 160
    static let folderH: CGFloat    = 165
    static let tabW: CGFloat       = 80
    static let tabH: CGFloat       = 24
    static let tabCorner: CGFloat  = 10
    static let bodyCorner: CGFloat = 14
    static let folderSpacing: CGFloat = 20
    static let folderGridTop: CGFloat = 80

    // Product pile (collapsed, behind folder)
    static let pileSize: CGFloat   = 100
    static let pileCorner: CGFloat = 12

    // Product grid (expanded)
    static let gridSize: CGFloat    = 160
    static let gridSpacing: CGFloat = 12
    static let gridPadH: CGFloat    = 18
    static let gridPadTop: CGFloat  = 28

    // Close button
    static let closeSize: CGFloat = 44

    // Animation
    static let expandSpring = Animation.spring(response: 0.35, dampingFraction: 0.78)
    static let peekSpring   = Animation.spring(response: 0.4, dampingFraction: 0.7)
}

// MARK: - Category Folder Data

private struct CategoryFolder {
    let category: String
    let brand: String
}

private let folders: [CategoryFolder] = [
    .init(category: "Shoes",         brand: "KICKS CREW"),
    .init(category: "Shirts & Tops", brand: "YoungLA"),
    .init(category: "Pants",         brand: "PURPLE BRAND"),
    .init(category: "Activewear",    brand: "BYLT Basics"),
]

// MARK: - Folder Shape

private struct FolderShape: Shape {
    var tabWidth: CGFloat
    var tabHeight: CGFloat
    var tabCorner: CGFloat
    var bodyCorner: CGFloat

    func path(in rect: CGRect) -> Path {
        let tc = min(tabCorner, tabHeight / 2)
        let bc = bodyCorner

        var p = Path()
        p.move(to: CGPoint(x: tc, y: 0))
        p.addLine(to: CGPoint(x: tabWidth - tc, y: 0))
        p.addQuadCurve(to: CGPoint(x: tabWidth, y: tabHeight), control: CGPoint(x: tabWidth, y: 0))
        p.addLine(to: CGPoint(x: rect.width - bc, y: tabHeight))
        p.addQuadCurve(to: CGPoint(x: rect.width, y: tabHeight + bc), control: CGPoint(x: rect.width, y: tabHeight))
        p.addLine(to: CGPoint(x: rect.width, y: rect.height - bc))
        p.addQuadCurve(to: CGPoint(x: rect.width - bc, y: rect.height), control: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: bc, y: rect.height))
        p.addQuadCurve(to: CGPoint(x: 0, y: rect.height - bc), control: CGPoint(x: 0, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: tc))
        p.addQuadCurve(to: CGPoint(x: tc, y: 0), control: CGPoint(x: 0, y: 0))
        p.closeSubpath()
        return p
    }
}

private let folderClip = FolderShape(
    tabWidth: Layout.tabW,
    tabHeight: Layout.tabH,
    tabCorner: Layout.tabCorner,
    bodyCorner: Layout.bodyCorner
)

// MARK: - Card

struct CollectionPocketCardV2: View {
    @State private var expandedIndex: Int?
    @State private var peekedIndex: Int?
    @State private var favorites: Set<String> = []
    @State private var showOverlays = false
    @Namespace private var hero

    private let collections = Array(PocketCollection.defaults.prefix(4))
    private let pileLayouts = Array(PocketPileSlot.layouts.prefix(4))
    private var isExpanded: Bool { expandedIndex != nil }

    private var bgColor: Color {
        if let idx = expandedIndex { return collections[idx].color }
        return Color(hex: 0x1A1A1A)
    }

    var body: some View {
        ZStack {
            GradientCardFill(color: bgColor)

            if let idx = expandedIndex {
                expandedGrid(for: idx)
            } else {
                collapsedFolderGrid
            }

            title
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .animation(Layout.expandSpring, value: expandedIndex)
    }
}

// MARK: - Title

private extension CollectionPocketCardV2 {
    var title: some View {
        Text("Men")
            .font(.system(size: 40, weight: .bold))
            .tracking(-1.5)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 22)
            .offset(y: isExpanded ? -60 : 0)
            .opacity(isExpanded ? 0 : 1)
            .animation(Layout.expandSpring, value: expandedIndex)
    }
}

// MARK: - Folder Grid (Collapsed)

private extension CollectionPocketCardV2 {
    var collapsedFolderGrid: some View {
        let columns = Array(repeating: GridItem(.fixed(Layout.folderW), spacing: Layout.folderSpacing), count: 2)

        return TimelineView(.animation(minimumInterval: 1.0 / 30)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            LazyVGrid(columns: columns, spacing: Layout.folderSpacing) {
                ForEach(collections.indices, id: \.self) { ci in
                    folderCell(index: ci, time: time)
                }
            }
            .padding(.top, Layout.folderGridTop)
        }
        .animation(Layout.peekSpring, value: peekedIndex)
    }

    func folderCell(index ci: Int, time: Double) -> some View {
        let isPeeked = peekedIndex == ci

        return ZStack {
            productPile(collectionIndex: ci, isPeeked: isPeeked, time: time)
            folderView(collectionIndex: ci, isPeeked: isPeeked)
        }
        .onTapGesture { expand(ci) }
        .onLongPressGesture(minimumDuration: 0.3, pressing: { pressing in
            if pressing {
                Haptics.soft(intensity: 0.5)
                withAnimation(Layout.peekSpring) { peekedIndex = ci }
            } else {
                withAnimation(Layout.peekSpring) { peekedIndex = nil }
            }
        }, perform: {})
    }

    func folderView(collectionIndex ci: Int, isPeeked: Bool) -> some View {
        let color = collections[ci].color
        let folder = folders[ci]

        return ZStack {
            folderClip
                .fill(color.opacity(0.22))
                .background(folderClip.fill(.ultraThinMaterial.opacity(0.85)))
                .overlay(folderClip.stroke(Color.white.opacity(0.5), lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                Text(folder.category)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(-0.3)
                Text(folder.brand)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white.opacity(0.6))
                    .tracking(-0.2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .frame(width: Layout.folderW, height: Layout.folderH)
        .clipShape(folderClip)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .offset(y: isPeeked ? 14 : 0)
        .matchedGeometryEffect(id: "folder-\(ci)", in: hero)
    }

    func productPile(collectionIndex ci: Int, isPeeked: Bool, time: Double) -> some View {
        let products = collections[ci].products
        let slots = pileLayouts[ci]

        return ZStack {
            ForEach(products.indices, id: \.self) { pi in
                pileProduct(
                    image: products[pi].image,
                    slot: slots[pi],
                    matchID: "product-\(ci)-\(pi)",
                    index: pi, isPeeked: isPeeked, time: time
                )
            }
        }
    }

    func pileProduct(image: String, slot: PocketPileSlot, matchID: String,
                     index pi: Int, isPeeked: Bool, time: Double) -> some View {
        let phase = Double(pi) * 1.4
        let peekBoost: CGFloat = isPeeked ? -20 - CGFloat(pi) * 4 : 0
        let baseY: CGFloat = -30 + CGFloat(pi) * -2 + peekBoost

        let px = slot.x * (isPeeked ? 0.3 : 0.1)
        let py = baseY * 0.6
        let pr = slot.rotation * 0.5
        let fx = cos(time * 0.8 + phase * 1.6) * 1.5
        let fy = sin(time * 1.1 + phase) * 2.5
        let fr = sin(time * 0.6 + phase * 0.9) * 1.0

        return Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: Layout.pileSize, height: Layout.pileSize)
            .clipShape(RoundedRectangle(cornerRadius: Layout.pileCorner, style: .continuous))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            .matchedGeometryEffect(id: matchID, in: hero)
            .rotationEffect(.degrees(pr + fr))
            .offset(x: px + CGFloat(fx), y: py + CGFloat(fy))
            .zIndex(Double(pi))
    }
}

// MARK: - Expanded Grid

private extension CollectionPocketCardV2 {
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

            closeButton(for: ci)
                .padding(.bottom, 32)
        }
    }

    func gridTile(collectionIndex ci: Int, productIndex pi: Int) -> some View {
        let product = collections[ci].products[pi]
        let favKey = "\(ci)-\(pi)"
        let isFav = favorites.contains(favKey)

        return ProductTile(image: product.image, size: Layout.gridSize)
            .matchedGeometryEffect(id: "product-\(ci)-\(pi)", in: hero)
            .overlay(alignment: .topLeading) {
                PriceTag(text: product.price).padding(8).opacity(showOverlays ? 1 : 0)
            }
            .overlay(alignment: .bottomTrailing) {
                FavoriteButton(isFavorite: isFav) {
                    Haptics.light()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        if isFav { favorites.remove(favKey) } else { favorites.insert(favKey) }
                    }
                }
                .padding(8).opacity(showOverlays ? 1 : 0)
            }
    }

    func closeButton(for ci: Int) -> some View {
        Button {
            Haptics.light()
            withAnimation(.easeOut(duration: 0.12)) { showOverlays = false }
            withAnimation(Layout.expandSpring) { expandedIndex = nil }
        } label: {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial.opacity(0.85))
                    .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 1))
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
            }
            .frame(width: Layout.closeSize, height: Layout.closeSize)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            .matchedGeometryEffect(id: "folder-\(ci)", in: hero)
        }
    }
}

// MARK: - Actions

private extension CollectionPocketCardV2 {
    func expand(_ index: Int) {
        Haptics.light()
        withAnimation(Layout.expandSpring) { expandedIndex = index }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.35)) { showOverlays = true }
        }
    }
}
