//
//  FidgetCard.swift
//  Shop feed playground
//
//  3D tilt card with holographic gradient border.
//  Drag to tilt and reveal the rainbow edge. Release to spring back.
//  Inspired by Philip Davis's FidgetCard prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let tiltW: CGFloat     = 340
    static let tiltH: CGFloat     = 440
    static let borderW: CGFloat   = 4
    static let corner: CGFloat    = 24
    static let intensity: CGFloat = 12

    static let gradientColors: [Color] = [
        Color(hex: 0xE84855), Color(hex: 0xF9DC5C), Color(hex: 0x3BB273),
        Color(hex: 0x2EC4B6), Color(hex: 0x5B7AFF), Color(hex: 0xE84393),
        Color(hex: 0xE84855),
    ]
}

// MARK: - Fidget Card

struct FidgetCard: View {
    @State private var dragLocation = CGPoint.zero
    @State private var isDragging = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )

            header

            tiltStack
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Header

private extension FidgetCard {
    var header: some View {
        CardHeader(subtitle: "Featured drop", title: "Tilt to explore", lightText: true)
    }
}

// MARK: - Tilt Stack

private extension FidgetCard {
    var tiltStack: some View {
        ZStack {
            holoBorder
            productFace
        }
        .frame(width: Layout.tiltW, height: Layout.tiltH)
        .offset(y: 30)
    }

    var holoBorder: some View {
        RoundedRectangle(cornerRadius: Layout.corner, style: .continuous)
            .fill(
                AngularGradient(
                    gradient: Gradient(colors: Layout.gradientColors),
                    center: .center
                )
            )
            .frame(width: Layout.tiltW, height: Layout.tiltH)
            .rotation3DEffect(.degrees(dragLocation.x * 0.3), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(.degrees(dragLocation.y * 0.3), axis: (x: 1, y: 0, z: 0))
            .animation(.interactiveSpring(), value: dragLocation)
    }

    var productFace: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Layout.corner - 2, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))

            Image("BlackShoe3")
                .resizable()
                .scaledToFill()
                .frame(width: Layout.tiltW - 40, height: Layout.tiltW - 40)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .offset(y: -40)

            productInfo
        }
        .frame(width: Layout.tiltW - Layout.borderW * 2, height: Layout.tiltH - Layout.borderW * 2)
        .clipShape(RoundedRectangle(cornerRadius: Layout.corner - 2, style: .continuous))
        .rotation3DEffect(.degrees(dragLocation.x), axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(.degrees(dragLocation.y), axis: (x: 1, y: 0, z: 0))
        .gesture(tiltGesture)
    }

    var productInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Spacer()
            Text("Asics Gel-1130")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .tracking(-0.5)
            Text("$120")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
    }
}

// MARK: - Gesture

private extension FidgetCard {
    var tiltGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { gesture in
                let nx = lerp(
                    inMin: 0, inMax: Layout.tiltW - Layout.borderW * 2,
                    outMin: -Layout.intensity, outMax: Layout.intensity,
                    gesture.location.x
                )
                let ny = lerp(
                    inMin: 0, inMax: Layout.tiltH - Layout.borderW * 2,
                    outMin: Layout.intensity, outMax: -Layout.intensity,
                    gesture.location.y
                )
                withAnimation(isDragging ? .interactiveSpring() : .spring()) {
                    dragLocation = CGPoint(x: nx, y: ny)
                }
                isDragging = true
            }
            .onEnded { _ in
                isDragging = false
                withAnimation(.spring()) { dragLocation = .zero }
            }
    }
}

