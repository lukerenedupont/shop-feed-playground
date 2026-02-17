//
//  SpatialTapCard.swift
//  Shop feed playground
//
//  Circles that spring-animate to wherever you tap, with a ghost
//  trail of past locations.
//  Inspired by Philip Davis's SpatialTapGesture prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let circleSize: CGFloat = 80
    static let ghostOpacity: Double = 0.15
    static let tapOpacity: Double = 0.8
    static let followerColor: UInt = 0x5B7AFF

    static let defaultX: CGFloat = 188
    static let defaultY: CGFloat = 322

    static let tapStiffness: CGFloat = 100
    static let tapDamping: CGFloat = 10
    static let followerStiffness: CGFloat = 20
    static let followerDamping: CGFloat = 10
}

// MARK: - Spatial Tap Card

struct SpatialTapCard: View {
    @State private var location: CGPoint = CGPoint(x: Layout.defaultX, y: Layout.defaultY)
    @State private var tapPoint: CGPoint = CGPoint(x: Layout.defaultX, y: Layout.defaultY)
    @State private var pastPoint: CGPoint = CGPoint(x: Layout.defaultX, y: Layout.defaultY)
    @State private var scale: CGFloat = 1

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(Color(hex: 0x0E0E0E))

            CardHeader(subtitle: "Spatial", title: "Tap anywhere", lightText: true)

            ghost
            currentTap
            trailingFollower
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .contentShape(Rectangle())
        .gesture(tapGesture)
    }
}

// MARK: - Circle Layers

private extension SpatialTapCard {
    var ghost: some View {
        Circle()
            .fill(.white.opacity(Layout.ghostOpacity))
            .frame(width: Layout.circleSize, height: Layout.circleSize)
            .position(pastPoint)
    }

    var currentTap: some View {
        Circle()
            .fill(.white.opacity(Layout.tapOpacity))
            .frame(width: Layout.circleSize, height: Layout.circleSize)
            .scaleEffect(scale)
            .position(tapPoint)
    }

    var trailingFollower: some View {
        Circle()
            .fill(Color(hex: Layout.followerColor))
            .frame(width: Layout.circleSize, height: Layout.circleSize)
            .position(location)
    }
}

// MARK: - Gesture

private extension SpatialTapCard {
    var tapGesture: some Gesture {
        SpatialTapGesture()
            .onEnded { event in
                scale = 0
                withAnimation(.linear(duration: 0)) {
                    pastPoint = tapPoint
                    tapPoint = event.location
                }
                withAnimation(.interpolatingSpring(stiffness: Layout.tapStiffness, damping: Layout.tapDamping)) {
                    scale = 1
                }
                withAnimation(.interpolatingSpring(stiffness: Layout.followerStiffness, damping: Layout.followerDamping)) {
                    location = event.location
                }
            }
    }
}
