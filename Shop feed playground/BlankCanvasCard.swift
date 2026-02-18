//
//  BlankCanvasCard.swift
//  Shop feed playground
//
//  Empty starter card for rapid prototyping.
//

import SwiftUI

struct BlankCanvasCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(Color(hex: 0xE5E7EE))
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .stroke(Color.white.opacity(0.35), lineWidth: 0.5)
            )
            .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
    }
}
