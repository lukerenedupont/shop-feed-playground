//
//  OrderCard.swift
//  Shop feed playground
//
//  Active order card with merchant, progress bars, and product pile.
//

import SwiftUI

// MARK: - Order Card

struct OrderCard: View {
    let merchant: String
    let stages: [OrderStage]
    let productColors: [Color]
    var actionLabel: String? = nil

    var body: some View {
        HStack(alignment: .top, spacing: Tokens.space24) {
            VStack(alignment: .leading, spacing: Tokens.space12) {
                // Merchant row
                MerchantRow(name: merchant)

                // Status stages
                ForEach(0..<stages.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: Tokens.space8) {
                        HStack(spacing: Tokens.space8) {
                            Text(stages[i].label)
                                .font(.system(size: Tokens.bodySize, weight: .semibold))
                                .tracking(Tokens.bodyTracking)
                                .foregroundColor(Tokens.textPrimary)

                            if stages[i].hasPromise {
                                Image("ShopPromise")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 10)
                            }
                        }

                        ProgressBar(progress: stages[i].progress)
                    }
                }

                // Action button
                if let actionLabel {
                    Text(actionLabel)
                        .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                        .tracking(Tokens.cozyTracking)
                        .foregroundColor(Tokens.textPrimary)
                        .padding(.horizontal, Tokens.space16)
                        .padding(.vertical, Tokens.space10)
                        .background(Capsule().fill(Tokens.fillSecondary))
                        .padding(.top, Tokens.space4)
                }
            }

            ProductPile(colors: productColors)
        }
        .padding(Tokens.space16)
        .cardStyle()
    }
}

// MARK: - Review Order Card

struct ReviewOrderCard: View {
    let merchant: String
    let productColors: [Color]

    var body: some View {
        HStack(alignment: .top, spacing: Tokens.space24) {
            VStack(alignment: .leading, spacing: Tokens.space12) {
                MerchantRow(name: merchant)

                Text("Review your order")
                    .font(.system(size: Tokens.bodySize, weight: .semibold))
                    .tracking(Tokens.bodyTracking)
                    .foregroundColor(Tokens.textPrimary)

                HStack(spacing: Tokens.space8) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image("StarIcon")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(hex: 0xD4C44A))
                    }
                }
            }

            Spacer()
            ProductPile(colors: productColors)
        }
        .padding(Tokens.space16)
        .cardStyle()
    }
}

// MARK: - Shared Components

struct MerchantRow: View {
    let name: String

    var body: some View {
        HStack(spacing: Tokens.space8) {
            Circle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: 24, height: 24)
                .overlay(
                    Text(String(name.prefix(1)))
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.gray)
                )

            Text(name)
                .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                .tracking(Tokens.cozyTracking)
                .foregroundColor(Tokens.textSecondary)
                .lineLimit(1)
        }
    }
}

struct ProgressBar: View {
    let progress: Double
    @State private var animatedProgress: Double = 0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Tokens.fillSecondary).frame(height: 4)
                Circle().fill(Tokens.fillSecondary).frame(width: 8, height: 8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Capsule().fill(Tokens.progressPurple)
                    .frame(width: max(geo.size.width * animatedProgress, 8), height: 4)
                Circle().fill(Tokens.progressPurple).frame(width: 8, height: 8)
                    .offset(x: max(geo.size.width * animatedProgress - 8, 0))
            }
        }
        .frame(height: 8)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3)) {
                animatedProgress = progress
            }
        }
    }
}

struct ProductPile: View {
    let colors: [Color]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if colors.count > 2 {
                productImage(colors[2]).rotationEffect(.degrees(-8)).offset(x: -4, y: 2)
            }
            if colors.count > 1 {
                productImage(colors[1]).rotationEffect(.degrees(-4)).offset(x: -2, y: 1)
            }
            productImage(colors[0])
        }
        .frame(width: 72, height: 72)
    }

    private func productImage(_ color: Color) -> some View {
        RoundedRectangle(cornerRadius: 9, style: .continuous)
            .fill(color)
            .frame(width: 67.5, height: 67.5)
            .overlay(
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .stroke(Tokens.imageBorder, lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.1), radius: 2.25, x: 0, y: 1.125)
    }
}
