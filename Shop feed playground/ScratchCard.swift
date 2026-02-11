//
//  ScratchCard.swift
//  Shop feed playground
//
//  Created by Luke Dupont on 2/11/26.
//

import SwiftUI
import Combine

// MARK: - Scratch Card

struct ScratchCard: View {
    @State private var lines: [[CGPoint]] = []
    @State private var isRevealed = false
    @State private var scratchPercentage: CGFloat = 0
    @State private var cardSize: CGSize = .zero

    private let scratchLineWidth: CGFloat = 60
    private let revealThreshold: CGFloat = 0.35

    @State private var hasStartedScratching = false

    var body: some View {
        ZStack {
            // Bottom layer: revealed offer content (hidden until scratching begins)
            if hasStartedScratching || isRevealed {
                RevealedContent()
            }

            // Top layer: scratchable photo overlay
            if !isRevealed {
                ZStack {
                    ScratchCover()

                    // Scratch strokes erase the cover
                    Canvas { context, size in
                        for line in lines {
                            guard line.count > 1 else { continue }
                            var path = Path()
                            path.addLines(line)
                            context.stroke(
                                path,
                                with: .color(.white),
                                style: StrokeStyle(
                                    lineWidth: scratchLineWidth,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                        }
                    }
                    .blendMode(.destinationOut)
                }
                .compositingGroup()
                .transition(.opacity)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !hasStartedScratching {
                                hasStartedScratching = true
                            }
                            let point = value.location
                            if value.translation == .zero {
                                lines.append([point])
                            } else {
                                guard !lines.isEmpty else { return }
                                lines[lines.count - 1].append(point)
                            }
                            updateScratchPercentage()
                        }
                        .onEnded { _ in
                            if scratchPercentage >= revealThreshold {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    isRevealed = true
                                }
                            }
                        }
                )
            }
        }
        .mask(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { cardSize = geo.size }
            }
        )
    }

    private func updateScratchPercentage() {
        guard cardSize.width > 0, cardSize.height > 0 else { return }
        let totalArea = cardSize.width * cardSize.height
        var scratchedArea: CGFloat = 0
        for line in lines {
            guard line.count > 1 else { continue }
            for i in 1..<line.count {
                let dx = line[i].x - line[i - 1].x
                let dy = line[i].y - line[i - 1].y
                let distance = sqrt(dx * dx + dy * dy)
                scratchedArea += distance * scratchLineWidth
            }
        }
        scratchPercentage = min(scratchedArea / totalArea, 1.0)
    }
}

// MARK: - Scratch Cover (State 1: Unscratched)

private struct ScratchCover: View {
    var body: some View {
        // Photo background fills entire card
        Image("APCPhoto")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .overlay {
                // Dark scrim for text readability
                VStack {
                    Spacer()
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)
                }
            }
            .overlay {
                // Content
                VStack(spacing: 8) {
                    Spacer()

                    Text("A gift from")
                        .font(.system(size: 36, weight: .semibold))
                        .tracking(-1.15)
                        .foregroundColor(.white)

                    Text("A.P.C.")
                        .font(.system(size: 56, weight: .bold))
                        .tracking(-1.5)
                        .foregroundColor(.white)

                    Spacer().frame(height: 16)

                    // "Scratch to claim" pill
                    Text("Scratch to claim")
                        .font(.system(size: 16, weight: .medium))
                        .tracking(0.15)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.black.opacity(0.2))
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                )
                        )

                    Spacer().frame(height: 40)
                }
            }
    }
}

// MARK: - Revealed Content (State 3: Fully Revealed)

private struct RevealedContent: View {
    @State private var timeRemaining: Int = 1 * 3600 + 2 * 60 + 3 // 01:02:03
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var hours: String { String(format: "%02d", timeRemaining / 3600) }
    private var minutes: String { String(format: "%02d", (timeRemaining % 3600) / 60) }
    private var seconds: String { String(format: "%02d", timeRemaining % 60) }

    var body: some View {
        ZStack {
            // Blue background
            Color(hex: 0x0077FF)

            VStack(spacing: 0) {
                // Countdown timer bar
                HStack(spacing: 9) {
                    Text(hours)
                    Text(":")
                    Text(minutes)
                    Text(":")
                    Text(seconds)
                }
                .monospacedDigit()
                .font(.system(size: 16, weight: .medium))
                .tracking(0.15)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(hex: 0x0064D7))
                .onReceive(timer) { _ in
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    }
                }

                Spacer()

                // Offer text
                Text("20% off on orders\nover $25.00")
                    .font(.system(size: 36, weight: .semibold))
                    .tracking(-1.15)
                    .lineSpacing(42 - 36)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                Spacer().frame(height: 24)

                // Shop button
                Text("Shop A.P.C.")
                    .font(.system(size: 16, weight: .semibold))
                    .tracking(-0.5)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(.black)
                    )

                Spacer()

                // Product thumbnails
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(.white)
                            .frame(width: 137, height: 136)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray.opacity(0.3))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
}
