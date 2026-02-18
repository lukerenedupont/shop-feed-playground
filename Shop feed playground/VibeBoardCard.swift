//
//  VibeBoardCard.swift
//  Shop feed playground
//
//  Full-bleed video card inspired by the Figma collection card.
//

import AVFoundation
import SwiftUI
import UIKit

struct VibeBoardCard: View {
    private let heroVideoURL = URL(fileURLWithPath: "/Users/lukedupont/Downloads/make_the_scene_move_in_a_subtle_way_kplozzeyilgaw02e3of4_1.mp4")
    private let videoFillScale: CGFloat = 1.24
    private let carouselProducts: [VibeCarouselProduct] = [
        .init(id: "prod-1", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.36.27_AM-4677b6f3-683f-4acf-a566-5c3f878de759.png"),
        .init(id: "prod-2", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.36.38_AM-e55d7673-d0e7-4122-bf05-1e7182f5b932.png"),
        .init(id: "prod-3", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.36.50_AM-cc6657ba-d702-4839-a5a2-526d59ba3925.png"),
        .init(id: "prod-4", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.37.04_AM-832b0a69-459c-4029-a76d-125864026129.png"),
        .init(id: "prod-5", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.37.20_AM-5211992c-f6e3-493e-954e-e96e68b4c74b.png"),
        .init(id: "prod-6", filePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-18_at_11.37.29_AM-dd0915f8-dcde-4970-964c-5d765871633a.png"),
    ]

    private var hasLocalVideo: Bool {
        FileManager.default.fileExists(atPath: heroVideoURL.path)
    }

    var body: some View {
        ZStack {
            fullBleedBackground
            topLockup
            bottomLockup
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .shadow(
            color: Tokens.ShopClient.shadowLColor,
            radius: Tokens.ShopClient.shadowLRadius,
            x: 0,
            y: Tokens.ShopClient.shadowLY
        )
    }
}

private extension VibeBoardCard {
    var fullBleedBackground: some View {
        Group {
            if hasLocalVideo {
                LoopingVideoBackground(url: heroVideoURL)
                    .scaleEffect(videoFillScale)
            } else {
                fallbackBackground
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipped()
        .overlay {
            // Subtle contrast veil so white labels stay readable.
            Color.black.opacity(0.06)
        }
    }

    var fallbackBackground: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color(hex: 0xD9C4A5), Color(hex: 0xC2A684)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }

    var topLockup: some View {
        VStack {
            Text("Collection by Luke")
                .shopTextStyle(.subtitle)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 22)
                .padding(.leading, Tokens.space20)

            Spacer()
        }
    }

    var bottomLockup: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                productCarousel
            }
            .padding(.horizontal, Tokens.space20)
            .padding(.bottom, Tokens.space20)
        }
    }

    var productCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Tokens.space8) {
                ForEach(carouselProducts) { product in
                    productCard(product)
                }
            }
        }
        .scrollClipDisabled()
    }

    func productCard(_ product: VibeCarouselProduct) -> some View {
        Group {
            if let image = UIImage(contentsOfFile: product.filePath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                    .fill(.white.opacity(0.2))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(.white.opacity(0.8))
                    }
            }
        }
        .frame(width: 134.4, height: 134.4)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.radius20, style: .continuous)
                .stroke(.white.opacity(0.16), lineWidth: 0.5)
        )
        .shadow(
            color: Tokens.ShopClient.shadowMColor,
            radius: Tokens.ShopClient.shadowMRadius,
            x: 0,
            y: Tokens.ShopClient.shadowMY
        )
    }
}

private struct VibeCarouselProduct: Identifiable {
    let id: String
    let filePath: String
}

private struct LoopingVideoBackground: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> LoopingVideoContainerView {
        let view = LoopingVideoContainerView()
        view.configure(with: url)
        return view
    }

    func updateUIView(_ uiView: LoopingVideoContainerView, context: Context) {
        uiView.configure(with: url)
    }

    static func dismantleUIView(_ uiView: LoopingVideoContainerView, coordinator: ()) {
        uiView.stop()
    }
}

private final class LoopingVideoContainerView: UIView {
    private let queuePlayer = AVQueuePlayer()
    private var looper: AVPlayerLooper?
    private var videoLayer: AVPlayerLayer?
    private var currentURL: URL?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Overscan slightly so encoded edge pixels never show.
        videoLayer?.frame = bounds.insetBy(dx: -2, dy: -2)
    }

    func configure(with url: URL) {
        guard currentURL != url else {
            if queuePlayer.timeControlStatus != .playing {
                queuePlayer.play()
            }
            return
        }

        currentURL = url
        queuePlayer.pause()
        queuePlayer.removeAllItems()

        let item = AVPlayerItem(url: url)
        looper = AVPlayerLooper(player: queuePlayer, templateItem: item)

        if videoLayer == nil {
            let layer = AVPlayerLayer(player: queuePlayer)
            layer.videoGravity = .resizeAspectFill
            self.layer.addSublayer(layer)
            videoLayer = layer
        } else {
            videoLayer?.player = queuePlayer
        }

        queuePlayer.isMuted = true
        queuePlayer.play()
    }

    func stop() {
        queuePlayer.pause()
        queuePlayer.removeAllItems()
        looper = nil
        currentURL = nil
    }
}

