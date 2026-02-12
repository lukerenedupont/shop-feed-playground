//
//  OrdersPageContent.swift
//  Shop feed playground
//
//  Orders tab — page layout only. Components are in:
//    OrderCard.swift, BuyAgainAndPastOrders.swift, OrderModels.swift
//

import SwiftUI

// MARK: - Orders Page

struct OrdersPageContent: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Color.clear.frame(height: Tokens.searchBarTopOffset)

                // Header
                HStack {
                    Text("Orders")
                        .font(.system(size: 28, weight: .semibold))
                        .tracking(-0.8)
                        .foregroundColor(Tokens.textPrimary)
                    Spacer()
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Tokens.textPrimary)
                }
                .padding(.horizontal, Tokens.space16)
                .padding(.top, Tokens.space8)
                .padding(.bottom, Tokens.space16)

                // Active order cards
                VStack(spacing: Tokens.space12) {
                    OrderCard(
                        merchant: "Carmen Amsterdam",
                        stages: [
                            .init(label: "Out for delivery", progress: 0.75),
                            .init(label: "Expected May 14", progress: 0.5, hasPromise: true),
                            .init(label: "Waiting for details", progress: 0.1),
                        ],
                        productColors: [Color(hex: 0xD4956A), Color(hex: 0xC4A882), Color(hex: 0xA08060)]
                    )

                    OrderCard(
                        merchant: "mfpen",
                        stages: [.init(label: "Delivery tomorrow, Jan 24", progress: 0.85)],
                        productColors: [Color(hex: 0x2A2A2A)]
                    )

                    OrderCard(
                        merchant: "Mohawk General Store",
                        stages: [
                            .init(label: "Out for delivery", progress: 0.75),
                            .init(label: "Shipped", progress: 0.5),
                        ],
                        productColors: [Color(hex: 0x8BAA9C), Color(hex: 0xC4B090)]
                    )

                    OrderCard(
                        merchant: "Ebay",
                        stages: [.init(label: "In transit", progress: 0.4)],
                        productColors: [Color(hex: 0xC4B090), Color(hex: 0xE8DED0)]
                    )

                    OrderCard(
                        merchant: "April Coffee Roaster",
                        stages: [.init(label: "In transit", progress: 0.35)],
                        productColors: [Color(hex: 0xA67B5C)],
                        actionLabel: "Mark order as delivered"
                    )

                    OrderCard(
                        merchant: "DHL",
                        stages: [.init(label: "In transit", progress: 0.3)],
                        productColors: [Color(hex: 0xD4C44A)]
                    )

                    OrderCard(
                        merchant: "My custom tracker name",
                        stages: [.init(label: "In transit", progress: 0.25)],
                        productColors: [Color(hex: 0xD48B5A)]
                    )

                    ReviewOrderCard(
                        merchant: "Studio Nicholson",
                        productColors: [Color(hex: 0xE8DED0)]
                    )
                }
                .padding(.horizontal, Tokens.space16)

                BuyAgainAndPastOrders()

                Color.clear.frame(height: 120)
            }
        }
    }
}
