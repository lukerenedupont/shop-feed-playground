//
//  FilterChips.swift
//  Shop feed playground
//
//  Reusable chip components for filter rows.
//

import SwiftUI

// MARK: - Filter Chips Row (Home Feed)

struct FilterChipsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Tokens.space4) {
                AvatarChip()
                IconOnlyChip(assetName: "BellIcon")
                GlassTextChip(assetName: "TagIcon", label: "Deals")
                GlassTextChip(assetName: "VerifyIcon", label: "Following")
                GlassTextChip(assetName: "HeartIcon", label: "Saved")
            }
            .padding(.horizontal, Tokens.space16)
            .padding(.top, Tokens.space4)
            .padding(.bottom, Tokens.space16)
        }
        .scrollClipDisabled()
    }
}

// MARK: - Avatar Chip

struct AvatarChip: View {
    var body: some View {
        Image("Avatar")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: Tokens.chipSize, height: Tokens.chipSize)
            .clipShape(Circle())
            .shadow(
                color: Tokens.ShopClient.shadowSColor,
                radius: Tokens.ShopClient.shadowSRadius,
                x: 0,
                y: Tokens.ShopClient.shadowSY
            )
    }
}

// MARK: - Icon-Only Chip

struct IconOnlyChip: View {
    let assetName: String

    var body: some View {
        Image(assetName)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: Tokens.iconSmall, height: Tokens.iconSmall)
            .foregroundColor(Tokens.textPrimary)
            .frame(width: Tokens.chipSize, height: Tokens.chipSize)
            .background(glassChipBackground(shape: Circle()))
    }
}

// MARK: - Glass Text Chip

struct GlassTextChip: View {
    let assetName: String
    let label: String

    var body: some View {
        ShopClientChip(
            label: label,
            iconAssetName: assetName,
            selected: false,
            circular: false,
            variant: .shadow
        )
    }
}

// MARK: - Category Chip (Search Page)

struct CategoryChip: View {
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: Tokens.space8) {
            Circle()
                .fill(color)
                .frame(width: 28, height: 28)

            Text(label)
                .shopTextStyle(.buttonMedium)
                .foregroundColor(Tokens.textPrimary)
        }
        .padding(.leading, Tokens.space4)
        .padding(.trailing, Tokens.space12)
        .frame(height: Tokens.chipSize)
        .background(glassChipBackground(shape: Capsule()))
    }
}

// MARK: - Shared Glass Background

private func glassChipBackground<S: Shape>(shape: S) -> some View {
    shape
        .fill(Tokens.ShopClient.bgFill)
        .overlay(
            shape
                .stroke(Tokens.ShopClient.borderSecondary, lineWidth: 0.5)
        )
        .shadow(
            color: Tokens.ShopClient.shadowSColor,
            radius: Tokens.ShopClient.shadowSRadius,
            x: 0,
            y: Tokens.ShopClient.shadowSY
        )
}
