//
//  RolloutMenuCard.swift
//  Shop feed playground
//
//  Icon buttons that roll out from a "+" trigger with staggered
//  spring animations.
//  Inspired by Philip Davis's RolloutMenu prototype.
//

import SwiftUI

// MARK: - RolloutMenuCard

struct RolloutMenuCard: View {
    @State private var isOpen = false

    // MARK: Layout

    private enum Layout {
        static let bgColor = Color(hex: 0x0E0E0E)
        static let triggerBgColor = Color(hex: 0x3A3A3A)
        static let menuSpacing: CGFloat = 12
        static let menuIconSize: CGFloat = 18
        static let menuItemSize: CGFloat = 48
        static let menuItemShadowRadius: CGFloat = 8
        static let menuItemShadowY: CGFloat = 4
        static let menuItemShadowOpacity: Double = 0.4
        static let triggerIconSize: CGFloat = 22
        static let triggerSize: CGFloat = 56
        static let openStaggerDelay: Double = 0.06
        static let closeStaggerDelay: Double = 0.04
        static let collapsedScale: CGFloat = 0.01
        static let triggerRotation: Double = 45
    }

    // MARK: Data

    private let menuItems: [(icon: String, color: Color)] = [
        ("heart.fill", Color(hex: 0xE84855)),
        ("bookmark.fill", Color(hex: 0xF9DC5C)),
        ("square.and.arrow.up", Color(hex: 0x3BB273)),
        ("bell.fill", Color(hex: 0x2EC4B6)),
        ("star.fill", Color(hex: 0x5B7AFF)),
    ]

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Layout.bgColor)

            CardHeader(subtitle: "Menu", title: "Tap to rollout", lightText: true)

            HStack(spacing: Layout.menuSpacing) {
                menuButtons

                triggerButton
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }

    // MARK: Subviews

    private var menuButtons: some View {
        ForEach(menuItems.indices, id: \.self) { i in
            let item = menuItems[i]

            Button { Haptics.light() } label: {
                Image(systemName: item.icon)
                    .font(.system(size: Layout.menuIconSize, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: Layout.menuItemSize, height: Layout.menuItemSize)
                    .background(Circle().fill(item.color))
                    .shadow(color: item.color.opacity(Layout.menuItemShadowOpacity), radius: Layout.menuItemShadowRadius, x: 0, y: Layout.menuItemShadowY)
            }
            .scaleEffect(isOpen ? 1 : Layout.collapsedScale)
            .opacity(isOpen ? 1 : 0)
            .animation(
                .spring(response: 0.35, dampingFraction: 0.6)
                    .delay(isOpen ? Double(i) * Layout.openStaggerDelay : Double(menuItems.count - i) * Layout.closeStaggerDelay),
                value: isOpen
            )
        }
    }

    private var triggerButton: some View {
        Button {
            Haptics.light()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOpen.toggle()
            }
        } label: {
            Image(systemName: "plus")
                .font(.system(size: Layout.triggerIconSize, weight: .bold))
                .foregroundColor(.white)
                .frame(width: Layout.triggerSize, height: Layout.triggerSize)
                .background(Circle().fill(Layout.triggerBgColor))
                .rotationEffect(.degrees(isOpen ? Layout.triggerRotation : 0))
        }
    }
}
