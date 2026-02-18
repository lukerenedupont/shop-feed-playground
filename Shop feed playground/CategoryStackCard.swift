//
//  CategoryStackCard.swift
//  Shop feed playground
//
//  3D-tilted category stack card. Tap a category to expand it
//  and reveal a horizontal product rail. Tap again to collapse.
//

import SwiftUI

// MARK: - Category Stack Card

struct CategoryStackCard: View {
    @State private var expandedIndex: Int? = nil
    @Namespace private var hero

    private let categories: [StackCategory] = StackCategory.defaults

    private var isExpanded: Bool { expandedIndex != nil }

    var body: some View {
        ZStack {
            // Dark background
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x111111))
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )

            if let idx = expandedIndex, idx < categories.count {
                // Expanded state
                expandedView(for: categories[idx], index: idx)
                    .transition(.opacity)
            } else {
                // Collapsed stack
                collapsedStack
                    .transition(.opacity)
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .animation(Tokens.springExpand, value: expandedIndex)
    }

    // MARK: - Collapsed Stack (horizontal scroll)

    private var collapsedStack: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -90) {
                Spacer().frame(width: 60)

                ForEach(categories.indices, id: \.self) { index in
                    let category = categories[index]

                    categoryTile(category: category, index: index)
                        .onTapGesture {
                            Haptics.light()
                            withAnimation(Tokens.springExpand) {
                                expandedIndex = index
                            }
                        }
                }

                Spacer().frame(width: 60)
            }
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - Category Tile (collapsed)

    private func categoryTile(category: StackCategory, index: Int) -> some View {
        let tileWidth: CGFloat = 180
        let tileHeight: CGFloat = 320
        // Fan angle: center cards face forward, edges rotate away
        let centerIndex = CGFloat(categories.count - 1) / 2
        let offset = CGFloat(index) - centerIndex
        let yRotation: Double = Double(offset) * 22

        return ZStack {
            // Background color tile
            RoundedRectangle(cornerRadius: Tokens.radius16, style: .continuous)
                .fill(category.color)

            // Category name rotated vertically on the spine
            VStack(spacing: 4) {
                Text(category.name)
                    .shopTextStyle(.bodySmallBold)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(-90))
                    .fixedSize()

                Text("\(category.products.count)")
                    .shopTextStyle(.badge)
                    .foregroundColor(.white.opacity(0.6))
                    .rotationEffect(.degrees(-90))
                    .fixedSize()
            }
        }
        .frame(width: tileWidth, height: tileHeight)
        .rotation3DEffect(
            .degrees(yRotation),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.5
        )
    }

    // MARK: - Expanded View

    private func expandedView(for category: StackCategory, index: Int) -> some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(category.name)
                        .font(.system(size: 28, weight: .bold))
                        .tracking(-1)
                        .foregroundColor(.white)

                    Text("\(category.products.count) products")
                        .shopTextStyle(.bodySmall)
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                // Close button
                Button {
                    Haptics.light()
                    withAnimation(Tokens.springExpand) {
                        expandedIndex = nil
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(.white.opacity(0.12)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 16)

            // Color accent bar
            RoundedRectangle(cornerRadius: Tokens.ShopClient.radius6, style: .continuous)
                .fill(category.color)
                .frame(height: 4)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

            // Horizontal product scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    Spacer().frame(width: 6)

                    ForEach(category.products) { product in
                        StackProductTile(product: product, accentColor: category.color)
                    }

                    Spacer().frame(width: 6)
                }
            }

            Spacer()

            // Shop category button
            ShopClientButton(
                title: "Shop \(category.name)",
                variant: .secondary,
                size: .l,
                action: { Haptics.light() }
            )
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Product Tile

private struct StackProductTile: View {
    let product: StackProduct
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product image placeholder
            RoundedRectangle(cornerRadius: Tokens.radius16, style: .continuous)
                .fill(product.tileColor)
                .frame(width: 140, height: 180)
                .overlay(alignment: .topLeading) {
                    Text(product.price)
                        .shopTextStyle(.captionBold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(.black.opacity(0.3)))
                        .padding(10)
                }
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .fill(.black.opacity(0.3))
                        .frame(width: 28, height: 28)
                        .overlay {
                            Image("HeartOutlineIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                        }
                        .padding(10)
                }

            // Product info
            Text(product.name)
                .shopTextStyle(.caption)
                .foregroundColor(.white)
                .lineLimit(1)

            Text(product.brand)
                .shopTextStyle(.badge)
                .foregroundColor(.white.opacity(0.5))
                .lineLimit(1)
        }
        .frame(width: 140)
    }
}

// MARK: - Data

private struct StackCategory: Identifiable {
    let id: Int
    let name: String
    let color: Color
    let products: [StackProduct]

    static let defaults: [StackCategory] = [
        .init(id: 0, name: "Sneakers", color: Color(hex: 0x4A6741), products: [
            .init(id: 0, name: "Air Force 1", brand: "Nike", price: "$110", tileColor: Color(hex: 0x3A5230)),
            .init(id: 1, name: "Forum Low", brand: "Adidas", price: "$100", tileColor: Color(hex: 0x4A6741)),
            .init(id: 2, name: "Samba OG", brand: "Adidas", price: "$120", tileColor: Color(hex: 0x5A7751)),
            .init(id: 3, name: "550", brand: "New Balance", price: "$130", tileColor: Color(hex: 0x3A5230)),
        ]),
        .init(id: 1, name: "Outerwear", color: Color(hex: 0x2A2A2A), products: [
            .init(id: 0, name: "Puffer Jacket", brand: "The North Face", price: "$320", tileColor: Color(hex: 0x1A1A1A)),
            .init(id: 1, name: "Barn Coat", brand: "Carhartt WIP", price: "$250", tileColor: Color(hex: 0x2A2A2A)),
            .init(id: 2, name: "Track Jacket", brand: "Stüssy", price: "$180", tileColor: Color(hex: 0x333333)),
            .init(id: 3, name: "Fleece Half-Zip", brand: "Patagonia", price: "$140", tileColor: Color(hex: 0x1A1A1A)),
        ]),
        .init(id: 2, name: "Accessories", color: Color(hex: 0xD4614C), products: [
            .init(id: 0, name: "Beanie", brand: "Carhartt", price: "$28", tileColor: Color(hex: 0xC45540)),
            .init(id: 1, name: "Camp Cap", brand: "Supreme", price: "$54", tileColor: Color(hex: 0xD4614C)),
            .init(id: 2, name: "Crossbody Bag", brand: "Arc'teryx", price: "$89", tileColor: Color(hex: 0xB84838)),
            .init(id: 3, name: "Sunglasses", brand: "Moscot", price: "$310", tileColor: Color(hex: 0xC45540)),
        ]),
        .init(id: 3, name: "Home", color: Color(hex: 0xC4A86C), products: [
            .init(id: 0, name: "Throw Blanket", brand: "Tekla", price: "$180", tileColor: Color(hex: 0xB49858)),
            .init(id: 1, name: "Candle", brand: "Le Labo", price: "$82", tileColor: Color(hex: 0xC4A86C)),
            .init(id: 2, name: "Coffee Mug", brand: "Kinto", price: "$24", tileColor: Color(hex: 0xA48848)),
            .init(id: 3, name: "Incense Holder", brand: "Puebco", price: "$38", tileColor: Color(hex: 0xB49858)),
        ]),
        .init(id: 4, name: "Tops", color: Color(hex: 0xE8A0C0), products: [
            .init(id: 0, name: "Boxy Tee", brand: "Kith", price: "$65", tileColor: Color(hex: 0xD890B0)),
            .init(id: 1, name: "Rugby Polo", brand: "Noah", price: "$128", tileColor: Color(hex: 0xE8A0C0)),
            .init(id: 2, name: "Oxford Shirt", brand: "Drake's", price: "$195", tileColor: Color(hex: 0xC880A0)),
            .init(id: 3, name: "Hoodie", brand: "Reigning Champ", price: "$155", tileColor: Color(hex: 0xD890B0)),
        ]),
        .init(id: 5, name: "Bottoms", color: Color(hex: 0x4A6090), products: [
            .init(id: 0, name: "Cargo Pants", brand: "Gramicci", price: "$120", tileColor: Color(hex: 0x3A5080)),
            .init(id: 1, name: "501 Jeans", brand: "Levi's", price: "$98", tileColor: Color(hex: 0x4A6090)),
            .init(id: 2, name: "Sweatpants", brand: "Nike", price: "$75", tileColor: Color(hex: 0x3A5080)),
            .init(id: 3, name: "Pleated Trousers", brand: "COS", price: "$135", tileColor: Color(hex: 0x4A6090)),
        ]),
    ]
}

private struct StackProduct: Identifiable {
    let id: Int
    let name: String
    let brand: String
    let price: String
    let tileColor: Color
}
