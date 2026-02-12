//
//  OrdersPageContent.swift
//  Shop feed playground
//

import SwiftUI

// MARK: - Orders Page

struct OrdersPageContent: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                // Spacer for search bar
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
                        stages: [
                            .init(label: "Delivery tomorrow, Jan 24", progress: 0.85),
                        ],
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
                        stages: [
                            .init(label: "In transit", progress: 0.4),
                        ],
                        productColors: [Color(hex: 0xC4B090), Color(hex: 0xE8DED0)]
                    )

                    OrderCard(
                        merchant: "April Coffee Roaster",
                        stages: [
                            .init(label: "In transit", progress: 0.35),
                        ],
                        productColors: [Color(hex: 0xA67B5C)],
                        actionLabel: "Mark order as delivered"
                    )

                    OrderCard(
                        merchant: "DHL",
                        stages: [
                            .init(label: "In transit", progress: 0.3),
                        ],
                        productColors: [Color(hex: 0xD4C44A)]
                    )

                    OrderCard(
                        merchant: "My custom tracker name",
                        stages: [
                            .init(label: "In transit", progress: 0.25),
                        ],
                        productColors: [Color(hex: 0xD48B5A)]
                    )

                    ReviewOrderCard(
                        merchant: "Studio Nicholson",
                        productColors: [Color(hex: 0xE8DED0)]
                    )
                }
                .padding(.horizontal, Tokens.space16)

                // Buy again
                BuyAgainSection()

                // Past orders
                PastOrdersSection()

                // Bottom padding
                Color.clear.frame(height: 120)
            }
        }
    }
}

// MARK: - Order Stage

struct OrderStage {
    let label: String
    let progress: Double
    var hasPromise: Bool = false
}

// MARK: - Progress Bar

private struct ProgressBar: View {
    let progress: Double
    @State private var animatedProgress: Double = 0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .fill(Tokens.fillSecondary)
                    .frame(height: 4)

                // Background end dot
                Circle()
                    .fill(Tokens.fillSecondary)
                    .frame(width: 8, height: 8)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                // Progress track
                Capsule()
                    .fill(Color(hex: 0x5433EB))
                    .frame(width: max(geo.size.width * animatedProgress, 8), height: 4)

                // Progress end dot
                Circle()
                    .fill(Color(hex: 0x5433EB))
                    .frame(width: 8, height: 8)
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

// MARK: - Product Pile

private struct ProductPile: View {
    let colors: [Color]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Back card (rotated -8°)
            if colors.count > 2 {
                productImage(colors[2])
                    .rotationEffect(.degrees(-8))
                    .offset(x: -4, y: 2)
            }

            // Middle card (rotated -4°)
            if colors.count > 1 {
                productImage(colors[1])
                    .rotationEffect(.degrees(-4))
                    .offset(x: -2, y: 1)
            }

            // Front card (no rotation)
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

// MARK: - Order Card

private struct OrderCard: View {
    let merchant: String
    let stages: [OrderStage]
    let productColors: [Color]
    var actionLabel: String? = nil

    var body: some View {
        HStack(alignment: .top, spacing: Tokens.space24) {
            // Left content
            VStack(alignment: .leading, spacing: Tokens.space12) {
                // Merchant row
                HStack(spacing: Tokens.space8) {
                    Circle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text(String(merchant.prefix(1)))
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.gray)
                        )

                    Text(merchant)
                        .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                        .tracking(Tokens.cozyTracking)
                        .foregroundColor(Tokens.textSecondary)
                        .lineLimit(1)
                }

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
                        .background(
                            Capsule().fill(Tokens.fillSecondary)
                        )
                        .padding(.top, Tokens.space4)
                }
            }

            // Product pile
            ProductPile(colors: productColors)
        }
        .padding(Tokens.space16)
        .background(
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Tokens.imageBorder, lineWidth: 0.5)
                )
                .shadow(
                    color: Tokens.shadowColor,
                    radius: Tokens.shadowRadius,
                    x: 0,
                    y: Tokens.shadowY
                )
        )
    }
}

// MARK: - Review Order Card

private struct ReviewOrderCard: View {
    let merchant: String
    let productColors: [Color]

    var body: some View {
        HStack(alignment: .top, spacing: Tokens.space24) {
            VStack(alignment: .leading, spacing: Tokens.space12) {
                // Merchant row
                HStack(spacing: Tokens.space8) {
                    Circle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text(String(merchant.prefix(1)))
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.gray)
                        )

                    Text(merchant)
                        .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                        .tracking(Tokens.cozyTracking)
                        .foregroundColor(Tokens.textSecondary)
                }

                Text("Review your order")
                    .font(.system(size: Tokens.bodySize, weight: .semibold))
                    .tracking(Tokens.bodyTracking)
                    .foregroundColor(Tokens.textPrimary)

                // Star rating
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
        .background(
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Tokens.imageBorder, lineWidth: 0.5)
                )
                .shadow(
                    color: Tokens.shadowColor,
                    radius: Tokens.shadowRadius,
                    x: 0,
                    y: Tokens.shadowY
                )
        )
    }
}

// MARK: - Buy Again Section

private struct BuyAgainSection: View {
    private let products: [[Color]] = [
        [Color(hex: 0xE8DED0), Color(hex: 0x2A2A2A), Color(hex: 0xD4C4A8)],
        [Color(hex: 0xF0EDE8), Color(hex: 0xF0EDE8), Color(hex: 0xF0EDE8)],
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space12) {
            SectionHeader(title: "Buy again")

            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: Tokens.space8) {
                    ForEach(0..<products.count, id: \.self) { row in
                        HStack(spacing: Tokens.space8) {
                            ForEach(0..<products[row].count, id: \.self) { col in
                                buyAgainCard(color: products[row][col])
                            }
                        }
                    }
                }
                .padding(.horizontal, Tokens.space16)
            }
        }
        .padding(.top, Tokens.space24)
        .padding(.bottom, Tokens.space8)
    }

    private func buyAgainCard(color: Color) -> some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                .fill(color)
                .frame(width: 120, height: 120)

            // Buy again icon
            Image("BuyAgainIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(Tokens.space8)
        }
    }
}

// MARK: - Past Orders Section

private struct PastOrdersSection: View {
    private struct PastOrder: Identifiable {
        let id: Int
        let deliveredText: String
        let merchant: String
        let itemCount: String?
        let total: String?
        let thumbnailStyle: PastOrderThumbnail.Style
    }

    private let orders: [PastOrder] = [
        .init(
            id: 0,
            deliveredText: "Delivered Mar 14",
            merchant: "Lady White Co.",
            itemCount: "1 item",
            total: "$54.23",
            thumbnailStyle: .ladyWhite
        ),
        .init(
            id: 1,
            deliveredText: "Delivered Mar 2",
            merchant: "Ebay",
            itemCount: "1 item",
            total: "$12.99",
            thumbnailStyle: .ebay
        ),
        .init(
            id: 2,
            deliveredText: "Delivered Mar 2",
            merchant: "DHL",
            itemCount: nil,
            total: nil,
            thumbnailStyle: .dhl
        ),
        .init(
            id: 3,
            deliveredText: "Delivered Feb 8",
            merchant: "Prolog Coffee",
            itemCount: "2 items",
            total: "$103.98",
            thumbnailStyle: .prologStacked
        ),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space16) {
            SectionHeader(title: "Past orders")

            VStack(spacing: Tokens.space16) {
                ForEach(orders) { order in
                    HStack(spacing: Tokens.space16) {
                        PastOrderThumbnail(style: order.thumbnailStyle)

                        VStack(alignment: .leading, spacing: Tokens.space4) {
                            Text(order.deliveredText)
                                .font(.system(size: Tokens.bodySize, weight: .semibold))
                                .tracking(Tokens.bodyTracking)
                                .lineSpacing(Tokens.lineHeightSection - Tokens.bodySize)
                                .foregroundColor(Tokens.textPrimary)
                                .lineLimit(1)

                            HStack(spacing: 0) {
                                captionText(order.merchant)
                                if let itemCount = order.itemCount, let total = order.total {
                                    captionText(" \u{30fb} \(itemCount) \u{30fb} \(total)")
                                }
                            }
                            .lineLimit(1)
                        }

                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, Tokens.space16)
            .padding(.bottom, Tokens.space20)
        }
        .padding(.top, Tokens.space20)
    }

    private func captionText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: Tokens.captionSize, weight: .regular))
            .tracking(Tokens.cozyTracking)
            .lineSpacing(Tokens.lineHeightCaption - Tokens.captionSize)
            .foregroundColor(Tokens.textSecondary)
    }
}

private struct PastOrderThumbnail: View {
    enum Style {
        case ladyWhite
        case ebay
        case dhl
        case prologStacked
    }

    let style: Style

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if style == .prologStacked {
                singleTile(size: 45) {
                    LinearGradient(
                        colors: [Color(hex: 0xD09667), Color(hex: 0x7C4D2E)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 3, style: .continuous)
                            .fill(Color(hex: 0xF2EBDD))
                            .frame(width: 16, height: 22)
                    }
                }
                .rotationEffect(.degrees(-6))
                .offset(x: -2.5, y: 1.5)

                singleTile(size: 45) {
                    LinearGradient(
                        colors: [Color(hex: 0x8FBADE), Color(hex: 0x5A88AA)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay(alignment: .top) {
                        RoundedRectangle(cornerRadius: 2, style: .continuous)
                            .fill(Color.white.opacity(0.75))
                            .frame(width: 12, height: 14)
                            .padding(.top, 6)
                    }
                }
            } else if style == .ladyWhite {
                singleTile(size: 48) {
                    LinearGradient(
                        colors: [Color(hex: 0xF2EEE8), Color(hex: 0xE4DED7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay {
                        HStack(spacing: 2) {
                            RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                                .fill(Color.white.opacity(0.35))
                            RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                                .fill(Color.white.opacity(0.2))
                        }
                        .frame(width: 28, height: 30)
                    }
                }
            } else if style == .ebay {
                singleTile(size: 48) {
                    LinearGradient(
                        colors: [Color(hex: 0x7A614D), Color(hex: 0x3E332E)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .overlay(alignment: .top) {
                        HStack(spacing: 3) {
                            Capsule()
                                .fill(Color(hex: 0xCC4A2A))
                                .frame(width: 13, height: 4)
                            Capsule()
                                .fill(Color(hex: 0xC33939))
                                .frame(width: 11, height: 4)
                        }
                        .padding(.top, 4)
                    }
                }
            } else {
                singleTile(size: 48) {
                    ZStack {
                        LinearGradient(
                            colors: [Color(hex: 0xF4F1EA), Color(hex: 0xE7E1D8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        Rectangle()
                            .fill(Color(hex: 0xEFA67A))
                            .frame(width: 24, height: 16)
                            .rotationEffect(.degrees(-17))
                            .offset(x: -6, y: 3)
                        Rectangle()
                            .fill(Color(hex: 0xD88E63))
                            .frame(width: 19, height: 15)
                            .rotationEffect(.degrees(18))
                            .offset(x: 8, y: -2)
                    }
                }
            }
        }
        .frame(width: 48, height: 48)
    }

    private func singleTile<Content: View>(size: CGFloat, @ViewBuilder content: () -> Content) -> some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(Tokens.fillSecondary)
            .frame(width: size, height: size)
            .overlay {
                content()
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(Tokens.imageBorder, lineWidth: 0.375)
            )
            .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 0.75)
    }
}
