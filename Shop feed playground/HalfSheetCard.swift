//
//  HalfSheetCard.swift
//  Shop feed playground
//
//  Half-sheet that collapses into a small pill/capsule with spring
//  animations. Tap to toggle.
//  Inspired by Philip Davis's HalfSheetTransform prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let sheetWidth: CGFloat = 340
    static let sheetHeight: CGFloat = 360
    static let sheetCorner: CGFloat = 28
    static let sheetPadding: CGFloat = 24

    static let pillWidth: CGFloat = 160
    static let pillHeight: CGFloat = 48
    static let pillDotSize: CGFloat = 8

    static let titleSize: CGFloat = 18
    static let subtitleSize: CGFloat = 14
    static let priceSize: CGFloat = 20
    static let buttonFontSize: CGFloat = 16
    static let buttonPaddingV: CGFloat = 14
    static let rowFontSize: CGFloat = 14

    static let titleSpacing: CGFloat = 4
    static let sectionSpacing: CGFloat = 16
    static let rowSpacing: CGFloat = 8
    static let pillItemSpacing: CGFloat = 8

    static let shadowOpacity: Double = 0.3
    static let shadowRadius: CGFloat = 20
    static let shadowY: CGFloat = 10

    static let borderOpacity: Double = 0.1

    static let expandedBottomPadding: CGFloat = 20
    static let collapsedBottomPadding: CGFloat = 40

    static let toggleSpring = Animation.spring(response: 0.4, dampingFraction: 0.8)
}

// MARK: - Half Sheet Card

struct HalfSheetCard: View {
    @State private var isExpanded = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))

            CardHeader(subtitle: "Sheet", title: "Tap to morph", lightText: true)

            VStack {
                Spacer()

                ZStack {
                    sheetBackground
                    sheetContent
                }
                .frame(
                    width: isExpanded ? Layout.sheetWidth : Layout.pillWidth,
                    height: isExpanded ? Layout.sheetHeight : Layout.pillHeight
                )
                .shadow(color: .black.opacity(Layout.shadowOpacity), radius: Layout.shadowRadius, x: 0, y: Layout.shadowY)
                .onTapGesture {
                    Haptics.light()
                    withAnimation(Layout.toggleSpring) {
                        isExpanded.toggle()
                    }
                }
                .padding(.bottom, isExpanded ? Layout.expandedBottomPadding : Layout.collapsedBottomPadding)
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Sheet Background

private extension HalfSheetCard {
    var sheetBackground: some View {
        let corner = isExpanded ? Layout.sheetCorner : Layout.pillHeight / 2
        return RoundedRectangle(cornerRadius: corner, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(Color.white.opacity(Layout.borderOpacity), lineWidth: 1)
            )
    }
}

// MARK: - Sheet Content

private extension HalfSheetCard {
    @ViewBuilder
    var sheetContent: some View {
        if isExpanded {
            expandedContent
                .transition(.opacity)
        } else {
            collapsedContent
                .transition(.opacity)
        }
    }

    var expandedContent: some View {
        VStack(alignment: .leading, spacing: Layout.sectionSpacing) {
            HStack {
                VStack(alignment: .leading, spacing: Layout.titleSpacing) {
                    Text("Product details")
                        .font(.system(size: Layout.titleSize, weight: .bold))
                        .foregroundColor(.white)
                    Text("Premium leather sneaker")
                        .font(.system(size: Layout.subtitleSize))
                        .foregroundColor(.white.opacity(0.6))
                }
                Spacer()
                Text("$185")
                    .font(.system(size: Layout.priceSize, weight: .bold))
                    .foregroundColor(.white)
            }

            Divider().background(.white.opacity(0.2))

            VStack(alignment: .leading, spacing: Layout.rowSpacing) {
                sheetRow(label: "Size", value: "US 10")
                sheetRow(label: "Color", value: "Black")
                sheetRow(label: "Material", value: "Full-grain leather")
            }

            Spacer()

            Button {
                Haptics.light()
            } label: {
                Text("Add to bag")
                    .font(.system(size: Layout.buttonFontSize, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Layout.buttonPaddingV)
                    .background(Capsule().fill(.white))
            }
        }
        .padding(Layout.sheetPadding)
    }

    var collapsedContent: some View {
        HStack(spacing: Layout.pillItemSpacing) {
            Circle().fill(.white).frame(width: Layout.pillDotSize, height: Layout.pillDotSize)
            Text("View details")
                .font(.system(size: Layout.subtitleSize, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Helpers

private extension HalfSheetCard {
    func sheetRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: Layout.rowFontSize))
                .foregroundColor(.white.opacity(0.5))
            Spacer()
            Text(value)
                .font(.system(size: Layout.rowFontSize, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}
