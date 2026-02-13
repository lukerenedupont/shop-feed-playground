//
//  ScratchOfferCard.swift
//  Shop feed playground
//
//  Scratch-to-reveal offer card based on Figma states:
//  1) Full cover image + "Scratch to claim"
//  2) Partial scratch exposing blue offer layer
//  3) Fully revealed offer with timer, CTA, and product row
//

import SwiftUI
import Combine

struct ScratchOfferCard: View {
    let offerText: String
    let durationSeconds: Int
    let onClaimPress: (() -> Void)?

    @State private var scratchedPercent: CGFloat = 0
    @State private var revealComplete: Bool = false
    @State private var remainingSeconds: Int

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(
        offerText: String = "20% off on orders over $25.00",
        durationSeconds: Int = 90,
        onClaimPress: (() -> Void)? = nil
    ) {
        self.offerText = offerText
        self.durationSeconds = durationSeconds
        self.onClaimPress = onClaimPress
        _remainingSeconds = State(initialValue: durationSeconds)
    }

    private var isExpired: Bool {
        remainingSeconds <= 0
    }

    var body: some View {
        ScratchSurface(
            scratchedPercent: $scratchedPercent,
            revealComplete: $revealComplete,
            remainingSeconds: remainingSeconds,
            isExpired: isExpired,
            offerText: offerText
        ) {
            if let onClaimPress {
                onClaimPress()
            } else {
                print("Claim offer tapped")
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .shadow(color: Tokens.shadowColor400, radius: 40, x: 0, y: 8)
        .onReceive(timer) { _ in
            guard remainingSeconds > 0 else { return }
            remainingSeconds -= 1
        }
    }
}

// MARK: - Scratch Surface

private struct ScratchSurface: View {
    @Binding var scratchedPercent: CGFloat
    @Binding var revealComplete: Bool

    let remainingSeconds: Int
    let isExpired: Bool
    let offerText: String
    let onClaimPress: () -> Void

    @State private var points: [CGPoint] = []
    @State private var revealedCells: Set<Int> = []
    @State private var surfaceSize: CGSize = .zero
    @State private var lastSampledPoint: CGPoint?
    @State private var scratchLayerOpacity: Double = 1
    @State private var scratchSessionStart: Date?
    @State private var accumulatedScratchDuration: TimeInterval = 0
    @State private var showConfetti: Bool = false
    @State private var confettiProgress: CGFloat = 0
    @State private var dragIntent: ScratchDragIntent = .undecided

    // Coarse grid for cheap reveal percentage approximation.
    private let cols = 30
    private let rows = 50
    private let scratchRadius: CGFloat = 24
    private let sampleDistance: CGFloat = 10
    private let revealThreshold: CGFloat = 0.35
    private let scratchDurationThreshold: TimeInterval = 2.0

    private static let confettiPieces: [ConfettiPiece] = [
        .init(x: 0.14, y: 0.16, driftX: -18, driftY: -52, size: 7, color: Color(hex: 0xF59E0B)),
        .init(x: 0.28, y: 0.14, driftX: -10, driftY: -58, size: 6, color: Color(hex: 0x22C55E)),
        .init(x: 0.44, y: 0.13, driftX: -4, driftY: -56, size: 8, color: Color(hex: 0xE11D48)),
        .init(x: 0.58, y: 0.13, driftX: 7, driftY: -60, size: 7, color: Color(hex: 0xA855F7)),
        .init(x: 0.74, y: 0.15, driftX: 12, driftY: -52, size: 6, color: Color(hex: 0x3B82F6)),
        .init(x: 0.86, y: 0.17, driftX: 20, driftY: -48, size: 8, color: Color(hex: 0xF97316)),
    ]

    private var canScratch: Bool {
        !isExpired && !revealComplete
    }

    private var canClaim: Bool {
        revealComplete && !isExpired
    }

    private enum ScratchDragIntent {
        case undecided
        case scratch
        case scroll
    }

    var body: some View {
        GeometryReader { geo in
            let size = geo.size

            ZStack {
                OfferRevealContent(
                    remainingSeconds: remainingSeconds,
                    offerText: offerText,
                    claimEnabled: canClaim,
                    onClaimPress: onClaimPress
                )

                if scratchLayerOpacity > 0.001 {
                    scratchLayer
                }

                if showConfetti {
                    confettiOverlay(size: size)
                }

                if isExpired {
                    ExpiredOfferOverlay {
                        print("See more offers tapped")
                    }
                }
            }
            .onAppear {
                if surfaceSize == .zero { surfaceSize = size }
            }
            .onChange(of: size) { _, newSize in
                surfaceSize = newSize
            }
            .simultaneousGesture(
                // Keep ScrollView responsive by classifying intent early.
                DragGesture(minimumDistance: 8, coordinateSpace: .local)
                    .onChanged { value in
                        guard canScratch else { return }

                        if dragIntent == .undecided {
                            let dx = value.translation.width
                            let dy = value.translation.height
                            let distance = hypot(dx, dy)
                            guard distance >= 12 else { return }
                            dragIntent = abs(dy) > abs(dx) * 1.12 ? .scroll : .scratch
                        }

                        guard dragIntent == .scratch else { return }
                        handleScratchChange(location: value.location)
                    }
                    .onEnded { _ in
                        finishScratchSession()
                        dragIntent = .undecided
                    }
            )
        }
    }

    private var scratchLayer: some View {
        GeometryReader { layerGeo in
            let width = layerGeo.size.width
            let height = layerGeo.size.height
            let scaleX = width / Tokens.cardWidth
            let scaleY = height / Tokens.cardHeight

            ZStack {
                Image("ScratchAPCHero")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()

                Text("A gift from")
                    .font(.system(size: 36, weight: .semibold))
                    .tracking(-1.15)
                    .foregroundColor(.white)
                    .frame(width: 192 * scaleX)
                    .position(x: width * 0.5, y: 284 * scaleY)

                Image("ScratchAPCLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 203 * scaleX, height: 66 * scaleY)
                    // Optical centering correction for alpha-bounds bias.
                    .position(x: width * 0.5 + (3 * scaleX), y: 348 * scaleY)

                Text("Scratch to claim")
                    .font(.system(size: Tokens.bodySize, weight: .regular))
                    .tracking(0.15)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                            .fill(Color.black.opacity(0.32))
                    )
                    .position(x: width * 0.5, y: 428 * scaleY)
            }
        }
        .overlay {
            // We punch transparent circles in this top layer to reveal
            // the blue offer content underneath.
            Canvas { context, _ in
                guard !points.isEmpty else { return }
                context.blendMode = .clear
                for point in points {
                    let rect = CGRect(
                        x: point.x - scratchRadius,
                        y: point.y - scratchRadius,
                        width: scratchRadius * 2,
                        height: scratchRadius * 2
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(.black))
                }
            }
        }
        .compositingGroup()
        .opacity(scratchLayerOpacity)
        .animation(.easeOut(duration: 0.28), value: scratchLayerOpacity)
    }

    private func confettiOverlay(size: CGSize) -> some View {
        ZStack {
            ForEach(Array(Self.confettiPieces.enumerated()), id: \.offset) { _, piece in
                Circle()
                    .fill(piece.color)
                    .frame(width: piece.size, height: piece.size)
                    .position(
                        x: piece.x * size.width + piece.driftX * confettiProgress,
                        y: piece.y * size.height + piece.driftY * confettiProgress
                    )
                    .opacity(1 - confettiProgress)
            }
        }
        .allowsHitTesting(false)
    }

    private func handleScratchChange(location: CGPoint) {
        guard surfaceSize.width > 0, surfaceSize.height > 0 else { return }

        if scratchSessionStart == nil {
            scratchSessionStart = Date()
        }

        let point = clamped(location: location, in: surfaceSize)
        if shouldSample(point: point) {
            points.append(point)
            lastSampledPoint = point
            markCells(around: point)
        }

        let totalCells = rows * cols
        scratchedPercent = CGFloat(revealedCells.count) / CGFloat(totalCells)

        // Reveal gate: enough area scratched, or enough user effort time.
        let elapsed = accumulatedScratchDuration + (Date().timeIntervalSince(scratchSessionStart ?? Date()))
        if scratchedPercent >= revealThreshold || elapsed >= scratchDurationThreshold {
            completeReveal()
        }
    }

    private func finishScratchSession() {
        if let start = scratchSessionStart {
            accumulatedScratchDuration += Date().timeIntervalSince(start)
        }
        scratchSessionStart = nil
        lastSampledPoint = nil
    }

    private func completeReveal() {
        guard !revealComplete else { return }
        revealComplete = true
        scratchedPercent = max(scratchedPercent, revealThreshold)
        finishScratchSession()

        withAnimation(.easeOut(duration: 0.32)) {
            scratchLayerOpacity = 0
        }
        triggerConfetti()
    }

    private func triggerConfetti() {
        showConfetti = true
        confettiProgress = 0
        withAnimation(.easeOut(duration: 0.8)) {
            confettiProgress = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
            showConfetti = false
            confettiProgress = 0
        }
    }

    private func shouldSample(point: CGPoint) -> Bool {
        guard let previous = lastSampledPoint else { return true }
        let dx = point.x - previous.x
        let dy = point.y - previous.y
        return hypot(dx, dy) >= sampleDistance
    }

    private func clamped(location: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: min(max(location.x, 0), size.width),
            y: min(max(location.y, 0), size.height)
        )
    }

    private func markCells(around point: CGPoint) {
        let cellWidth = surfaceSize.width / CGFloat(cols)
        let cellHeight = surfaceSize.height / CGFloat(rows)
        guard cellWidth > 0, cellHeight > 0 else { return }

        let col = Int(point.x / cellWidth)
        let row = Int(point.y / cellHeight)
        let radiusCols = Int(ceil(scratchRadius / cellWidth))
        let radiusRows = Int(ceil(scratchRadius / cellHeight))

        for r in max(0, row - radiusRows)...min(rows - 1, row + radiusRows) {
            for c in max(0, col - radiusCols)...min(cols - 1, col + radiusCols) {
                let center = CGPoint(
                    x: (CGFloat(c) + 0.5) * cellWidth,
                    y: (CGFloat(r) + 0.5) * cellHeight
                )
                if hypot(center.x - point.x, center.y - point.y) <= scratchRadius {
                    revealedCells.insert(r * cols + c)
                }
            }
        }
    }
}

// MARK: - Revealed Offer Content

private struct OfferRevealContent: View {
    let remainingSeconds: Int
    let offerText: String
    let claimEnabled: Bool
    let onClaimPress: () -> Void

    var body: some View {
        ZStack {
            Color(hex: 0x1473E8)

            VStack(spacing: 0) {
                CountdownHeader(remainingSeconds: remainingSeconds)
                    .frame(height: 48)

                Spacer(minLength: 0)

                Text(offerText)
                    .font(.system(size: 50, weight: .semibold))
                    .tracking(-1.15)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 330)
                    .lineLimit(2)

                ClaimButton(
                    title: "Shop A.P.C.",
                    isEnabled: claimEnabled,
                    action: onClaimPress
                )
                .padding(.top, 36)

                Spacer(minLength: 18)

                HStack(spacing: 8) {
                    productTile("ScratchAPCProduct1")
                    productTile("ScratchAPCProduct2")
                    productTile("ScratchAPCProduct3")
                    productTile("ScratchAPCProduct4")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 24)
                .padding(.bottom, 12)
            }
        }
    }

    private func productTile(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 136, height: 136)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color(hex: 0xECEDEF))
            )
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

// MARK: - Countdown Header

private struct CountdownHeader: View {
    let remainingSeconds: Int

    var body: some View {
        ZStack {
            Color(hex: 0x0064D7)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.12))
                        .frame(height: 1),
                    alignment: .bottom
                )

            Text(format(seconds: remainingSeconds))
                .font(.system(size: Tokens.bodySize, weight: .medium, design: .monospaced))
                .tracking(0.15)
                .foregroundColor(.white)
        }
    }

    private func format(seconds: Int) -> String {
        let clamped = max(seconds, 0)
        let hours = clamped / 3600
        let minutes = (clamped % 3600) / 60
        let secs = clamped % 60
        return String(format: "%02d : %02d : %02d", hours, minutes, secs)
    }
}

// MARK: - Claim Button

private struct ClaimButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: Tokens.bodySize, weight: .semibold))
                .tracking(Tokens.bodyTracking)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.black.opacity(isEnabled ? 0.88 : 0.5))
                )
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Expired State

private struct ExpiredOfferOverlay: View {
    let onSeeMore: () -> Void

    var body: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(Color.black.opacity(0.38))
            .overlay {
                VStack(spacing: Tokens.space12) {
                    Text("Offer expired")
                        .font(.system(size: 24, weight: .semibold))
                        .tracking(-0.6)
                        .foregroundColor(.white)

                    Button(action: onSeeMore) {
                        Text("See more offers")
                            .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                            .tracking(Tokens.cozyTracking)
                            .foregroundColor(.black)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(.white)
                            )
                    }
                }
            }
            .allowsHitTesting(true)
    }
}

private struct ConfettiPiece {
    let x: CGFloat
    let y: CGFloat
    let driftX: CGFloat
    let driftY: CGFloat
    let size: CGFloat
    let color: Color
}

