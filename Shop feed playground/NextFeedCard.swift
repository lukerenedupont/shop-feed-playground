//
//  NextFeedCard.swift
//  Shop feed playground
//
//  Product grid card with color picker lockup.
//

import SwiftUI

struct NextFeedCard: View {
    @State private var selectedColorIndex: Int = 4
    @State private var isSelectorExpanded: Bool = false

    private let tileBackground = Color(hex: 0xD9D9DC)
    private let productCount: Int = 6
    private let defaultProductImages: [String] = [
        "PileBeanie",
        "PileYankeesCap",
        "PileSunglasses",
        "PileNike",
        "PileSlippers",
        "PilePerfume",
    ]
    private let burgundyProductImages: [String] = [
        "BurgundyProductVans",
        "BurgundyProductSocks",
        "BurgundyProductHoodie",
        "BurgundyProductShirt",
        "BurgundyProductMug",
        "BurgundyProductBeanie",
    ]

    private let colorChoices: [ColorChoice] = [
        .init(name: "Olive", swatch: Color(hex: 0x2A3B1E)),
        .init(name: "Khaki", swatch: Color(hex: 0xB3A88A)),
        .init(name: "Ash", swatch: Color(hex: 0xB8B2B4)),
        .init(name: "Merlot", swatch: Color(hex: 0x2E060B)),
        .init(name: "Burgundy", swatch: Color(hex: 0x63181C)),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            let selectedColor = colorChoices[selectedColorIndex]
            let activeProducts = productImages(for: selectedColor)
            let shouldTintProducts = !usesBurgundyProducts(selectedColor)

            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(selectedColor.swatch)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )
                .animation(.easeInOut(duration: 0.25), value: selectedColorIndex)

            // 2 x 3 product card grid
            LazyVGrid(columns: gridColumns, spacing: 8) {
                ForEach(0..<productCount, id: \.self) { index in
                    ProductGridTile(
                        productImage: activeProducts[index % activeProducts.count],
                        tintColor: selectedColor.swatch,
                        shouldTint: shouldTintProducts,
                        tileBackground: tileBackground
                    )
                }
            }
            .frame(width: 345)
            .padding(.top, 16)
            .frame(maxHeight: .infinity, alignment: .top)

            if isSelectorExpanded {
                expandedSelectorBackdrop(for: selectedColor.swatch)
                    .transition(.opacity)
            }

            // Bottom lockup
            VStack(spacing: 0) {
                Spacer(minLength: 0)

                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("Pick your color")
                            .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                            .tracking(Tokens.cozyTracking)
                            .foregroundColor(.white.opacity(0.56))
                        Spacer()
                    }
                    .padding(.leading, 4)
                    .frame(width: 345)
                    .padding(.top, 48)

                    HStack(spacing: 0) {
                        Text(selectedColor.name)
                            .font(.system(size: 24, weight: .semibold))
                            .tracking(-1.0)
                            .foregroundColor(.white)

                        Spacer()

                        ColorSwatchButton(color: selectedColor.swatch) {
                            withAnimation(Tokens.springSnappy) {
                                isSelectorExpanded.toggle()
                            }
                        }
                        .allowsHitTesting(!isSelectorExpanded)
                    }
                    .padding(.leading, 4)
                    .frame(width: 345, height: 36)
                    .padding(.top, 2)
                    .padding(.bottom, 16)
                }
                .blur(radius: isSelectorExpanded ? 2 : 0)
                .frame(width: Tokens.cardWidth, height: 116, alignment: .bottom)
                .background(
                    LinearGradient(
                        stops: [
                            .init(color: selectedColor.swatch.opacity(0), location: 0),
                            .init(color: selectedColor.swatch, location: 0.7),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .animation(.easeInOut(duration: 0.25), value: selectedColorIndex)
            }

            if isSelectorExpanded {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(Tokens.springSnappy) {
                            isSelectorExpanded = false
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                ColorSwatchSelector(
                    choices: colorChoices,
                    selectedIndex: selectedColorIndex,
                    onSelect: { index in
                        withAnimation(Tokens.springSnappy) {
                            selectedColorIndex = index
                            isSelectorExpanded = false
                        }
                    }
                )
                .padding(.trailing, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .transition(.scale(scale: 0.92, anchor: .bottomTrailing).combined(with: .opacity))
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }

    private var gridColumns: [GridItem] {
        [
            GridItem(.fixed(168.5), spacing: 8),
            GridItem(.fixed(168.5), spacing: 8),
        ]
    }

    private func expandedSelectorBackdrop(for color: Color) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: color.opacity(0), location: 0),
                        .init(color: color.opacity(0.9), location: 0.72),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Rectangle()
                    .fill(.ultraThinMaterial.opacity(0.25))
                    .mask(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: .black, location: 0.42),
                                .init(color: .black, location: 1),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .frame(height: 414)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .allowsHitTesting(false)
    }

    private func productImages(for color: ColorChoice) -> [String] {
        usesBurgundyProducts(color) ? burgundyProductImages : defaultProductImages
    }

    private func usesBurgundyProducts(_ color: ColorChoice) -> Bool {
        color.name == "Burgundy" || color.name == "Merlot"
    }
}

private struct ProductGridTile: View {
    let productImage: String
    let tintColor: Color
    let shouldTint: Bool
    let tileBackground: Color

    private var displayTint: Color {
        tintColor.interpolate(to: .white, fraction: 0.16)
    }

    var body: some View {
        RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
            .fill(tileBackground)
            .frame(width: 168.5, height: 168.5)
            .overlay {
                tileImage
            }
            .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
            .overlay(alignment: .topLeading) {
                Text("$50.00")
                    .font(.system(size: Tokens.captionSize, weight: .semibold))
                    .tracking(Tokens.cozyTracking)
                    .foregroundColor(.white)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(
                        Capsule(style: .continuous)
                            .fill(.black.opacity(0.30))
                    )
                    .padding(.top, 12)
                    .padding(.leading, 12)
            }
            .overlay(alignment: .bottomTrailing) {
                Circle()
                    .fill(.black.opacity(0.30))
                    .frame(width: 32, height: 32)
                    .overlay {
                        Image("HeartOutlineIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                    }
                    .padding(.bottom, 9)
                    .padding(.trailing, 11)
            }
    }

    @ViewBuilder
    private var tileImage: some View {
        let baseImage = Image(productImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()

        if shouldTint {
            baseImage
                // Color-match product visuals to selected swatch.
                .saturation(0)
                .colorMultiply(displayTint)
                .contrast(1.08)
                .brightness(0.02)
                .animation(.easeInOut(duration: 0.2), value: tintColor)
        } else {
            baseImage
        }
    }
}

private struct ColorSwatchButton: View {
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .stroke(Color.white, lineWidth: 3)
                .frame(width: 36, height: 36)
                .overlay(
                    Circle()
                        .fill(color)
                        .padding(6)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct ColorSwatchSelector: View {
    let choices: [ColorChoice]
    let selectedIndex: Int
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(spacing: 8) {
            ForEach(choices.indices, id: \.self) { index in
                let choice = choices[index]
                Button {
                    onSelect(index)
                } label: {
                    Circle()
                        .fill(choice.swatch)
                        .frame(width: 29, height: 29)
                        .overlay {
                            if index == selectedIndex {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: 0x8F6F74))
                                        .frame(width: 16, height: 16)
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(Color(hex: 0x3C2228))
                                }
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
        )
        .frame(width: 53, height: 201)
    }
}

private struct ColorChoice {
    let name: String
    let swatch: Color
}

