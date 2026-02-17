//
//  WidgetExpansionCard.swift
//  Shop feed playground
//
//  Floating action button that expands into a text-input card with
//  animated icon transitions and material blur.
//  Inspired by Philip Davis's WidgetExpansion prototype.
//

import SwiftUI

// MARK: - WidgetExpansionCard

struct WidgetExpansionCard: View {
    @State private var isExpanded = false
    @State private var text = ""

    // MARK: Layout

    private enum Layout {
        static let bgColor = Color(hex: 0x0E0E0E)
        static let accentColor = Color(hex: 0x5B7AFF)
        static let transitionScale: CGFloat = 0.5
        static let fabIconSize: CGFloat = 24
        static let fabSize: CGFloat = 56
        static let fabShadowRadius: CGFloat = 12
        static let fabShadowY: CGFloat = 6
        static let fabShadowOpacity: Double = 0.4
        static let headerFontSize: CGFloat = 18
        static let checkmarkIconSize: CGFloat = 14
        static let checkmarkSize: CGFloat = 32
        static let textFieldFontSize: CGFloat = 15
        static let textFieldPadding: CGFloat = 12
        static let textFieldCornerRadius: CGFloat = 12
        static let textFieldBgOpacity: Double = 0.08
        static let expandedSpacing: CGFloat = 16
        static let expandedPadding: CGFloat = 20
        static let expandedCornerRadius: CGFloat = 24
        static let expandedWidth: CGFloat = 320
        static let expandedBorderOpacity: Double = 0.1
        static let expandedShadowOpacity: Double = 0.3
        static let expandedShadowRadius: CGFloat = 20
        static let expandedShadowY: CGFloat = 10
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Layout.bgColor)

            CardHeader(subtitle: "Widget", title: "Tap to expand", lightText: true)

            ZStack {
                if isExpanded {
                    expandedView
                        .transition(.scale(scale: Layout.transitionScale).combined(with: .opacity))
                } else {
                    fab
                        .transition(.scale(scale: Layout.transitionScale).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isExpanded)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }

    // MARK: Subviews

    private var fab: some View {
        Button {
            Haptics.light()
            isExpanded = true
        } label: {
            Image(systemName: "plus")
                .font(.system(size: Layout.fabIconSize, weight: .bold))
                .foregroundColor(.white)
                .frame(width: Layout.fabSize, height: Layout.fabSize)
                .background(Circle().fill(Layout.accentColor))
                .shadow(color: Layout.accentColor.opacity(Layout.fabShadowOpacity), radius: Layout.fabShadowRadius, x: 0, y: Layout.fabShadowY)
        }
    }

    private var expandedView: some View {
        VStack(spacing: Layout.expandedSpacing) {
            HStack {
                Text("New note")
                    .font(.system(size: Layout.headerFontSize, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Button {
                    Haptics.light()
                    withAnimation { isExpanded = false; text = "" }
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: Layout.checkmarkIconSize, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: Layout.checkmarkSize, height: Layout.checkmarkSize)
                        .background(Circle().fill(Layout.accentColor))
                }
            }

            TextField("Type something...", text: $text)
                .font(.system(size: Layout.textFieldFontSize))
                .foregroundColor(.white)
                .padding(Layout.textFieldPadding)
                .background(
                    RoundedRectangle(cornerRadius: Layout.textFieldCornerRadius, style: .continuous)
                        .fill(.white.opacity(Layout.textFieldBgOpacity))
                )
                .tint(Layout.accentColor)
        }
        .padding(Layout.expandedPadding)
        .background(
            RoundedRectangle(cornerRadius: Layout.expandedCornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: Layout.expandedCornerRadius, style: .continuous)
                        .stroke(Color.white.opacity(Layout.expandedBorderOpacity), lineWidth: 1)
                )
        )
        .frame(width: Layout.expandedWidth)
        .shadow(color: .black.opacity(Layout.expandedShadowOpacity), radius: Layout.expandedShadowRadius, x: 0, y: Layout.expandedShadowY)
    }
}
