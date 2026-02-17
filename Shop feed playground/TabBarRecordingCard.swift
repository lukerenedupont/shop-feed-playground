//
//  TabBarRecordingCard.swift
//  Shop feed playground
//
//  Animated tab bar with a record button that morphs between states
//  with pulsing concentric rings.
//  Inspired by Philip Davis's TabBarRecording prototype.
//

import SwiftUI

// MARK: - TabBarRecordingCard

struct TabBarRecordingCard: View {
    @State private var isRecording = false
    @State private var hasContent = false
    @State private var pulse1 = false
    @State private var pulse2 = false

    // MARK: Layout

    private enum Layout {
        static let bgColor = Color(hex: 0x0E0E0E)
        static let barColor = Color(hex: 0x2A2A2A)
        static let tabIconSize: CGFloat = 18
        static let tabButtonSize: CGFloat = 44
        static let tabButtonCornerRadius: CGFloat = 22
        static let tabButtonBgOpacity: Double = 0.05
        static let defaultSpacing: CGFloat = 28
        static let contentSpacing: CGFloat = 18
        static let barVerticalPadding: CGFloat = 16
        static let barDefaultHorizontalPadding: CGFloat = 38
        static let barContentHorizontalPadding: CGFloat = 20
        static let barCornerRadius: CGFloat = 100
        static let recordingBarWidth: CGFloat = 76
        static let bottomPadding: CGFloat = 60
        static let transitionScale: CGFloat = 0.7
        static let pulseDuration: Double = 2
        static let pulse1Delay: Double = 1
        static let pulse2Delay: Double = 1.2
        static let pulseMaxScale: CGFloat = 1.5
        static let pulse2MaxScale: CGFloat = 1.3
        static let pulseMinScale: CGFloat = 0.8
        static let pulse1Opacity: Double = 0.6
        static let pulse2Opacity: Double = 0.4
        static let stopCircleSize: CGFloat = 40
        static let stopIconScale: CGFloat = 1.6
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Layout.bgColor)

            CardHeader(subtitle: "Interaction", title: "Recording UI", lightText: true)

            VStack {
                Spacer()

                HStack(spacing: 0) {
                    HStack(spacing: hasContent ? Layout.contentSpacing : Layout.defaultSpacing) {
                        if hasContent {
                            tabButton(icon: "delete.left.fill") {
                                withAnimation(.spring()) { hasContent = false }
                            }
                            .transition(.scale(scale: Layout.transitionScale).combined(with: .opacity))
                        }

                        HStack(spacing: Layout.defaultSpacing) {
                            tabButton(icon: "keyboard") {}
                                .opacity(isRecording ? 0 : 1)

                            recordButton

                            tabButton(icon: "camera.aperture") {}
                                .opacity(isRecording ? 0 : 1)
                        }

                        if hasContent {
                            tabButton(icon: "arrowshape.turn.up.forward.fill") {}
                                .transition(.scale(scale: Layout.transitionScale).combined(with: .opacity))
                        }
                    }
                    .padding(.vertical, Layout.barVerticalPadding)
                    .padding(.horizontal, hasContent ? Layout.barContentHorizontalPadding : Layout.barDefaultHorizontalPadding)
                    .background(Layout.barColor)
                    .frame(width: isRecording ? Layout.recordingBarWidth : nil)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.barCornerRadius, style: isRecording ? .circular : .continuous))
                    .animation(.spring(), value: isRecording)
                    .animation(.spring(), value: hasContent)
                }
                .padding(.bottom, Layout.bottomPadding)
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }

    // MARK: Subviews

    private func tabButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: Layout.tabIconSize, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: Layout.tabButtonSize, height: Layout.tabButtonSize)
        .background(.white.opacity(hasContent ? Layout.tabButtonBgOpacity : 0))
        .cornerRadius(Layout.tabButtonCornerRadius)
    }

    private var recordButton: some View {
        Button {
            isRecording.toggle()
            if !isRecording { withAnimation(.spring()) { hasContent = true } }
        } label: {
            ZStack {
                Image(systemName: "waveform.path")
                    .font(.title)
                    .foregroundColor(.white)
                    .opacity(isRecording ? 0 : 1)

                if isRecording {
                    Circle()
                        .foregroundColor(.white.opacity(pulse1 ? 0 : Layout.pulse1Opacity))
                        .scaleEffect(pulse1 ? Layout.pulseMaxScale : Layout.pulseMinScale)
                        .animation(.easeOut(duration: Layout.pulseDuration).repeatForever(autoreverses: false).delay(Layout.pulse1Delay), value: pulse1)
                        .onAppear { pulse1 = true }
                        .onDisappear { pulse1 = false }

                    Circle()
                        .foregroundColor(Layout.barColor.opacity(pulse2 ? 0 : Layout.pulse2Opacity))
                        .scaleEffect(pulse2 ? Layout.pulse2MaxScale : Layout.pulseMinScale)
                        .animation(.easeOut(duration: Layout.pulseDuration).repeatForever(autoreverses: false).delay(Layout.pulse2Delay), value: pulse2)
                        .onAppear { pulse2 = true }
                        .onDisappear { pulse2 = false }

                    Circle().foregroundColor(Layout.barColor).frame(width: Layout.stopCircleSize, height: Layout.stopCircleSize)

                    Image(systemName: "stop.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .scaleEffect(Layout.stopIconScale)
                        .clipShape(Circle())
                }
            }
        }
        .frame(width: Layout.tabButtonSize)
    }
}
