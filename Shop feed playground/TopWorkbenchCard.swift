//
//  TopWorkbenchCard.swift
//  Shop feed playground
//
//  Spin-to-win workbench card based on Figma reference.
//

import SwiftUI

struct TopWorkbenchCard: View {
    @State private var wheelRotation: Double = 0
    @State private var isSpinning: Bool = false
    @State private var isRevealed: Bool = false
    @State private var winningIndex: Int? = nil
    @State private var hasSpunAtLeastOnce: Bool = false
    @Namespace private var wheelNamespace

    private let spinDuration: Double = 4.4
    private let products: [WorkbenchWheelProduct] = [
        .init(id: 0, imageName: "WheelShoe01", discountPercent: 20),
        .init(id: 1, imageName: "WheelShoe02", discountPercent: 15),
        .init(id: 2, imageName: "WheelShoe03", discountPercent: 25),
        .init(id: 3, imageName: "WheelShoe04", discountPercent: 10),
        .init(id: 4, imageName: "WheelShoe05", discountPercent: 30),
        .init(id: 5, imageName: "WheelShoe06", discountPercent: 18),
        .init(id: 6, imageName: "WheelShoe07", discountPercent: 12),
        .init(id: 7, imageName: "WheelShoe08", discountPercent: 22),
    ]

    var body: some View {
        ZStack {
            backgroundLayer
            wheelLayer

            if isRevealed, let winningIndex {
                let winner = products[winningIndex]
                wheelProductCard(product: winner, size: CGSize(width: 240, height: 240))
                    .matchedGeometryEffect(
                        id: "workbench-wheel-\(winner.id)",
                        in: wheelNamespace
                    )
                    .transition(.identity)
                    .zIndex(120)
                    .offset(y: -6)
            }

            if isRevealed {
                revealedChrome
            } else if !isSpinning {
                spinPromptOverlay
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Subviews

private extension TopWorkbenchCard {
    var backgroundLayer: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color(hex: 0x1678EE), Color(hex: 0x1270E3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .stroke(.black.opacity(0.06), lineWidth: 0.5)
            )
            .shadow(
                color: Tokens.ShopClient.shadowLColor,
                radius: Tokens.ShopClient.shadowLRadius,
                x: 0,
                y: Tokens.ShopClient.shadowLY
            )
    }

    var wheelLayer: some View {
        let ringRadius: CGFloat = 194
        let cardSize: CGSize = CGSize(width: 100, height: 100)
        let wheelCenter = CGPoint(x: Tokens.cardWidth / 2, y: Tokens.cardHeight / 2)

        return ZStack {
            ForEach(products.indices, id: \.self) { index in
                let angle = slotAngle(for: index)
                let point = pointOnRing(
                    angle: angle,
                    radius: ringRadius,
                    center: wheelCenter
                )
                let isWinner = index == winningIndex
                let ejectDistance: CGFloat = (isRevealed && !isWinner) ? 420 : 0
                let radians = angle * .pi / 180

                if !isRevealed || !isWinner {
                    wheelProductCard(product: products[index], size: cardSize)
                        .matchedGeometryEffect(
                            id: "workbench-wheel-\(products[index].id)",
                            in: wheelNamespace
                        )
                        .rotationEffect(.degrees(angle))
                        .position(point)
                        .offset(
                            x: CGFloat(sin(radians)) * ejectDistance,
                            y: -CGFloat(cos(radians)) * ejectDistance
                        )
                        .zIndex(isWinner ? 40 : 1)
                }
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .rotationEffect(.degrees(wheelRotation))
        .offset(x: 8, y: 6)
        .animation(.spring(response: 0.58, dampingFraction: 0.86), value: isRevealed)
    }

    var spinPromptOverlay: some View {
        VStack(spacing: 16) {
            Text("Spin the wheel\nget a discount")
                .shopTextStyle(.sectionTitle)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Button {
                spinWheel()
            } label: {
                Text(isSpinning ? "Spinning..." : "Spin")
                    .shopTextStyle(.buttonLarge)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .frame(height: 44)
                    .background(
                        Capsule(style: .continuous)
                            .fill(.black)
                    )
            }
            .buttonStyle(.plain)
            .disabled(isSpinning)
            .opacity(isSpinning ? 0.85 : 1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .offset(x: 8, y: 6)
    }

    @ViewBuilder
    var revealedChrome: some View {
        if let winningIndex {
            let winner = products[winningIndex]

            ZStack {
                VStack(spacing: 8) {
                    merchantAvatar
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 44)

                VStack {
                    Spacer()
                    Text("\(winner.discountPercent)% off at GBNY")
                        .shopTextStyle(.sectionTitle)
                        .foregroundStyle(.white)
                        .padding(.bottom, 132)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack {
                    Spacer()
                    Button {
                        Haptics.light()
                    } label: {
                        Text("Shop now")
                            .font(.system(size: Tokens.bodySize, weight: .semibold))
                            .tracking(Tokens.bodyTracking)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(Capsule(style: .continuous).fill(.white))
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 38)
                }
            }
            .transition(.opacity)
        }
    }

    var merchantAvatar: some View {
        Button {
            if hasSpunAtLeastOnce {
                resetInteraction()
            }
        } label: {
            Image("WheelMerchantLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 28)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Interaction

private extension TopWorkbenchCard {
    func spinWheel() {
        guard !isSpinning else { return }
        let targetIndex = Int.random(in: products.indices)
        let targetRotation = stoppingRotation(for: targetIndex)

        Haptics.light()
        isSpinning = true
        hasSpunAtLeastOnce = true
        isRevealed = false
        winningIndex = nil

        withAnimation(.timingCurve(0.08, 0.92, 0.2, 1, duration: spinDuration)) {
            wheelRotation = targetRotation
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + spinDuration) {
            guard isSpinning else { return }
            isSpinning = false
            var tx = Transaction()
            tx.disablesAnimations = true
            withTransaction(tx) {
                wheelRotation = normalizedDegrees(wheelRotation)
            }
            winningIndex = targetIndex
            Haptics.notify(.success)
            withAnimation(.spring(response: 0.66, dampingFraction: 0.9)) {
                isRevealed = true
            }
        }
    }

    func stoppingRotation(for targetIndex: Int) -> Double {
        let baseAngle = angleStep * Double(targetIndex)
        let stopModulo = normalizedDegrees(360 - baseAngle)
        let currentModulo = normalizedDegrees(wheelRotation)
        let toStop = normalizedDegrees(stopModulo - currentModulo)
        let extraTurns = Double(Int.random(in: 6...8)) * 360
        return wheelRotation + extraTurns + toStop
    }

    func resetInteraction() {
        Haptics.light()
        isSpinning = false
        winningIndex = nil
        withAnimation(.spring(response: 0.5, dampingFraction: 0.86)) {
            isRevealed = false
            wheelRotation = 0
        }
    }

    func slotAngle(for index: Int) -> Double {
        angleStep * Double(index)
    }

    var angleStep: Double {
        360.0 / Double(products.count)
    }

    func pointOnRing(angle: Double, radius: CGFloat, center: CGPoint) -> CGPoint {
        let radians = angle * .pi / 180
        return CGPoint(
            x: center.x + CGFloat(sin(radians)) * radius,
            y: center.y - CGFloat(cos(radians)) * radius
        )
    }

    func normalizedDegrees(_ value: Double) -> Double {
        let remainder = value.truncatingRemainder(dividingBy: 360)
        return remainder >= 0 ? remainder : remainder + 360
    }
}

// MARK: - Product Card

private extension TopWorkbenchCard {
    func wheelProductCard(product: WorkbenchWheelProduct, size: CGSize) -> some View {
        RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
            .fill(Color(hex: 0xE6E6E8))
            .frame(width: size.width, height: size.height)
            .overlay {
                Image(product.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
            }
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                    .stroke(.white.opacity(0.2), lineWidth: 0.5)
            )
            .shadow(
                color: Tokens.ShopClient.shadowLColor,
                radius: 20,
                x: 0,
                y: 8
            )
    }
}

private struct WorkbenchWheelProduct: Identifiable {
    let id: Int
    let imageName: String
    let discountPercent: Int
}

