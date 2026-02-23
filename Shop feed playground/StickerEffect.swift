//
//  StickerEffect.swift
//  Shop feed playground
//
//  Reusable sticker-like outline effect for SwiftUI views.
//

import SwiftUI

private struct StickerStrokeModifier: ViewModifier {
    private let symbolID = UUID()
    var strokeWidth: CGFloat = 1
    var strokeStyle: AnyShapeStyle = AnyShapeStyle(.white)

    @ViewBuilder
    func body(content: Content) -> some View {
        if strokeWidth > 0 {
            content
                .background(
                    Rectangle()
                        .foregroundStyle(strokeStyle)
                        .mask(alignment: .center) {
                            strokeMask(content: content)
                        }
                )
        } else {
            content
        }
    }

    private func strokeMask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            if let resolved = context.resolveSymbol(id: symbolID) {
                context.draw(
                    resolved,
                    at: CGPoint(x: size.width / 2, y: size.height / 2)
                )
            }
        } symbols: {
            content
                .tag(symbolID)
                .blur(radius: strokeWidth)
        }
    }
}

extension View {
    func stickerStroke(
        color: some ShapeStyle,
        width: CGFloat = 1
    ) -> some View {
        modifier(
            StickerStrokeModifier(
                strokeWidth: width,
                strokeStyle: AnyShapeStyle(color)
            )
        )
    }

    func stickered(
        width: CGFloat = 2.5,
        outlineColor: some ShapeStyle = .white,
        shadowColor: Color = Color.black.opacity(0.26),
        shadowWidth: CGFloat = 0.9
    ) -> some View {
        self
            .stickerStroke(color: outlineColor, width: width)
            .stickerStroke(color: shadowColor, width: shadowWidth)
    }
}

