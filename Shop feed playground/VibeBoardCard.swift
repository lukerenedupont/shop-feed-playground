//
//  VibeBoardCard.swift
//  Shop feed playground
//
//  Full-bleed video card inspired by the Figma collection card.
//

import SwiftUI
import UIKit

struct VibeBoardCard: View {
    @State private var favoriteProductIDs: Set<String> = []
    @State private var productImages: [String: UIImage] = [:]

    private let heroVideoURL = URL(fileURLWithPath: "/Users/lukedupont/Downloads/make_the_scene_move_in_a_subtle_way_kplozzeyilgaw02e3of4_1.mp4")
    private let videoFillScale: CGFloat = 1.24
    private let carouselProducts: [VibeCarouselProduct] = [
        .init(id: "prod-1", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.36.27_AM-4677b6f3-683f-4acf-a566-5c3f878de759.png", price: "$96.00"),
        .init(id: "prod-2", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.36.38_AM-e55d7673-d0e7-4122-bf05-1e7182f5b932.png", price: "$124.00"),
        .init(id: "prod-3", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.36.50_AM-cc6657ba-d702-4839-a5a2-526d59ba3925.png", price: "$88.00"),
        .init(id: "prod-4", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.37.04_AM-832b0a69-459c-4029-a76d-125864026129.png", price: "$142.00"),
        .init(id: "prod-5", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.37.20_AM-5211992c-f6e3-493e-954e-e96e68b4c74b.png", price: "$108.00"),
        .init(id: "prod-6", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.37.29_AM-dd0915f8-dcde-4970-964c-5d765871633a.png", price: "$132.00"),
    ]

    private var hasLocalVideo: Bool {
        FileManager.default.fileExists(atPath: heroVideoURL.path)
    }

    var body: some View {
        ZStack {
            fullBleedBackground
            topLockup
            bottomLockup
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .shadow(
            color: Tokens.ShopClient.shadowLColor,
            radius: Tokens.ShopClient.shadowLRadius,
            x: 0,
            y: Tokens.ShopClient.shadowLY
        )
        .onAppear {
            loadProductImagesIfNeeded()
        }
    }
}

private extension VibeBoardCard {
    var fullBleedBackground: some View {
        Group {
            if hasLocalVideo {
                SharedLoopingVideoBackground(url: heroVideoURL)
                    .scaleEffect(videoFillScale)
            } else {
                fallbackBackground
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipped()
        .overlay {
            // Subtle contrast veil so white labels stay readable.
            Color.black.opacity(0.06)
        }
    }

    var fallbackBackground: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color(hex: 0xD9C4A5), Color(hex: 0xC2A684)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    var topLockup: some View {
        VStack {
            Text("Collection by Luke")
                .shopTextStyle(.subtitle)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 22)
                .padding(.leading, Tokens.space20)

            Spacer()
        }
    }

    var bottomLockup: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                productCarousel
            }
            .padding(.horizontal, Tokens.space20)
            .padding(.bottom, Tokens.space20)
        }
    }

    var productCarousel: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Tokens.space8) {
                ForEach(carouselProducts) { product in
                    productCard(product)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
    }

    func productCard(_ product: VibeCarouselProduct) -> some View {
        let isFavorite = favoriteProductIDs.contains(product.id)
        let image = productImages[product.id]

        return Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .fill(.white.opacity(0.2))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(.white.opacity(0.8))
                    }
            }
        }
        .frame(width: 134.4, height: 134.4)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                .stroke(.white.opacity(0.16), lineWidth: 0.5)
        )
        .overlay(alignment: .topLeading) {
            PriceTag(text: product.price)
                .padding(8)
        }
        .overlay(alignment: .bottomTrailing) {
            FavoriteButton(isFavorite: isFavorite) {
                Haptics.light()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    if isFavorite {
                        favoriteProductIDs.remove(product.id)
                    } else {
                        favoriteProductIDs.insert(product.id)
                    }
                }
            }
            .padding(8)
        }
        .shadow(
            color: Tokens.ShopClient.shadowMColor,
            radius: Tokens.ShopClient.shadowMRadius,
            x: 0,
            y: Tokens.ShopClient.shadowMY
        )
    }

    func loadProductImagesIfNeeded() {
        guard productImages.isEmpty else { return }
        var loaded: [String: UIImage] = [:]
        for product in carouselProducts {
            guard let image = UIImage(contentsOfFile: product.filePath) else { continue }
            loaded[product.id] = image
        }
        productImages = loaded
    }
}

private struct VibeCarouselProduct: Identifiable {
    let id: String
    let filePath: String
    let price: String
}

