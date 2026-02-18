//
//  BlankTopCard.swift
//  Shop feed playground
//
//  Top feed card with full-bleed tap-to-toggle background video.
//

import AVFoundation
import SwiftUI
import UIKit

struct BlankTopCard: View {
    @State private var tapRequestID: Int = 0

    private let backgroundVideoURL = URL(fileURLWithPath: "/Users/lukedupont/Downloads/58083315-c027-4d5b-81cd-c6608b6fe737-video.mp4")
    private let cornerRadius: CGFloat = Tokens.radiusCard
    // Use uniform zoom so the video can crop/fill without distortion.
    private let videoScale: CGFloat = 1.34

    private var hasLocalVideo: Bool {
        FileManager.default.fileExists(atPath: backgroundVideoURL.path)
    }

    var body: some View {
        ZStack {
            if hasLocalVideo {
                BlankTopTapToPlayVideoBackground(url: backgroundVideoURL, tapRequestID: tapRequestID)
                    .scaleEffect(videoScale)
            } else {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Tokens.ShopClient.bgFillInverse)
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(
            color: Tokens.ShopClient.shadowMColor,
            radius: Tokens.ShopClient.shadowMRadius,
            x: 0,
            y: Tokens.ShopClient.shadowMY
        )
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .onTapGesture {
            Haptics.light()
            tapRequestID += 1
        }
    }
}

private struct BlankTopTapToPlayVideoBackground: UIViewRepresentable {
    let url: URL
    let tapRequestID: Int

    func makeUIView(context: Context) -> BlankTopTapToPlayVideoContainerView {
        let view = BlankTopTapToPlayVideoContainerView()
        view.configure(with: url)
        return view
    }

    func updateUIView(_ uiView: BlankTopTapToPlayVideoContainerView, context: Context) {
        uiView.configure(with: url)
        uiView.toggleIfRequested(requestID: tapRequestID)
    }

    static func dismantleUIView(_ uiView: BlankTopTapToPlayVideoContainerView, coordinator: ()) {
        uiView.stop()
    }
}

private final class BlankTopTapToPlayVideoContainerView: UIView {
    private enum PlaybackState {
        case closed
        case opening
        case open
        case closing
    }

    private let player = AVPlayer()
    private var videoLayer: AVPlayerLayer?
    private var currentURL: URL?
    private var currentTapRequestID: Int = 0
    private var playbackState: PlaybackState = .closed
    private var endObserver: NSObjectProtocol?
    private var reverseDisplayLink: CADisplayLink?
    private var reverseSeekInFlight = false
    private let playbackRate: Float = 2.0
    private var reversePlaybackRate: Double { Double(playbackRate) }
    private var lastReverseTimestamp: CFTimeInterval?

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
        // Overscan a little to avoid source edge lines.
        videoLayer?.frame = bounds.insetBy(dx: -2, dy: -2)
    }

    func configure(with url: URL) {
        guard currentURL != url else { return }

        currentURL = url
        player.pause()
        stopReverseStepping()
        endObserver.map(NotificationCenter.default.removeObserver)
        endObserver = nil
        reverseSeekInFlight = false

        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.actionAtItemEnd = .pause

        if videoLayer == nil {
            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspectFill
            self.layer.addSublayer(layer)
            videoLayer = layer
        } else {
            videoLayer?.player = player
        }

        player.isMuted = true
        player.seek(to: .zero)
        playbackState = .closed

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.player.pause()
            self?.playbackState = .open
        }
    }

    func toggleIfRequested(requestID: Int) {
        guard requestID != currentTapRequestID else { return }
        currentTapRequestID = requestID

        switch playbackState {
        case .closed, .closing:
            playForward()
        case .open, .opening:
            playReverse()
        }
    }

    private func playForward() {
        stopReverseStepping()
        reverseSeekInFlight = false

        if playbackState == .closed {
            player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        }

        playbackState = .opening
        player.playImmediately(atRate: playbackRate)
    }

    private func playReverse() {
        player.pause()

        // If we're fully open, seek to the end to ensure a complete mirrored close.
        if playbackState == .open {
            let duration = resolvedDurationSeconds
            if duration > 0 {
                let endTime = CMTime(seconds: duration, preferredTimescale: 600)
                player.seek(to: endTime, toleranceBefore: .zero, toleranceAfter: .zero)
            }
        }

        playbackState = .closing
        startReverseStepping()
    }

    private func startReverseStepping() {
        stopReverseStepping()
        let link = CADisplayLink(target: self, selector: #selector(handleReverseTick(_:)))
        link.preferredFramesPerSecond = 60
        link.add(to: .main, forMode: .common)
        reverseDisplayLink = link
        lastReverseTimestamp = nil
    }

    private func stopReverseStepping() {
        reverseDisplayLink?.invalidate()
        reverseDisplayLink = nil
        lastReverseTimestamp = nil
    }

    private var resolvedDurationSeconds: Double {
        guard let item = player.currentItem else { return 0 }

        let itemSeconds = item.duration.seconds
        if itemSeconds.isFinite, itemSeconds > 0 {
            return itemSeconds
        }

        let assetSeconds = item.asset.duration.seconds
        if assetSeconds.isFinite, assetSeconds > 0 {
            return assetSeconds
        }

        return 0
    }

    @objc private func handleReverseTick(_ displayLink: CADisplayLink) {
        guard playbackState == .closing else { return }
        guard !reverseSeekInFlight else { return }

        let currentSeconds = player.currentTime().seconds
        guard currentSeconds.isFinite else { return }

        if lastReverseTimestamp == nil {
            lastReverseTimestamp = displayLink.timestamp
            return
        }

        let dt = max(0, min(displayLink.timestamp - (lastReverseTimestamp ?? displayLink.timestamp), 0.1))
        lastReverseTimestamp = displayLink.timestamp

        let nextSeconds = max(0, currentSeconds - dt * reversePlaybackRate)
        let target = CMTime(seconds: nextSeconds, preferredTimescale: 600)

        reverseSeekInFlight = true
        player.seek(to: target, toleranceBefore: .zero, toleranceAfter: .zero) { [weak self] _ in
            guard let self else { return }
            self.reverseSeekInFlight = false

            if nextSeconds <= 0.0001 {
                self.stopReverseStepping()
                self.playbackState = .closed
            }
        }
    }

    func stop() {
        stopReverseStepping()
        player.pause()
        player.replaceCurrentItem(with: nil)
        endObserver.map(NotificationCenter.default.removeObserver)
        endObserver = nil
        currentURL = nil
        currentTapRequestID = 0
        playbackState = .closed
        reverseSeekInFlight = false
    }
}

