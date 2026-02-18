//
//  StatefulButtonCard.swift
//  Shop feed playground
//
//  "Add to bag" button that spring-animates into a "Added" checkmark
//  state, then auto-reverts.
//  Inspired by Philip Davis's StatefulButton prototype.
//

import SwiftUI

// MARK: - StatefulButtonCard

struct StatefulButtonCard: View {
    @State private var isAdded = false

    // MARK: Layout

    private enum Layout {
        static let bgColor = Color(hex: 0x0E0E0E)
        static let accentColor = Color(hex: 0x5B7AFF)
        static let iconSize: CGFloat = 16
        static let labelSize: CGFloat = 16
        static let horizontalPadding: CGFloat = 28
        static let verticalPadding: CGFloat = 16
        static let shadowOpacity: Double = 0.3
        static let shadowRadius: CGFloat = 12
        static let shadowY: CGFloat = 6
        static let pressedScale: CGFloat = 1.05
        static let revertDelay: Double = 2
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Layout.bgColor)

            CardHeader(subtitle: "Micro-interaction", title: "Stateful button", lightText: true)

            addButton
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }

    // MARK: Subviews

    private var addButton: some View {
        Button {
            guard !isAdded else { return }
            Haptics.light()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isAdded = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + Layout.revertDelay) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isAdded = false
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isAdded ? "checkmark" : "bag.badge.plus")
                    .font(.system(size: Layout.iconSize, weight: .bold))
                    .foregroundColor(isAdded ? .black : .white)
                    .contentTransition(.symbolEffect(.replace))

                Text(isAdded ? "Added" : "Add to bag")
                    .shopTextStyle(.buttonLarge)
                    .foregroundColor(isAdded ? .black : .white)
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
            .background(
                Capsule().fill(isAdded ? Color.white : Layout.accentColor)
            )
            .shadow(color: (isAdded ? Color.white : Layout.accentColor).opacity(Layout.shadowOpacity),
                    radius: Layout.shadowRadius, x: 0, y: Layout.shadowY)
        }
        .scaleEffect(isAdded ? Layout.pressedScale : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAdded)
    }
}
