//
//  BuyAgainAndPastOrders.swift
//  Shop feed playground
//
//  "Buy again" grid + "Past orders" list in a single white container.
//

import SwiftUI

// MARK: - Buy Again + Past Orders Container

struct BuyAgainAndPastOrders: View {
    private let products: [BuyAgainProduct] = [
        .init(id: 0, bgColors: [Color(hex: 0xD8D4CE), Color(hex: 0xC2BDB5)], accentStyle: .blackShoes),
        .init(id: 1, bgColors: [Color(hex: 0xEBE8E3), Color(hex: 0xDDD9D3)], accentStyle: .whiteTees),
        .init(id: 2, bgColors: [Color(hex: 0xC9A86C), Color(hex: 0x8B7444)], accentStyle: .coffeeProducts),
        .init(id: 3, bgColors: [Color(hex: 0xD0CCC6), Color(hex: 0xBAB5AE)], accentStyle: .blackShoesAlt),
        .init(id: 4, bgColors: [Color(hex: 0xD5D1CB), Color(hex: 0xC0BCB5)], accentStyle: .darkShoes),
        .init(id: 5, bgColors: [Color(hex: 0xE8E5E0), Color(hex: 0xDAD6D0)], accentStyle: .whiteTeesFolded),
    ]

    private let pastOrders: [PastOrder] = [
        .init(id: 0, deliveredText: "Delivered Mar 14", merchant: "Lady White Co.",
              itemCount: "1 item", total: "$54.23",
              thumbColors: [Color(hex: 0xF0ECE6), Color(hex: 0xE2DDD5)], hasStack: false),
        .init(id: 1, deliveredText: "Delivered Mar 2", merchant: "Ebay",
              itemCount: "1 item", total: "$12.99",
              thumbColors: [Color(hex: 0x7A614D), Color(hex: 0x3E332E)], hasStack: false),
        .init(id: 2, deliveredText: "Delivered Mar 2", merchant: "DHL",
              itemCount: nil, total: nil,
              thumbColors: [Color(hex: 0xF0E0C8), Color(hex: 0xE0C8A8)], hasStack: false),
        .init(id: 3, deliveredText: "Delivered Feb 8", merchant: "Prolog Coffee",
              itemCount: "2 items", total: "$103.98",
              thumbColors: [Color(hex: 0xD29B6D), Color(hex: 0x8E5D3D)], hasStack: true),
    ]

    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.space16) {
            // ── Buy again ──
            SectionHeader(title: "Buy again")
                .padding(.horizontal, -Tokens.space16)

            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(products) { product in
                    BuyAgainCard(product: product)
                }
            }

            // ── Past orders ──
            VStack(alignment: .leading, spacing: Tokens.space16) {
                SectionHeader(title: "Past orders")
                    .padding(.horizontal, -Tokens.space16)

                VStack(spacing: Tokens.space16) {
                    ForEach(pastOrders) { order in
                        PastOrderRow(order: order)
                    }
                }
            }
            .padding(.top, Tokens.space20)
        }
        .padding(.horizontal, Tokens.space20)
        .padding(.bottom, Tokens.space20)
        .background(
            RoundedRectangle(cornerRadius: Tokens.radius28, style: .continuous)
                .fill(Tokens.ShopClient.bgFill)
        )
        .padding(.top, Tokens.ShopClient.sectionGap)
    }
}

// MARK: - Buy Again Card

private struct BuyAgainCard: View {
    let product: BuyAgainProduct

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: product.bgColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    BuyAgainAccent(style: product.accentStyle)
                        .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
                }
                .shadow(
                    color: Tokens.ShopClient.shadowSColor,
                    radius: Tokens.ShopClient.shadowSRadius,
                    x: 0,
                    y: Tokens.ShopClient.shadowSY
                )

            Image("BuyAgainIcon")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .padding(Tokens.space8)
        }
    }
}

// MARK: - Buy Again Accent

private struct BuyAgainAccent: View {
    let style: BuyAgainAccentStyle

    var body: some View {
        switch style {
        case .blackShoes:
            ZStack {
                Ellipse().fill(Color(hex: 0x2A2622).opacity(0.7)).frame(width: 60, height: 28).offset(y: 8)
                RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color(hex: 0x1C1A18))
                    .frame(width: 50, height: 22).rotationEffect(.degrees(-8)).offset(x: -4, y: 2)
                RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color(hex: 0x2A2622))
                    .frame(width: 48, height: 20).rotationEffect(.degrees(5)).offset(x: 4, y: -2)
            }
        case .whiteTees:
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color.white.opacity(0.6)).frame(width: 42, height: 30)
                RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.white.opacity(0.4)).frame(width: 36, height: 8)
            }
        case .coffeeProducts:
            VStack(spacing: 3) {
                RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.white.opacity(0.85)).frame(width: 28, height: 36)
                    .overlay(alignment: .top) {
                        Text("PROLOG").font(.system(size: 4, weight: .bold)).foregroundColor(Color(hex: 0x2A5040)).padding(.top, 4)
                    }
            }.offset(y: -4)
        case .blackShoesAlt:
            ZStack {
                RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color(hex: 0x222020))
                    .frame(width: 44, height: 20).rotationEffect(.degrees(-12)).offset(x: -3, y: 4)
                RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color(hex: 0x1A1818))
                    .frame(width: 40, height: 18).rotationEffect(.degrees(8)).offset(x: 5, y: -2)
            }
        case .darkShoes:
            ZStack {
                Ellipse().fill(Color(hex: 0x1C1A18).opacity(0.6)).frame(width: 55, height: 24).offset(y: 6)
                RoundedRectangle(cornerRadius: 6, style: .continuous).fill(Color(hex: 0x2A2622))
                    .frame(width: 46, height: 20).rotationEffect(.degrees(3))
            }
        case .whiteTeesFolded:
            VStack(spacing: 3) {
                RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Color.white.opacity(0.55)).frame(width: 38, height: 26)
                RoundedRectangle(cornerRadius: 3, style: .continuous).fill(Color.white.opacity(0.35)).frame(width: 32, height: 22)
            }
        }
    }
}

// MARK: - Past Order Row

private struct PastOrderRow: View {
    let order: PastOrder

    var body: some View {
        HStack(spacing: Tokens.space16) {
            if order.hasStack {
                ZStack(alignment: .topTrailing) {
                    pastThumb(colors: [Color(hex: 0x8FBADE), Color(hex: 0x5A88AA)], size: 45)
                        .rotationEffect(.degrees(-6)).offset(x: -2.5, y: 1.5)
                    pastThumb(colors: order.thumbColors, size: 45)
                }
                .frame(width: 48, height: 48)
            } else {
                pastThumb(colors: order.thumbColors, size: 48)
            }

            VStack(alignment: .leading, spacing: Tokens.space4) {
                Text(order.deliveredText)
                    .shopTextStyle(.bodyLargeBold)
                    .foregroundColor(Tokens.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 0) {
                    Text(order.merchant)
                    if let count = order.itemCount, let total = order.total {
                        Text(" \u{30fb} \(count) \u{30fb} \(total)")
                    }
                }
                .shopTextStyle(.caption)
                .foregroundColor(Tokens.textSecondary)
                .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
    }

    private func pastThumb(colors: [Color], size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: size, height: size)
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(Tokens.imageBorder, lineWidth: 0.375)
            )
            .shadow(color: Tokens.ShopClient.shadowSColor.opacity(0.8), radius: 1.5, x: 0, y: 0.75)
    }
}
