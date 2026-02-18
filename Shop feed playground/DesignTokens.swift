//
//  DesignTokens.swift
//  Shop feed playground
//
//  Figma design tokens + shared view modifiers — used across all views.
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
    static let progressPurple = Color(hex: 0x5433EB)

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
    static let radius8: CGFloat = 8
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
    static let feedBottomScrollPadding: CGFloat = 24
    static let cardWidth: CGFloat = 377
    static let cardHeight: CGFloat = 644
    static let cardPadding: CGFloat = 8
    static let searchBarTopOffset: CGFloat = 54

    // MARK: Animations

    static let springDefault = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let springSnappy = Animation.spring(response: 0.25, dampingFraction: 0.75)
    static let springDrag = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let springExpand = Animation.spring(response: 0.5, dampingFraction: 0.82)

    // MARK: Shopify Shop Client (Gravity) Tokens

    enum ShopClient {
        // Palette excerpts from shop-client/gravity palette.
        static let purpleP40 = Color(hex: 0x5433EB)
        static let purpleL20 = Color(hex: 0x9C83F8)
        static let purpleL10 = Color(hex: 0xDBD1FF)
        static let purpleL5 = Color(hex: 0xEEEAFF)

        static let grayscaleD100 = Color(hex: 0x000000)
        static let grayscaleD93 = Color(hex: 0x121212)
        static let grayscaleD80 = Color(hex: 0x2A2A2A)
        static let grayscaleD70 = Color(hex: 0x404040)
        static let grayscaleD50 = Color(hex: 0x6F7071)
        static let grayscaleL20 = Color(hex: 0xC9CBCC)
        static let grayscaleL5 = Color(hex: 0xF2F4F5)
        static let grayscaleL2 = Color(hex: 0xFCFCFC)
        static let grayscaleL0 = Color(hex: 0xFFFFFF)

        static let greenD70 = Color(hex: 0x008552)
        static let greenL30 = Color(hex: 0x92D08D)
        static let poppyD50 = Color(hex: 0xD92A0F)
        static let poppyL40 = Color(hex: 0xF05D38)

        // Semantic colors (light-mode defaults from themeColors.ts).
        static let text = grayscaleD100
        static let textSecondary = Color.black.opacity(0.75)
        static let textTertiary = Color.black.opacity(0.56)
        static let textPlaceholder = Color.black.opacity(0.40)
        static let textInverse = grayscaleL0
        static let textBrand = purpleP40

        static let bg = grayscaleL2
        static let bgFill = grayscaleL0
        static let bgFillSecondary = grayscaleL5
        static let bgFillTertiary = grayscaleL20
        static let bgFillInverse = grayscaleD93
        static let bgFillBrand = purpleP40
        static let bgFillSuccess = greenD70
        static let bgFillCritical = poppyD50

        static let border = Color.black.opacity(0.10)
        static let borderSecondary = Color(red: 24 / 255, green: 59 / 255, blue: 78 / 255).opacity(0.06)
        static let borderImage = Color(red: 5 / 255, green: 41 / 255, blue: 77 / 255).opacity(0.10)

        // Core scales mirrored from gravity.
        static let chipMinHeight: CGFloat = 40
        static let space36: CGFloat = 36
        static let space40: CGFloat = 40
        static let space44: CGFloat = 44
        static let space48: CGFloat = 48
        static let space64: CGFloat = 64

        static let sectionGap: CGFloat = 36
        static let cardRowGutter: CGFloat = 8
        static let cardPadding: CGFloat = 16

        static let radius6: CGFloat = 6
        static let radius10: CGFloat = 10
        static let radius24: CGFloat = 24
        static let radius36: CGFloat = 36
        static let radius40: CGFloat = 40
        static let radiusMax: CGFloat = 9_999_999

        static let shadowSColor = Color.black.opacity(0.06)
        static let shadowSRadius: CGFloat = 8
        static let shadowSY: CGFloat = 2
        static let shadowMColor = Color.black.opacity(0.12)
        static let shadowMRadius: CGFloat = 24
        static let shadowMY: CGFloat = 4
        static let shadowLColor = Color.black.opacity(0.24)
        static let shadowLRadius: CGFloat = 40
        static let shadowLY: CGFloat = 8

        // BOUNCE_ANIMATION_DURATIONS from gravity: [100, 100, 83, 67] ms
        static let buttonBounceDurations: [Double] = [0.100, 0.100, 0.083, 0.067]
    }
}

// MARK: - Shop Typography

enum ShopTextStyle {
    case heroBold
    case headerBold
    case sectionTitle
    case subtitle
    case bodyLarge
    case bodyLargeBold
    case bodySmall
    case bodySmallBold
    case caption
    case captionBold
    case badge
    case badgeBold
    case buttonLarge
    case buttonMedium
    case buttonSmall
}

struct ShopTextSpec {
    let fontSize: CGFloat
    let lineHeight: CGFloat
    let letterSpacing: CGFloat
    let weight: Font.Weight
}

extension Tokens.ShopClient {
    static func textSpec(_ style: ShopTextStyle) -> ShopTextSpec {
        switch style {
        case .heroBold:
            return .init(fontSize: 36, lineHeight: 42, letterSpacing: -1.5, weight: .bold)
        case .headerBold:
            return .init(fontSize: 24, lineHeight: 26, letterSpacing: -1, weight: .semibold)
        case .sectionTitle:
            return .init(fontSize: 20, lineHeight: 22, letterSpacing: -1, weight: .semibold)
        case .subtitle:
            return .init(fontSize: 18, lineHeight: 20, letterSpacing: -0.5, weight: .semibold)
        case .bodyLarge:
            return .init(fontSize: 16, lineHeight: 22, letterSpacing: -0.5, weight: .regular)
        case .bodyLargeBold:
            return .init(fontSize: 16, lineHeight: 22, letterSpacing: -0.5, weight: .medium)
        case .bodySmall:
            return .init(fontSize: 14, lineHeight: 18, letterSpacing: -0.2, weight: .regular)
        case .bodySmallBold:
            return .init(fontSize: 14, lineHeight: 18, letterSpacing: -0.2, weight: .semibold)
        case .caption:
            return .init(fontSize: 12, lineHeight: 16, letterSpacing: -0.2, weight: .regular)
        case .captionBold:
            return .init(fontSize: 12, lineHeight: 16, letterSpacing: -0.2, weight: .semibold)
        case .badge:
            return .init(fontSize: 10, lineHeight: 13, letterSpacing: -0.2, weight: .regular)
        case .badgeBold:
            return .init(fontSize: 10, lineHeight: 13, letterSpacing: -0.2, weight: .semibold)
        case .buttonLarge:
            return .init(fontSize: 16, lineHeight: 20, letterSpacing: -0.5, weight: .semibold)
        case .buttonMedium:
            return .init(fontSize: 14, lineHeight: 16, letterSpacing: -0.2, weight: .semibold)
        case .buttonSmall:
            return .init(fontSize: 12, lineHeight: 16, letterSpacing: -0.2, weight: .semibold)
        }
    }
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

// MARK: - Shared View Modifiers

/// Standard white card background with border and shadow (used by order cards, product tiles, etc.)
struct CardBackground: ViewModifier {
    var radius: CGFloat = Tokens.radiusCard

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(Tokens.ShopClient.bgFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .stroke(Tokens.ShopClient.borderImage, lineWidth: 0.5)
                    )
                    .shadow(
                        color: Tokens.ShopClient.shadowSColor,
                        radius: Tokens.ShopClient.shadowSRadius,
                        x: 0,
                        y: Tokens.ShopClient.shadowSY
                    )
            )
    }
}

/// Small shadow card style (for product tiles, thumbnails)
struct SmallCardBackground: ViewModifier {
    var radius: CGFloat = Tokens.radius20

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Tokens.ShopClient.borderImage, lineWidth: 0.5)
            )
            .shadow(
                color: Tokens.ShopClient.shadowSColor,
                radius: Tokens.ShopClient.shadowSRadius,
                x: 0,
                y: Tokens.ShopClient.shadowSY
            )
    }
}

extension View {
    func cardStyle(radius: CGFloat = Tokens.radiusCard) -> some View {
        modifier(CardBackground(radius: radius))
    }

    func smallCardStyle(radius: CGFloat = Tokens.radius20) -> some View {
        modifier(SmallCardBackground(radius: radius))
    }

    func shopTextStyle(_ style: ShopTextStyle) -> some View {
        modifier(ShopTextStyleModifier(style: style))
    }
}

private struct ShopTextStyleModifier: ViewModifier {
    let style: ShopTextStyle

    func body(content: Content) -> some View {
        let spec = Tokens.ShopClient.textSpec(style)
        return content
            .font(.system(size: spec.fontSize, weight: spec.weight))
            .tracking(spec.letterSpacing)
            .lineSpacing(max(0, spec.lineHeight - spec.fontSize))
    }
}

// MARK: - Shared Haptics

/// Pre-warmed haptic generators shared across all cards.
/// Use `Haptics.selection()` for carousel snaps, `Haptics.light()` for button taps,
/// `Haptics.soft()` for subtle feedback like edge bounce or item pickup.
enum Haptics {
    private static let _selection = UISelectionFeedbackGenerator()
    private static let _light = UIImpactFeedbackGenerator(style: .light)
    private static let _soft = UIImpactFeedbackGenerator(style: .soft)
    private static let _notification = UINotificationFeedbackGenerator()

    static func selection() { _selection.selectionChanged() }
    static func light() { _light.impactOccurred() }
    static func soft(intensity: CGFloat = 1.0) { _soft.impactOccurred(intensity: intensity) }
    static func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) { _notification.notificationOccurred(type) }
}

// MARK: - Linear Interpolation

/// Map a value from one range to another (like D3's linearScale).
/// Used across multiple prototype-inspired cards.
func lerp(inMin: CGFloat, inMax: CGFloat, outMin: CGFloat, outMax: CGFloat, _ value: CGFloat) -> CGFloat {
    outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin)
}

// MARK: - Color Interpolation

extension Color {
    /// Linearly interpolate between two colors. `frac` 0 = self, 1 = other.
    func interpolate(to other: Color, fraction frac: CGFloat) -> Color {
        let cA = UIColor(self)
        let cB = UIColor(other)
        var rA: CGFloat = 0, gA: CGFloat = 0, bA: CGFloat = 0, aA: CGFloat = 0
        var rB: CGFloat = 0, gB: CGFloat = 0, bB: CGFloat = 0, aB: CGFloat = 0
        cA.getRed(&rA, green: &gA, blue: &bA, alpha: &aA)
        cB.getRed(&rB, green: &gB, blue: &bB, alpha: &aB)
        return Color(
            red: Double(rA + (rB - rA) * frac),
            green: Double(gA + (gB - gA) * frac),
            blue: Double(bA + (bB - bA) * frac)
        )
    }
}
