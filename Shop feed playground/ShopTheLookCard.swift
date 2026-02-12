//
//  ShopTheLookCard.swift
//  Shop feed playground
//
//  "Shop the Look" card — swipe through celebrities, tap to reveal
//  floating product cards, tap a product for a mini PDP.
//  Data: ShopTheLookData.swift
//

import SwiftUI

// MARK: - Shop The Look Card

struct ShopTheLookCard: View {
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var showProducts: Bool = false
    @State private var selectedProduct: FloatingProduct? = nil

    private let celebs = CelebrityLook.defaults
    private var celeb: CelebrityLook { celebs[currentIndex] }

    var body: some View {
        ZStack {
            // Celebrity photo
            Color.clear
                .background {
                    Image(celeb.imageName)
                        .resizable()
                        .scaledToFill()
                        .offset(x: dragOffset * 0.3) // parallax
                }
                .clipped()

            // Bottom gradient for text
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.4),
                    .init(color: .black.opacity(0.7), location: 0.85),
                ],
                startPoint: .top, endPoint: .bottom
            )
            .allowsHitTesting(false)

            // Header
            CardHeader(subtitle: "Shop the look", title: celeb.name, lightText: true)
                .allowsHitTesting(false)

            // Caption at bottom
            VStack {
                Spacer()
                HStack {
                    Text(celeb.caption)
                        .font(.system(size: Tokens.captionSize, weight: .regular))
                        .tracking(Tokens.cozyTracking)
                        .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    // Tap to explore hint
                    if !showProducts {
                        Text("Tap to explore")
                            .font(.system(size: Tokens.captionSize, weight: .semibold))
                            .tracking(Tokens.cozyTracking)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(.white.opacity(0.2)))
                    }
                }
                .padding(.horizontal, Tokens.space20)
                .padding(.bottom, Tokens.space24)
            }

            // Page dots
            VStack {
                Spacer()
                HStack(spacing: 6) {
                    ForEach(0..<celebs.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? .white : .white.opacity(0.4))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.bottom, 56)
            }

            // Floating product cards
            if showProducts && selectedProduct == nil {
                floatingProducts
            }

            // Mini PDP overlay
            if let product = selectedProduct {
                miniPDP(product)
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .onTapGesture {
            if selectedProduct != nil { return }
            withAnimation(Tokens.springDefault) {
                showProducts.toggle()
            }
        }
        .gesture(
            (showProducts || selectedProduct != nil) ? nil :
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    let threshold: CGFloat = 50
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                        if dragOffset < -threshold && currentIndex < celebs.count - 1 {
                            currentIndex += 1
                        } else if dragOffset > threshold && currentIndex > 0 {
                            currentIndex -= 1
                        }
                        dragOffset = 0
                        showProducts = false
                    }
                }
        )
    }
}

// MARK: - Subviews

private extension ShopTheLookCard {
    var floatingProducts: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ForEach(celeb.products) { product in
                let x = w / 2 + product.xFrac * w
                let y = h / 2 + product.yFrac * h

                FloatingProductCard(product: product)
                    .position(x: x, y: y)
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
                    .onTapGesture {
                        withAnimation(Tokens.springDefault) {
                            selectedProduct = product
                        }
                    }
            }
        }
    }

    func miniPDP(_ product: FloatingProduct) -> some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .onTapGesture {
                    withAnimation(Tokens.springDefault) {
                        selectedProduct = nil
                    }
                }

            // Product detail card
            VStack(spacing: Tokens.space16) {
                // Product image
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
                    .padding(Tokens.space16)

                // Info
                VStack(spacing: Tokens.space4) {
                    Text(product.merchant)
                        .font(.system(size: Tokens.captionSize, weight: .regular))
                        .tracking(Tokens.cozyTracking)
                        .foregroundColor(Tokens.textSecondary)

                    Text(product.name)
                        .font(.system(size: Tokens.bodySize, weight: .semibold))
                        .tracking(Tokens.bodyTracking)
                        .foregroundColor(Tokens.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(product.price)
                        .font(.system(size: Tokens.bodySize, weight: .bold))
                        .tracking(Tokens.bodyTracking)
                        .foregroundColor(Tokens.textPrimary)
                        .padding(.top, Tokens.space4)
                }

                // Shop now button
                Button(action: {}) {
                    Text("Shop now")
                        .font(.system(size: Tokens.bodySize, weight: .semibold))
                        .tracking(Tokens.bodyTracking)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(.black))
                }
                .padding(.top, Tokens.space8)
            }
            .padding(Tokens.space24)
            .background(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .fill(.white)
            )
            .padding(.horizontal, Tokens.space32)
            .overlay(alignment: .topTrailing) {
                CloseButton {
                    withAnimation(Tokens.springDefault) {
                        selectedProduct = nil
                    }
                }
                .padding(.trailing, Tokens.space24)
            }
            .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
        .zIndex(500)
    }
}

// MARK: - Floating Product Card

private struct FloatingProductCard: View {
    let product: FloatingProduct

    var body: some View {
        HStack(spacing: 9) {
            // Product thumbnail
            Color.clear
                .frame(width: 44, height: 44)
                .background {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFit()
                }
                .background(Color(hex: 0xF5F5F5))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            // Name + price
            VStack(alignment: .leading, spacing: 3) {
                Text(product.name)
                    .font(.system(size: Tokens.captionSize, weight: .regular))
                    .tracking(0.15)
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text(product.price)
                    .font(.system(size: Tokens.captionSize, weight: .semibold))
                    .tracking(0.15)
                    .foregroundColor(.black)
            }
            .frame(width: 75, alignment: .leading)

            // Cart icon
            Image(systemName: "cart.badge.plus")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
                .frame(width: 20, height: 20)
        }
        .padding(.leading, 4)
        .padding(.trailing, 12)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.16), radius: 12, x: 0, y: 4)
        )
    }
}
