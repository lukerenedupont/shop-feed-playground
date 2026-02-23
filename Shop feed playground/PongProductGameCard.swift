//
//  PongProductGameCard.swift
//  Shop feed playground
//
//  Pong-like product game card with thumb-controlled paddle.
//

import Combine
import SwiftUI

struct PongProductGameCard: View {
    @State private var paddleProgress: CGFloat = 0.5
    @State private var ballPosition: CGPoint = .zero
    @State private var ballVelocity: CGVector = .zero
    @State private var removedBrickIDs: Set<Int> = []
    @State private var isRoundActive: Bool = false
    @State private var pendingRoundReset: Bool = false
    @State private var lastTickDate: Date?
    @State private var statusMessage: String = "Slide to move your paddle"
    @State private var hasInitialized: Bool = false
    @State private var isVisible: Bool = false
    @State private var serveDirection: CGFloat = 1

    private let gameTimer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
    private let brickImagePool: [String] = [
        "SimilarShoe1", "SimilarShoe2", "SimilarShoe3", "SimilarShoe4",
        "SimilarShoe5", "SimilarShoe6", "SimilarShoe7", "SimilarShoe8",
    ]
    private let brickPricePool: [String] = ["$96", "$108", "$132", "$118", "$145", "$124", "$88", "$156"]
    private var bricks: [PongBrick] {
        (0..<PongLayout.brickCount).map { index in
            PongBrick(
                id: index,
                imageName: brickImagePool[index % brickImagePool.count],
                price: brickPricePool[index % brickPricePool.count]
            )
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: 0x1D2435), Color(hex: 0x141A27), Color(hex: 0x0D111A)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    LinearGradient(
                        stops: [
                            .init(color: .white.opacity(0.08), location: 0.0),
                            .init(color: .clear, location: 0.38),
                            .init(color: .black.opacity(0.22), location: 1.0),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(.white.opacity(0.06), lineWidth: 0.5)
                )

            CardHeader(subtitle: "Mini game", title: "Pong shop", lightText: true)
                .allowsHitTesting(false)

            GeometryReader { proxy in
                let metrics = PongMetrics(size: proxy.size)

                ZStack {
                    ForEach(bricks) { brick in
                        if !removedBrickIDs.contains(brick.id) {
                            let rect = metrics.brickRect(for: brick.id)
                            FeedProductCard(
                                imageName: brick.imageName,
                                size: rect.width,
                                cornerRadius: Tokens.radius12,
                                priceBadgeText: nil,
                                showsFavorite: false
                            )
                            .position(x: rect.midX, y: rect.midY)
                            .transition(.scale(scale: 0.82).combined(with: .opacity))
                        }
                    }

                    Capsule(style: .continuous)
                        .fill(.white)
                        .frame(width: PongLayout.paddleWidth, height: PongLayout.paddleHeight)
                        .position(x: metrics.paddleCenterX(for: paddleProgress), y: metrics.paddleCenterY)
                        .shadow(color: .black.opacity(0.26), radius: 10, x: 0, y: 4)

                    Circle()
                        .fill(.white)
                        .frame(width: PongLayout.ballRadius * 2, height: PongLayout.ballRadius * 2)
                        .position(ballPosition)
                        .shadow(color: .white.opacity(0.45), radius: 10, x: 0, y: 0)

                    VStack(spacing: 8) {
                        thumbTrack(metrics: metrics)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, PongLayout.thumbBottomPadding)

                    HStack {
                        Spacer(minLength: 0)
                        Text(statusMessage)
                            .shopTextStyle(.captionBold)
                            .foregroundStyle(.white.opacity(0.86))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(.white.opacity(0.12))
                            )
                    }
                    .padding(.top, 22)
                    .padding(.trailing, Tokens.space20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
                .onAppear {
                    isVisible = true
                    guard !hasInitialized else { return }
                    hasInitialized = true
                    preparePausedState(metrics: metrics, resetBoard: true, message: "Tap once to start")
                }
                .onDisappear {
                    isVisible = false
                    lastTickDate = nil
                }
                .onReceive(gameTimer) { now in
                    tick(now: now, metrics: metrics)
                }
                .simultaneousGesture(
                    TapGesture(count: 1)
                        .onEnded {
                            handleCardTap(metrics: metrics)
                        }
                )
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

private extension PongProductGameCard {
    func thumbTrack(metrics: PongMetrics) -> some View {
        let knobTravel = PongLayout.thumbTrackWidth - PongLayout.thumbKnobSize
        let controlSurfaceWidth = PongLayout.thumbTrackWidth + PongLayout.thumbHitPadding * 2

        return ZStack {
            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(.white.opacity(0.18))

                Capsule(style: .continuous)
                    .fill(.white.opacity(0.24))
                    .frame(width: PongLayout.thumbKnobSize + knobTravel * paddleProgress)

                Circle()
                    .fill(.white)
                    .frame(width: PongLayout.thumbKnobSize, height: PongLayout.thumbKnobSize)
                    .overlay(
                        Circle()
                            .stroke(.black.opacity(0.08), lineWidth: 0.5)
                    )
                    .offset(x: knobTravel * paddleProgress)
                    .shadow(color: .black.opacity(0.22), radius: 6, x: 0, y: 2)
            }
            .frame(width: PongLayout.thumbTrackWidth, height: PongLayout.thumbTrackHeight)
        }
        .frame(width: controlSurfaceWidth, height: PongLayout.thumbTrackHeight + 24)
        .contentShape(Rectangle())
        .highPriorityGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let xInTrack = value.location.x - PongLayout.thumbHitPadding
                    updatePaddleProgress(from: xInTrack, metrics: metrics)
                }
        )
        .simultaneousGesture(
            SpatialTapGesture()
                .onEnded { value in
                    let xInTrack = value.location.x - PongLayout.thumbHitPadding
                    updatePaddleProgress(from: xInTrack, metrics: metrics)
                }
        )
    }

    func updatePaddleProgress(from locationX: CGFloat, metrics: PongMetrics) {
        let normalized = (locationX - PongLayout.thumbKnobSize / 2) / (PongLayout.thumbTrackWidth - PongLayout.thumbKnobSize)
        paddleProgress = min(max(normalized, 0), 1)

        if !isRoundActive {
            ballPosition = metrics.restingBallPosition(for: paddleProgress)
        }
    }

    func launchBall(metrics: PongMetrics) {
        isRoundActive = true
        lastTickDate = nil

        ballPosition = metrics.restingBallPosition(for: paddleProgress)
        ballVelocity = CGVector(dx: 180 * serveDirection, dy: -268)
        serveDirection *= -1

        let remaining = max(0, bricks.count - removedBrickIDs.count)
        statusMessage = "\(remaining) targets left"
    }

    func preparePausedState(metrics: PongMetrics, resetBoard: Bool, message: String) {
        isRoundActive = false
        pendingRoundReset = resetBoard
        lastTickDate = nil
        ballVelocity = .zero
        statusMessage = message
        if resetBoard {
            removedBrickIDs.removeAll()
        }
        ballPosition = metrics.restingBallPosition(for: paddleProgress)
    }

    func handleCardTap(metrics: PongMetrics) {
        guard !isRoundActive else { return }
        if pendingRoundReset {
            removedBrickIDs.removeAll()
            pendingRoundReset = false
        }
        Haptics.light()
        launchBall(metrics: metrics)
    }

    func tick(now: Date, metrics: PongMetrics) {
        guard isVisible else { return }

        if !isRoundActive {
            ballPosition = metrics.restingBallPosition(for: paddleProgress)
            return
        }

        guard let previousTick = lastTickDate else {
            lastTickDate = now
            return
        }

        let dt = CGFloat(min(max(now.timeIntervalSince(previousTick), 1.0 / 120.0), 1.0 / 40.0))
        lastTickDate = now

        var nextPosition = CGPoint(
            x: ballPosition.x + ballVelocity.dx * dt,
            y: ballPosition.y + ballVelocity.dy * dt
        )
        var nextVelocity = ballVelocity

        if nextPosition.x <= metrics.minBallX {
            nextPosition.x = metrics.minBallX
            nextVelocity.dx = abs(nextVelocity.dx)
        } else if nextPosition.x >= metrics.maxBallX {
            nextPosition.x = metrics.maxBallX
            nextVelocity.dx = -abs(nextVelocity.dx)
        }

        if nextPosition.y <= metrics.minBallY {
            nextPosition.y = metrics.minBallY
            nextVelocity.dy = abs(nextVelocity.dy)
        }

        let paddleRect = metrics.paddleRect(for: paddleProgress)
        let expandedPaddle = paddleRect.insetBy(dx: -PongLayout.ballRadius, dy: -PongLayout.ballRadius)
        if nextVelocity.dy > 0, expandedPaddle.contains(nextPosition), ballPosition.y <= paddleRect.minY + PongLayout.ballRadius {
            nextPosition.y = paddleRect.minY - PongLayout.ballRadius
            let impact = (nextPosition.x - paddleRect.midX) / (paddleRect.width / 2)
            let clampedImpact = min(max(impact, -1), 1)
            let speed = min(max(hypot(nextVelocity.dx, nextVelocity.dy) * 1.02, 248), 430)
            nextVelocity.dx = clampedImpact * speed * 0.74
            nextVelocity.dy = -abs(speed * 0.80)
            Haptics.soft(intensity: 0.66)
        }

        if nextPosition.y >= metrics.lossY {
            Haptics.notify(.warning)
            preparePausedState(metrics: metrics, resetBoard: false, message: "Missed - tap to serve")
            return
        }

        if let hit = firstIntersectingBrick(at: nextPosition, metrics: metrics) {
            removedBrickIDs.insert(hit.id)
            nextVelocity = reflectedVelocity(for: nextVelocity, at: nextPosition, in: hit.rect)
            Haptics.selection()

            let remaining = max(0, bricks.count - removedBrickIDs.count)
            if remaining == 0 {
                Haptics.notify(.success)
                preparePausedState(metrics: metrics, resetBoard: true, message: "Board clear - tap to restart")
                return
            } else {
                statusMessage = "\(remaining) targets left"
            }
        }

        ballPosition = nextPosition
        ballVelocity = nextVelocity
    }

    func firstIntersectingBrick(at center: CGPoint, metrics: PongMetrics) -> (id: Int, rect: CGRect)? {
        for brick in bricks where !removedBrickIDs.contains(brick.id) {
            let rect = metrics.brickRect(for: brick.id)
            if intersectsCircle(center: center, radius: PongLayout.ballRadius, rect: rect) {
                return (brick.id, rect)
            }
        }
        return nil
    }

    func intersectsCircle(center: CGPoint, radius: CGFloat, rect: CGRect) -> Bool {
        let closestX = min(max(center.x, rect.minX), rect.maxX)
        let closestY = min(max(center.y, rect.minY), rect.maxY)
        let dx = center.x - closestX
        let dy = center.y - closestY
        return (dx * dx + dy * dy) <= (radius * radius)
    }

    func reflectedVelocity(for velocity: CGVector, at center: CGPoint, in rect: CGRect) -> CGVector {
        var reflected = velocity
        let nearestX = min(max(center.x, rect.minX), rect.maxX)
        let nearestY = min(max(center.y, rect.minY), rect.maxY)
        let dx = center.x - nearestX
        let dy = center.y - nearestY

        if abs(dx) > abs(dy) {
            reflected.dx = -reflected.dx
        } else {
            reflected.dy = -reflected.dy
        }

        return reflected
    }
}

private enum PongLayout {
    static let wallInset: CGFloat = 18
    static let playTop: CGFloat = 104
    static let brickCount: Int = 20
    static let brickColumns: Int = 5
    static let brickSize: CGFloat = 52
    static let brickSpacing: CGFloat = 6
    static let brickTop: CGFloat = 142

    static let paddleWidth: CGFloat = 108
    static let paddleHeight: CGFloat = 14

    static let ballRadius: CGFloat = 8

    static let thumbTrackWidth: CGFloat = 236
    static let thumbTrackHeight: CGFloat = 42
    static let thumbKnobSize: CGFloat = 34
    static let thumbHitPadding: CGFloat = 28
    static let thumbBottomPadding: CGFloat = 74

    static let relaunchDelay: TimeInterval = 0.8
}

private struct PongMetrics {
    let size: CGSize

    var minBallX: CGFloat { PongLayout.wallInset + PongLayout.ballRadius }
    var maxBallX: CGFloat { size.width - PongLayout.wallInset - PongLayout.ballRadius }
    var minBallY: CGFloat { PongLayout.playTop + PongLayout.ballRadius }
    var lossY: CGFloat {
        size.height - PongLayout.thumbBottomPadding - PongLayout.thumbTrackHeight - 2
    }

    var paddleCenterY: CGFloat {
        size.height - PongLayout.thumbBottomPadding - PongLayout.thumbTrackHeight - 30
    }

    func paddleCenterX(for progress: CGFloat) -> CGFloat {
        let minX = PongLayout.wallInset + PongLayout.paddleWidth / 2
        let maxX = size.width - PongLayout.wallInset - PongLayout.paddleWidth / 2
        return minX + (maxX - minX) * progress
    }

    func paddleRect(for progress: CGFloat) -> CGRect {
        let centerX = paddleCenterX(for: progress)
        return CGRect(
            x: centerX - PongLayout.paddleWidth / 2,
            y: paddleCenterY - PongLayout.paddleHeight / 2,
            width: PongLayout.paddleWidth,
            height: PongLayout.paddleHeight
        )
    }

    func restingBallPosition(for progress: CGFloat) -> CGPoint {
        CGPoint(
            x: paddleCenterX(for: progress),
            y: paddleCenterY - PongLayout.paddleHeight / 2 - PongLayout.ballRadius - 4
        )
    }

    func brickRect(for index: Int) -> CGRect {
        let row = index / PongLayout.brickColumns
        let column = index % PongLayout.brickColumns

        let totalWidth = CGFloat(PongLayout.brickColumns) * PongLayout.brickSize +
            CGFloat(PongLayout.brickColumns - 1) * PongLayout.brickSpacing
        let startX = (size.width - totalWidth) / 2
        let x = startX + CGFloat(column) * (PongLayout.brickSize + PongLayout.brickSpacing)
        let y = PongLayout.brickTop + CGFloat(row) * (PongLayout.brickSize + PongLayout.brickSpacing)

        return CGRect(x: x, y: y, width: PongLayout.brickSize, height: PongLayout.brickSize)
    }
}

private struct PongBrick: Identifiable {
    let id: Int
    let imageName: String
    let price: String
}
