//
//  F1DriverCarouselCard.swift
//  Shop feed playground
//
//  F1-themed feed card — driver carousel with team-colored backgrounds,
//  large number watermark, driver cutout, and floating merch chips.
//  Style reference: formula1.com driver pages.
//  Data: F1DriverCarouselData.swift
//

import SwiftUI

// MARK: - F1 Driver Carousel Card

struct F1DriverCarouselCard: View {
    @State private var activeDriverIndex: Int = 0
    @State private var overlayVisible: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var driverTransitionOffset: CGFloat = 0
    @State private var isDriverTransitioning: Bool = false

    private let drivers = F1Driver.defaults
    private var driver: F1Driver { drivers[activeDriverIndex] }





    var body: some View {
        ZStack {
            // Team color gradient background
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [driver.teamColor, driver.teamColorDark],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )
                .animation(Tokens.springDefault, value: activeDriverIndex)

            // Large number watermark (right side)
            Text("\(driver.number)")
                .font(.system(size: 320, weight: .black))
                .foregroundColor(.white.opacity(0.1))
                .offset(x: 80, y: 20)
                .allowsHitTesting(false)

            // Driver cutout image (right side)
            driverImage
                .allowsHitTesting(false)

            // Header (same style as "What they're wearing" card)
            CardHeader(subtitle: "Shop official team merch", title: "F1", lightText: true)
                .allowsHitTesting(false)

            // Left side content: name, team, shop button
            driverInfo

            // Floating product chips (overlay mode)
            if overlayVisible {
                Color.black.opacity(0.3)
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
                    .allowsHitTesting(false)
                    .transition(.opacity)

                floatingProductChips
            }

            // Pagination dots
            paginationDots
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        // Horizontal swipe for driver carousel
        .simultaneousGesture(
            (overlayVisible || isDriverTransitioning) ? nil :
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    if abs(value.translation.width) > abs(value.translation.height) {
                        dragOffset = value.translation.width
                    }
                }
                .onEnded { value in
                    let threshold: CGFloat = 50
                    guard abs(value.translation.width) > abs(value.translation.height) else {
                        withAnimation(Tokens.springDefault) {
                            dragOffset = 0
                        }
                        return
                    }

                    if dragOffset < -threshold && activeDriverIndex < drivers.count - 1 {
                        transitionDriver(to: activeDriverIndex + 1, direction: -1)
                    } else if dragOffset > threshold && activeDriverIndex > 0 {
                        transitionDriver(to: activeDriverIndex - 1, direction: 1)
                    } else {
                        withAnimation(Tokens.springDefault) {
                            dragOffset = 0
                        }
                    }
                }
        )
    }

    private func transitionDriver(to nextIndex: Int, direction: CGFloat) {
        let offscreenX = Tokens.cardWidth + 140
        isDriverTransitioning = true
        Haptics.selection()

        // First leg: current driver exits completely off-card.
        withAnimation(.easeInOut(duration: 0.2)) {
            driverTransitionOffset = direction * offscreenX
            dragOffset = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            var tx = Transaction()
            tx.disablesAnimations = true
            withTransaction(tx) {
                activeDriverIndex = nextIndex
                overlayVisible = false
                // Place next driver just off-card on the opposite side.
                driverTransitionOffset = -direction * offscreenX
            }

            // Second leg: next driver enters to center.
            withAnimation(Tokens.springExpand) {
                driverTransitionOffset = 0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isDriverTransitioning = false
            }
        }
    }
}

// MARK: - Subviews

private extension F1DriverCarouselCard {

    // MARK: Driver Image (centered)

    var driverImage: some View {
        Image(driver.imageName)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 1094)
            .scaleEffect(1.25)
            .offset(x: dragOffset * 0.15 + driverTransitionOffset)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    // MARK: Driver Info (bottom, over gradient)

    var driverInfo: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                // First name (italic serif)
                Text(driver.firstName)
                    .font(.system(size: 28, weight: .regular, design: .serif))
                    .italic()
                    .foregroundColor(.white)

                // Last name (bold, uppercase)
                Text(driver.lastName.uppercased())
                    .font(.system(size: 36, weight: .black))
                    .tracking(-1)
                    .foregroundColor(.white)
                    .padding(.top, -4)

                // Country flag | Team | Number
                HStack(spacing: Tokens.space8) {
                    Text(driver.countryFlag)
                        .font(.system(size: 14))

                    Text(driver.country)
                        .font(.system(size: Tokens.captionSize, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))

                    Rectangle().fill(.white.opacity(0.3)).frame(width: 1, height: 12)

                    Text(driver.team)
                        .font(.system(size: Tokens.captionSize, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))

                    Rectangle().fill(.white.opacity(0.3)).frame(width: 1, height: 12)

                    Text("\(driver.number)")
                        .font(.system(size: Tokens.captionSize, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.top, Tokens.space8)

                // Shop now button
                Button {
                    Haptics.light()
                    withAnimation(Tokens.springDefault) {
                        overlayVisible.toggle()
                    }
                } label: {
                    Text("Shop now")
                        .font(.system(size: Tokens.bodySize, weight: .semibold))
                        .tracking(Tokens.bodyTracking)
                    .foregroundColor(driver.teamColor)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        Capsule().fill(.white)
                    )
                }
                .padding(.top, Tokens.space16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, Tokens.space20)
            .padding(.bottom, 50)
        }
    }

    // MARK: Floating Product Chips

    var floatingProductChips: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ForEach(driver.products) { product in
                let x = w / 2 + product.xFrac * w
                let y = h / 2 + product.yFrac * h

                F1ProductChip(product: product) {
                    Haptics.light()
                }
                .position(x: x, y: y)
                .transition(.scale(scale: 0.6).combined(with: .opacity))
            }
        }
    }

    // MARK: Pagination Dots

    var paginationDots: some View {
        VStack {
            Spacer()
            HStack(spacing: 6) {
                ForEach(0..<drivers.count, id: \.self) { i in
                    Capsule()
                        .fill(i == activeDriverIndex ? .white : .white.opacity(0.35))
                        .frame(width: i == activeDriverIndex ? 18 : 6, height: 6)
                        .animation(Tokens.springDefault, value: activeDriverIndex)
                }
            }
            .padding(.bottom, Tokens.space20)
        }
    }
}

// MARK: - F1 Product Chip

private struct F1ProductChip: View {
    let product: F1MerchProduct
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 9) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(product.thumbnailColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(.black.opacity(0.06), lineWidth: 0.5)
                    )

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
        .buttonStyle(.plain)
    }
}
