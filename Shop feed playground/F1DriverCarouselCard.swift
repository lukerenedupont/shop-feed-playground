//
//  F1DriverCarouselCard.swift
//  Shop feed playground
//
//  F1-themed feed card — driver carousel with team-colored looping backgrounds,
//  driver cutout, and team-merch thread navigation.
//  Style reference: formula1.com driver pages.
//  Data: F1DriverCarouselData.swift
//

import SwiftUI

// MARK: - F1 Driver Carousel Card

struct F1DriverCarouselCard: View {
    @State private var activeDriverIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var driverTransitionOffset: CGFloat = 0
    @State private var isDriverTransitioning: Bool = false
    @State private var isPushingThread: Bool = false

    private let drivers = F1Driver.defaults
    private let backgroundVideoPaths: [String] = [
        "/Users/lukedupont/Downloads/ScreenRecording_02-19-2026 19-46-52_1.mov",
        "/Users/lukedupont/Downloads/ScreenRecording_02-19-2026 19-47-10_1.mov",
        "/Users/lukedupont/Downloads/ScreenRecording_02-19-2026 19-47-32_1.mov",
        "/Users/lukedupont/Downloads/ScreenRecording_02-19-2026 19-48-00_1.mov",
        "/Users/lukedupont/Downloads/ScreenRecording_02-19-2026 19-48-29_1.mov",
    ]
    private var driver: F1Driver { drivers[activeDriverIndex] }
    private var activeBackgroundVideoURL: URL? {
        guard !backgroundVideoPaths.isEmpty else { return nil }
        let path = backgroundVideoPaths[activeDriverIndex % backgroundVideoPaths.count]
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }

    private var teamMerchThreadProducts: [TopicCardProduct] {
        if driver.products.isEmpty {
            return [
                .make(id: "f1-\(driver.id)-fallback-1", imageName: driver.imageName, price: "$68"),
                .make(id: "f1-\(driver.id)-fallback-2", imageName: driver.imageName, price: "$120"),
                .make(id: "f1-\(driver.id)-fallback-3", imageName: driver.imageName, price: "$52"),
            ]
        }

        return driver.products.map { product in
            .make(
                id: "f1-\(driver.id)-\(product.id)",
                imageName: driver.imageName,
                price: product.price
            )
        }
    }

    private var teamMerchThreadTopic: TopicExplorerItem {
        TopicExplorerItem(
            id: "f1-team-thread-\(driver.id)",
            title: "\(driver.team) merch",
            subtitle: "We pulled similar team gear inspired by \(driver.firstName) \(driver.lastName), so you can compare and shop options in the app.",
            povText: "Prioritized by team colors, current-season fanwear, and products closest to this race-weekend style.",
            backgroundImageName: driver.imageName,
            color: driver.teamColor,
            accent: driver.teamColorDark,
            sourceChips: ["Official store", "F1 shop", "In-app marketplace"],
            interestPills: driver.products.map(\.name),
            trendingMerchants: [driver.team, "F1 Authentics", "Teamwear"],
            products: teamMerchThreadProducts
        )
    }

    var body: some View {
        ZStack {
            // Team background video per racer (falls back to gradient)
            Group {
                if let activeBackgroundVideoURL {
                    SharedLoopingVideoBackground(url: activeBackgroundVideoURL)
                        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [driver.teamColor, driver.teamColorDark],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
            }
            .overlay(
                LinearGradient(
                    stops: [
                        .init(color: driver.teamColor.opacity(0.22), location: 0.0),
                        .init(color: driver.teamColorDark.opacity(0.36), location: 1.0),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                LinearGradient(
                    stops: [
                        .init(color: .black.opacity(0.08), location: 0.0),
                        .init(color: .black.opacity(0.15), location: 0.48),
                        .init(color: .black.opacity(0.48), location: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
            )
            .animation(Tokens.springDefault, value: activeDriverIndex)

            // Driver cutout image (right side)
            driverImage
                .allowsHitTesting(false)

            // Header (same style as "What they're wearing" card)
            CardHeader(subtitle: "Shop official team merch", title: "F1", lightText: true)
                .allowsHitTesting(false)

            // Left side content: CTA only
            driverInfo

            // Pagination dots
            paginationDots
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        // Horizontal swipe for driver carousel
        .simultaneousGesture(
            isDriverTransitioning ? nil :
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
        .navigationDestination(isPresented: $isPushingThread) {
            ThreadBlankView(topic: teamMerchThreadTopic) {
                isPushingThread = false
            }
        }
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
                VStack(alignment: .leading, spacing: -2) {
                    Text(driver.firstName)
                        .font(.system(size: 24, weight: .regular, design: .serif))
                        .italic()
                        .foregroundStyle(.white)

                    Text(driver.lastName.uppercased())
                        .font(.system(size: 42, weight: .black))
                        .tracking(-1.2)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                }
                .padding(.bottom, 12)

                // Shop now button
                Button {
                    Haptics.light()
                    isPushingThread = true
                } label: {
                    Text("Shop now")
                        .shopTextStyle(.bodyLargeBold)
                        .foregroundStyle(driver.teamColor)
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

