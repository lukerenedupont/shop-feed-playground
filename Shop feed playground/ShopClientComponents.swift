//
//  ShopClientComponents.swift
//  Shop feed playground
//
//  SwiftUI ports of selected styles/components from Shopify/shop-client.
//

import SwiftUI

// MARK: - Card

struct ShopClientCard<Content: View>: View {
    var padding: CGFloat = Tokens.ShopClient.cardPadding
    var borderRadius: CGFloat = Tokens.radius12
    var backgroundColor: Color = Tokens.ShopClient.bgFill
    var borderWidth: CGFloat = 1
    var borderColor: Color = Tokens.ShopClient.border
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: borderRadius, style: .continuous)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: borderRadius, style: .continuous)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            )
    }
}

// MARK: - Button

enum ShopClientButtonVariant {
    case primary
    case secondary
    case tertiary
    case outlined
    case text
    case dangerous
}

enum ShopClientButtonSize {
    case s
    case m
    case l
    case xl
}

struct ShopClientButton: View {
    let title: String
    var variant: ShopClientButtonVariant = .primary
    var size: ShopClientButtonSize = .l
    var leadingAssetName: String? = nil
    var leadingSystemImage: String? = nil
    var disabled: Bool = false
    var borderRadius: CGFloat = Tokens.ShopClient.radiusMax
    var expandHorizontally: Bool = false
    let action: () -> Void

    @GestureState private var isPressing = false
    @State private var bounceScale: CGFloat = 1

    var body: some View {
        Button {
            guard !disabled else { return }
            action()
            playBounceSequence()
        } label: {
            HStack(spacing: Tokens.space8) {
                if let leadingAssetName {
                    Image(leadingAssetName)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sizeConfig.iconSize, height: sizeConfig.iconSize)
                } else if let leadingSystemImage {
                    Image(systemName: leadingSystemImage)
                        .font(.system(size: sizeConfig.iconSize, weight: .semibold))
                        .frame(width: sizeConfig.iconSize, height: sizeConfig.iconSize)
                }

                Text(title)
                    .shopTextStyle(sizeConfig.textStyle)
                    .lineLimit(1)
            }
            .foregroundStyle(disabled ? Tokens.ShopClient.textPlaceholder : style.foreground)
            .frame(minHeight: sizeConfig.minHeight)
            .frame(maxWidth: expandHorizontally ? .infinity : nil)
            .padding(.horizontal, Tokens.space16)
            .padding(.vertical, sizeConfig.verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: borderRadius, style: .continuous)
                    .fill(disabled ? Tokens.ShopClient.bgFillSecondary : style.background)
                    .overlay(
                        RoundedRectangle(cornerRadius: borderRadius, style: .continuous)
                            .stroke(style.border, lineWidth: style.borderWidth)
                    )
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressing ? 0.94 : bounceScale)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .updating($isPressing) { _, state, _ in
                    state = true
                }
        )
        .animation(.easeOut(duration: Tokens.ShopClient.buttonBounceDurations[0]), value: isPressing)
    }

    private var sizeConfig: ShopClientButtonSizeConfig {
        switch size {
        case .s:
            return .init(minHeight: 32, verticalPadding: Tokens.space8, iconSize: 14, textStyle: .buttonSmall)
        case .m:
            return .init(minHeight: 40, verticalPadding: Tokens.space12, iconSize: 16, textStyle: .buttonMedium)
        case .l:
            return .init(minHeight: 44, verticalPadding: Tokens.space12, iconSize: 16, textStyle: .buttonLarge)
        case .xl:
            return .init(minHeight: 52, verticalPadding: Tokens.space16, iconSize: 16, textStyle: .buttonLarge)
        }
    }

    private var style: ShopClientButtonStyleConfig {
        switch variant {
        case .primary:
            return .init(background: Tokens.ShopClient.bgFillBrand, foreground: Tokens.ShopClient.textInverse, border: .clear)
        case .secondary:
            return .init(background: Tokens.ShopClient.bgFillInverse, foreground: Tokens.ShopClient.textInverse, border: .clear)
        case .tertiary:
            return .init(background: Tokens.ShopClient.bgFillSecondary, foreground: Tokens.ShopClient.text, border: .clear)
        case .outlined:
            return .init(background: Tokens.ShopClient.bgFill, foreground: Tokens.ShopClient.text, border: Tokens.ShopClient.border)
        case .text:
            return .init(background: .clear, foreground: Tokens.ShopClient.text, border: .clear)
        case .dangerous:
            return .init(background: Tokens.ShopClient.bgFillCritical, foreground: Tokens.ShopClient.textInverse, border: .clear)
        }
    }

    private func playBounceSequence() {
        let durations = Tokens.ShopClient.buttonBounceDurations

        Task { @MainActor in
            withAnimation(.easeOut(duration: durations[1])) {
                bounceScale = 1.01
            }
            try? await Task.sleep(nanoseconds: UInt64(durations[1] * 1_000_000_000))

            withAnimation(.easeInOut(duration: durations[2])) {
                bounceScale = 0.99
            }
            try? await Task.sleep(nanoseconds: UInt64(durations[2] * 1_000_000_000))

            withAnimation(.easeInOut(duration: durations[3])) {
                bounceScale = 1.0
            }
        }
    }
}

private struct ShopClientButtonSizeConfig {
    let minHeight: CGFloat
    let verticalPadding: CGFloat
    let iconSize: CGFloat
    let textStyle: ShopTextStyle
}

private struct ShopClientButtonStyleConfig {
    let background: Color
    let foreground: Color
    let border: Color
    var borderWidth: CGFloat = 1
}

// MARK: - Chip

enum ShopClientChipVariant {
    case `default`
    case shadow
}

struct ShopClientChip: View {
    let label: String
    var iconAssetName: String? = nil
    var selected: Bool = false
    var circular: Bool = false
    var variant: ShopClientChipVariant = .default
    var onTap: (() -> Void)? = nil

    private var borderRadius: CGFloat {
        circular ? Tokens.ShopClient.chipMinHeight / 2 : Tokens.radius8
    }

    private var foreground: Color {
        selected ? Tokens.ShopClient.textInverse : Tokens.ShopClient.text
    }

    private var background: Color {
        selected ? Tokens.ShopClient.bgFillInverse : Tokens.ShopClient.bgFill
    }

    var body: some View {
        chipBody
            .applyOptionalTap(onTap)
    }

    private var chipBody: some View {
        HStack(spacing: Tokens.space4) {
            if let iconAssetName {
                Image(iconAssetName)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundStyle(foreground)
            }

            Text(label)
                .shopTextStyle(.buttonSmall)
                .foregroundStyle(foreground)
                .lineLimit(1)
        }
        .padding(.horizontal, Tokens.space8)
        .frame(minHeight: Tokens.ShopClient.chipMinHeight)
        .background(chipBackground)
    }

    @ViewBuilder
    private var chipBackground: some View {
        switch variant {
        case .default:
            RoundedRectangle(cornerRadius: borderRadius, style: .continuous)
                .fill(selected ? Tokens.ShopClient.bgFillInverse : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: borderRadius, style: .continuous)
                        .stroke(selected ? Color.clear : Tokens.ShopClient.border, lineWidth: 1)
                )
        case .shadow:
            RoundedRectangle(cornerRadius: borderRadius, style: .continuous)
                .fill(background)
                .overlay(
                    RoundedRectangle(cornerRadius: borderRadius, style: .continuous)
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
}

private extension View {
    @ViewBuilder
    func applyOptionalTap(_ onTap: (() -> Void)?) -> some View {
        if let onTap {
            Button(action: onTap) { self }
                .buttonStyle(.plain)
        } else {
            self
        }
    }
}

// MARK: - Badge

enum ShopClientBadgeVariant {
    case brand
    case success
    case critical
    case neutral
}

struct ShopClientBadge: View {
    let text: String
    var strikethroughText: String? = nil
    var variant: ShopClientBadgeVariant = .neutral

    var body: some View {
        HStack(spacing: Tokens.space2) {
            Text(text)
                .shopTextStyle(.badgeBold)
                .foregroundStyle(style.foreground)

            if let strikethroughText {
                Text(strikethroughText)
                    .shopTextStyle(.badge)
                    .foregroundStyle(style.foreground.opacity(0.75))
                    .strikethrough()
            }
        }
        .padding(.vertical, Tokens.space2)
        .padding(.horizontal, Tokens.space6)
        .frame(minWidth: 24)
        .background(
            Capsule(style: .continuous)
                .fill(style.background)
        )
    }

    private var style: ShopClientBadgeStyle {
        switch variant {
        case .brand:
            return .init(background: Tokens.ShopClient.bgFillBrand, foreground: Tokens.ShopClient.textInverse)
        case .success:
            return .init(background: Tokens.ShopClient.bgFillSuccess, foreground: Tokens.ShopClient.textInverse)
        case .critical:
            return .init(background: Tokens.ShopClient.bgFillCritical, foreground: Tokens.ShopClient.textInverse)
        case .neutral:
            return .init(background: Tokens.ShopClient.bgFillSecondary, foreground: Tokens.ShopClient.text)
        }
    }
}

private struct ShopClientBadgeStyle {
    let background: Color
    let foreground: Color
}

