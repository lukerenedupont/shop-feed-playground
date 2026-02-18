//
//  SharedComponents.swift
//  Shop feed playground
//
//  Reusable UI components shared across multiple feed cards.
//

import SwiftUI

// MARK: - Product Tile (Legacy)

/// A square product image with rounded corners and shadow.
/// Used by CollectionPocketCard, CollectionPocketCardV2, CategoryStackCard.
struct ProductTile: View {
    let image: String
    let size: CGFloat
    var cornerRadius: CGFloat = 16

    var body: some View {
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(
                color: Tokens.ShopClient.shadowSColor,
                radius: Tokens.ShopClient.shadowSRadius,
                x: 0,
                y: Tokens.ShopClient.shadowSY
            )
    }
}

// MARK: - Feed Product Card

/// Shared product card with dynamic corner radius, optional price badge and favorite button.
/// Used by CategoryExplorerCard, ShopTheLookFocusCard, and other feed cards.
struct FeedProductCard: View {
    let imageName: String
    let size: CGFloat
    var cornerRadius: CGFloat? = nil
    var priceBadgeText: String? = nil
    var showsFavorite: Bool = false
    var imageOverlayOpacity: Double = 0

    private enum Const {
        static let radiusScaleFactor: CGFloat = 0.22
        static let radiusMin: CGFloat = 8
        static let radiusMax: CGFloat = 32
        static let strokeOpacity: Double = 0.22
        static let strokeWidth: CGFloat = 0.5
        static let shadowOpacity: Double = 0.12
        static let shadowRadius: CGFloat = 8
        static let shadowY: CGFloat = 4
        static let favoriteSize: CGFloat = 28
        static let favoriteIconSize: CGFloat = 12
        static let favoriteBgOpacity: Double = 0.15
    }

    private var resolvedCornerRadius: CGFloat {
        if let cornerRadius { return cornerRadius }
        let scaled = CGFloat(round(Double(size * Const.radiusScaleFactor)))
        return min(Const.radiusMax, max(Const.radiusMin, scaled))
    }

    private var tileShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: resolvedCornerRadius, style: .continuous)
    }

    var body: some View {
        tileShape
            .fill(Tokens.ShopClient.bgFill)
            .frame(width: size, height: size)
            .overlay {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipped()
            }
            .overlay {
                tileShape.fill(.black.opacity(imageOverlayOpacity))
            }
            .clipShape(tileShape)
            .overlay(alignment: .topLeading) {
                if let priceBadgeText {
                    Text(priceBadgeText)
                        .shopTextStyle(.badgeBold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule(style: .continuous).fill(.black.opacity(0.30)))
                        .padding(8)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if showsFavorite {
                    Circle()
                        .fill(.black.opacity(Const.favoriteBgOpacity))
                        .frame(width: Const.favoriteSize, height: Const.favoriteSize)
                        .overlay {
                            Image("HeartOutlineIcon")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: Const.favoriteIconSize, height: Const.favoriteIconSize)
                                .foregroundColor(.white)
                        }
                        .padding(8)
                }
            }
            .overlay(
                tileShape.stroke(Color.white.opacity(Const.strokeOpacity), lineWidth: Const.strokeWidth)
            )
            .shadow(
                color: Tokens.ShopClient.shadowMColor.opacity(Const.shadowOpacity / 0.12),
                radius: Const.shadowRadius,
                x: 0,
                y: Const.shadowY
            )
    }
}

// MARK: - Price Tag

/// Floating price label with a translucent dark capsule background.
struct PriceTag: View {
    let text: String
    var bgOpacity: Double = 0.15

    var body: some View {
        Text(text)
            .shopTextStyle(.captionBold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(.black.opacity(bgOpacity)))
    }
}

// MARK: - Favorite Button

/// Heart toggle button with a translucent dark circle background.
struct FavoriteButton: View {
    let isFavorite: Bool
    var bgOpacity: Double = 0.15
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(isFavorite ? "HeartIcon" : "HeartOutlineIcon")
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(.black.opacity(bgOpacity)))
        }
    }
}

// MARK: - Gradient Card Background

/// Fills a rounded rectangle with a subtle diagonal gradient and light/dark overlays.
struct GradientCardFill: View {
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [color.opacity(0.85), color, color.opacity(0.9)],
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

// MARK: - Merchant Logo

/// Displays a merchant logo image, white-tinted and aspect-fitted.
struct MerchantLogo: View {
    let image: String
    var height: CGFloat = 38

    var body: some View {
        Image(image)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: height)
            .foregroundColor(.white)
    }
}
