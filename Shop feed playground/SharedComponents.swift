//
//  SharedComponents.swift
//  Shop feed playground
//
//  Reusable UI components shared across multiple feed cards.
//

import SwiftUI

// MARK: - Product Tile

/// A square product image with rounded corners and shadow.
/// Used in grids, carousels, and anywhere a product image is displayed.
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
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
    }
}

// MARK: - Price Tag

/// Floating price label with a translucent dark capsule background.
struct PriceTag: View {
    let text: String
    var bgOpacity: Double = 0.15

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
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
