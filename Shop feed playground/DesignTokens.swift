//
//  DesignTokens.swift
//  Shop feed playground
//
//  Figma design tokens — shared across all views.
//

import SwiftUI

// MARK: - Design Tokens

enum Tokens {
    // MARK: Colors

    static let bg = Color(hex: 0xFCFCFC)
    static let overlayLight75 = Color.white.opacity(0.75)
    static let overlayDark04 = Color.black.opacity(0.04)
    static let textPrimary = Color.black
    static let textSecondary = Color.black.opacity(0.75)
    static let textTertiary = Color.black.opacity(0.56)
    static let textPlaceholder = Color.black.opacity(0.35)
    static let chipBorder = Color(red: 24 / 255, green: 59 / 255, blue: 78 / 255).opacity(0.06)
    static let chipFill = Color.white.opacity(0.85)
    static let imageBorder = Color(red: 5 / 255, green: 41 / 255, blue: 77 / 255).opacity(0.1)
    static let fillSecondary = Color(hex: 0xF2F4F5)

    // MARK: Gradient

    static let gradientPurple = Color(hex: 0x5433EB)
    static let gradientYellow = Color(hex: 0xD8CB32)
    static let gradientRed = Color(hex: 0xD83232)

    // MARK: Spacing

    static let space2: CGFloat = 2
    static let space4: CGFloat = 4
    static let space6: CGFloat = 6
    static let space8: CGFloat = 8
    static let space10: CGFloat = 10
    static let space12: CGFloat = 12
    static let space16: CGFloat = 16
    static let space20: CGFloat = 20
    static let space24: CGFloat = 24
    static let space32: CGFloat = 32

    // MARK: Radii

    static let radius12: CGFloat = 12
    static let radius16: CGFloat = 16
    static let radius20: CGFloat = 20
    static let radius28: CGFloat = 28
    static let radiusMax: CGFloat = 999
    static let radiusCard: CGFloat = 28

    // MARK: Typography

    static let subtitleSize: CGFloat = 18
    static let bodySize: CGFloat = 16
    static let bodySmSize: CGFloat = 14
    static let captionSize: CGFloat = 12
    static let badgeSize: CGFloat = 10
    static let bodyTracking: CGFloat = -0.5
    static let cozyTracking: CGFloat = -0.2
    static let lineHeightSection: CGFloat = 22
    static let lineHeightSubtitle: CGFloat = 20
    static let lineHeightCaption: CGFloat = 16

    // MARK: Shadows

    static let shadowColor = Color.black.opacity(0.12)
    static let shadowRadius: CGFloat = 12
    static let shadowY: CGFloat = 4

    static let shadowColor400 = Color.black.opacity(0.24)
    static let shadowRadiusL: CGFloat = 20
    static let shadowYL: CGFloat = 8

    static let shadowColorS = Color.black.opacity(0.06)
    static let shadowRadiusS: CGFloat = 4
    static let shadowYS: CGFloat = 2

    // MARK: Layout

    static let chipSize: CGFloat = 40
    static let iconSmall: CGFloat = 16
    static let cardHeight: CGFloat = 644
    static let cardPadding: CGFloat = 8
    static let searchBarTopOffset: CGFloat = 54
}

// MARK: - Color Hex Helper

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: opacity
        )
    }
}
