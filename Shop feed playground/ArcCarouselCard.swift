//
//  ArcCarouselCard.swift
//  Shop feed playground
//
//  "What they're wearing" A24 card — portrait cards on an arc.
//  Swipe one at a time; tap to expand with product rail.
//  Data: ArcCarouselData.swift
//

import SwiftUI

// MARK: - Arc Carousel Card

struct ArcCarouselCard: View {
    @State private var currentIndex: Int = 2
    @State private var dragOffset: CGFloat = 0
    @State private var expandedIndex: Int? = nil
    @State private var showCloseButton: Bool = false

    private let portraits = PortraitData.defaults

    // Arc geometry
    private let arcRadius: CGFloat = 900
    private let anglePerCard: CGFloat = 12
    private let cardW: CGFloat = 160
    private let cardH: CGFloat = 200
    private let dragPerCard: CGFloat = 100
    private let expandedW: CGFloat = 310
    private let expandedH: CGFloat = 460

    private var isExpanded: Bool { expandedIndex != nil }

    private var continuousPosition: CGFloat {
        CGFloat(currentIndex) + (-dragOffset / dragPerCard)
    }

    private var bgColor: Color {
        let pos = max(0, min(continuousPosition, CGFloat(portraits.count - 1)))
        let lower = Int(pos)
        let upper = min(lower + 1, portraits.count - 1)
        let frac = pos - CGFloat(lower)
        return portraits[lower].bgColor.interpolate(to: portraits[upper].bgColor, fraction: frac)
    }

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(bgColor)

            // Dark gradient overlay
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.27),
                    .init(color: .black.opacity(0.6), location: 0.73),
                ],
                startPoint: .top, endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
            .allowsHitTesting(false)

            // Background image
            Image("MartySupreme")
                .resizable()
                .scaledToFill()
                .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
                .opacity(0.15)
                .clipped()
                .allowsHitTesting(false)

            // Header
            CardHeader(subtitle: "What they're wearing", title: "A24", lightText: true)
                .allowsHitTesting(false)

            // Arc carousel
            arcCarousel

            // Drag gesture
            .gesture(isExpanded ? nil : arcDragGesture)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Subviews

private extension ArcCarouselCard {
    var arcCarousel: some View {
        ZStack {
            ForEach(0..<portraits.count, id: \.self) { i in
                let isThisExpanded = expandedIndex == i
                let relPos = CGFloat(i) - continuousPosition
                let angle = relPos * anglePerCard
                let radians = angle * .pi / 180

                let arcX = sin(radians) * arcRadius
                let arcY = (1 - cos(radians)) * arcRadius + 172

                let expandX: CGFloat = isThisExpanded ? 0 : (i < (expandedIndex ?? i) ? -500 : 500)
                let expandY: CGFloat = isThisExpanded ? -20 : arcY

                let finalX = isExpanded ? expandX : arcX
                let finalY = isExpanded ? expandY : arcY
                let finalW = isThisExpanded ? expandedW : cardW
                let finalH = isThisExpanded ? expandedH : cardH
                let finalAngle = isExpanded ? 0.0 : Double(angle)
                let finalOpacity = (isExpanded && !isThisExpanded) ? 0.0 : 1.0

                let distFromCenter = abs(relPos)
                let isCentered = !isExpanded && distFromCenter < 0.3 && abs(dragOffset) < 15

                PortraitCard(data: portraits[i], showText: isCentered, isExpanded: isThisExpanded)
                    .frame(width: finalW, height: finalH)
                    // Product rail
                    .overlay(alignment: .bottom) {
                        if isThisExpanded && showCloseButton && !portraits[i].products.isEmpty {
                            ProductRail(products: portraits[i].products)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
                    // Close button
                    .overlay(alignment: .topTrailing) {
                        if isThisExpanded && showCloseButton {
                            CloseButton {
                                showCloseButton = false
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                                    expandedIndex = nil
                                }
                            }
                        }
                    }
                    .rotationEffect(.degrees(finalAngle))
                    .offset(x: finalX, y: finalY)
                    .opacity(finalOpacity)
                    .zIndex(isThisExpanded ? 200 : Double(100) - Double(abs(angle)))
                    .onTapGesture {
                        guard isCentered else { return }
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.82)) {
                            expandedIndex = i
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                            withAnimation(.easeIn(duration: 0.2)) { showCloseButton = true }
                        }
                    }
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.82), value: expandedIndex)
        .animation(
            dragOffset == 0 ? .spring(response: 0.45, dampingFraction: 0.8) : .interactiveSpring(),
            value: continuousPosition
        )
    }

    var arcDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in dragOffset = value.translation.width }
            .onEnded { value in
                let threshold: CGFloat = 30
                let next: Int
                if dragOffset < -threshold && currentIndex < portraits.count - 1 { next = currentIndex + 1 }
                else if dragOffset > threshold && currentIndex > 0 { next = currentIndex - 1 }
                else { next = currentIndex }
                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    currentIndex = next
                    dragOffset = 0
                }
            }
    }
}

// MARK: - Product Rail (reusable)

struct ProductRail: View {
    let products: [ProductCutout]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -10) {
                Spacer().frame(width: 30)
                ForEach(0..<products.count, id: \.self) { p in
                    Image(products[p].imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: products[p].width, height: products[p].height)
                        .rotationEffect(.degrees(products[p].rotation))
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                Spacer().frame(width: Tokens.space20)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, Tokens.space32)
        .transition(.opacity)
    }
}

// MARK: - Close Button (reusable)

struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 32, height: 32)
                .background(Circle().fill(.white))
        }
        .padding(Tokens.space12)
        .transition(.opacity)
    }
}

// MARK: - Portrait Card

private struct PortraitCard: View {
    let data: PortraitData
    let showText: Bool
    var isExpanded: Bool = false

    var body: some View {
        Color.clear
            .background {
                Image(data.imageName)
                    .resizable()
                    .scaledToFill()
                    .scaleEffect(data.imageScale)
            }
            .clipped()
            .overlay {
                LinearGradient(
                    stops: isExpanded
                        ? [.init(color: Color(hex: 0x212524).opacity(0), location: 0.33),
                           .init(color: Color(hex: 0x212524), location: 0.82)]
                        : [.init(color: .clear, location: 0.5),
                           .init(color: .black.opacity(0.5), location: 1.0)],
                    startPoint: .top, endPoint: .bottom
                )
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(data.name)
                        .font(.system(size: 24, weight: .medium))
                        .tracking(-1.0)
                        .foregroundColor(.white)
                    Text(data.brand)
                        .font(.system(size: Tokens.captionSize, weight: .regular))
                        .tracking(Tokens.cozyTracking)
                        .foregroundColor(.white.opacity(0.56))
                }
                .padding(Tokens.space16)
                .opacity(showText ? 1 : 0)
            }
            .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}
