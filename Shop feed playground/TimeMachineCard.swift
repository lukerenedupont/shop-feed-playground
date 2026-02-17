//
//  TimeMachineCard.swift
//  Shop feed playground
//
//  Vertically-swipeable card stack with color interpolation and
//  a scrollbar index. Drag cards up/down to navigate.
//  Inspired by Philip Davis's TimeMachine prototype.
//

import SwiftUI

// MARK: - Shared Constants

/// Shared between TimeMachineCard and TMCard within this file.
private enum Shared {
    static let total = 30
    static let showing = 5
    static let colorStart = Color(hex: 0x3A6FB5)
    static let colorEnd = Color(hex: 0xE84855)

    static func cardColor(_ i: Int) -> Color {
        colorStart.interpolate(to: colorEnd, fraction: Double(i) / Double(total))
    }
}

// MARK: - TimeMachineCard

struct TimeMachineCard: View {
    @State private var selected = 15
    @State private var isFocused = true

    // MARK: Layout

    private enum Layout {
        static let scrollbarTickSpacing: CGFloat = 3
        static let scrollbarTickCornerRadius: CGFloat = 10
        static let scrollbarTickSelectedWidth: CGFloat = 20
        static let scrollbarTickDefaultWidth: CGFloat = 4
        static let scrollbarTickHeight: CGFloat = 4
        static let scrollbarWidth: CGFloat = 30
        static let scrollbarTrailingPadding: CGFloat = 8
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Shared.cardColor(selected).opacity(0.8))

            scrollbar

            cardStack
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }

    // MARK: Subviews

    private var scrollbar: some View {
        HStack {
            Spacer()
            VStack(spacing: Layout.scrollbarTickSpacing) {
                ForEach(0..<Shared.total, id: \.self) { i in
                    RoundedRectangle(cornerRadius: Layout.scrollbarTickCornerRadius)
                        .fill(.white.opacity(0.5))
                        .frame(
                            width: i == selected ? Layout.scrollbarTickSelectedWidth : Layout.scrollbarTickDefaultWidth,
                            height: Layout.scrollbarTickHeight
                        )
                        .animation(.spring(), value: selected)
                }
            }
            .frame(width: Layout.scrollbarWidth)
            .padding(.trailing, Layout.scrollbarTrailingPadding)
        }
    }

    private var cardStack: some View {
        ForEach(0..<Shared.total, id: \.self) { i in
            let startN = selected - Shared.showing
            let endN = selected + 2
            if (startN...endN).contains(i) {
                TMCard(index: i, selected: $selected)
            }
        }
    }
}

// MARK: - TMCard

private struct TMCard: View {
    let index: Int
    @Binding var selected: Int
    @State private var cardOffsetY: CGFloat = 0

    // MARK: Layout

    private enum Layout {
        static let cornerRadius: CGFloat = 24
        static let innerWidth: CGFloat = 260
        static let innerHeight: CGFloat = 320
        static let stackedOffsetY: CGFloat = -200
        static let hiddenOffsetY: CGFloat = 500
        static let minScale: CGFloat = 0.75
        static let dragThreshold: CGFloat = 80
    }

    // MARK: Helpers

    private func offsetY() -> CGFloat {
        if index <= selected {
            return lerp(inMin: CGFloat(selected - Shared.showing), inMax: CGFloat(selected), outMin: Layout.stackedOffsetY, outMax: 0, CGFloat(index))
        } else {
            return Layout.hiddenOffsetY
        }
    }

    private func brightness() -> CGFloat {
        lerp(inMin: CGFloat(selected - Shared.showing), inMax: CGFloat(selected), outMin: 0, outMax: 1, CGFloat(index))
    }

    private func scaleEff() -> CGFloat {
        if index <= selected {
            return lerp(inMin: CGFloat(selected - Shared.showing), inMax: CGFloat(selected), outMin: Layout.minScale, outMax: 1, CGFloat(index))
        }
        return 1
    }

    // MARK: Body

    var body: some View {
        RoundedRectangle(cornerRadius: Layout.cornerRadius, style: .continuous)
            .fill(Shared.cardColor(index))
            .brightness(-1 + brightness() + 0.5)
            .frame(width: Layout.innerWidth, height: Layout.innerHeight)
            .scaleEffect(scaleEff())
            .offset(y: offsetY() + cardOffsetY)
            .gesture(
                DragGesture()
                    .onChanged { g in cardOffsetY = g.translation.height }
                    .onEnded { g in
                        withAnimation(.interpolatingSpring(mass: 1, stiffness: 100, damping: 60, initialVelocity: 3)) {
                            if cardOffsetY > Layout.dragThreshold { selected = max(0, selected - 1) }
                            else if cardOffsetY < -Layout.dragThreshold { selected = min(Shared.total - 1, selected + 1) }
                            cardOffsetY = 0
                        }
                    }
            )
    }
}
