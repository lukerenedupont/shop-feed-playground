//
//  ShoeSwipeCard.swift
//  Shop feed playground
//
//  Three-shoe swipe card with snap paging and color-changing background.
//  Tap a shoe to flip it 90° onto a product card tile.
//

import SwiftUI

struct ShoeSwipeCard: View {
    @State private var selectedIndex: Int = 0
    @State private var dragTranslation: CGFloat = 0
    @State private var hitEdge: Bool = false
    @State private var isExpanded: Bool = false

    private let shoes: [ShoeSlide] = [
        .init(imageName: "ShoeSwipeGreen", background: Color(hex: 0x2F3218)),
        .init(imageName: "ShoeSwipeBlack", background: Color(hex: 0x262525)),
        .init(imageName: "ShoeSwipeWhiteRed", background: Color(hex: 0x331515)),
    ]

    private let shoeWidth: CGFloat = 336
    private let shoeHeight: CGFloat = 504
    private let shoeSpacing: CGFloat = -110
    private let tileSize: CGFloat = 242

    var body: some View {
        let selectedShoe = shoes[selectedIndex]

        ZStack {
            // Background
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(selectedShoe.background)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )
                .animation(.easeInOut(duration: 0.25), value: selectedIndex)

            // Carousel layer
            let stride = shoeWidth + shoeSpacing

            ZStack {
                // Ground shadow
                if !isExpanded {
                    Ellipse()
                        .fill(.black.opacity(0.12))
                        .frame(width: 220, height: 28)
                        .blur(radius: 24)
                        .offset(y: 196)
                }

                // White product tile (behind the shoe when expanded)
                if isExpanded {
                    productTile
                        .transition(.scale(scale: 0.8).combined(with: .opacity))
                        .zIndex(4)
                }

                ForEach(shoes.indices, id: \.self) { index in
                    let relative = CGFloat(index - selectedIndex)
                    let isActive = index == selectedIndex

                    shoeView(index: index, isActive: isActive, relative: relative, stride: stride)
                }
                .animation(Tokens.springExpand, value: isExpanded)
                .animation(Tokens.springSnappy, value: selectedIndex)
            }

            // KITH logo at top
            VStack {
                Image("ShoeSwipeKithLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 48)
                    .padding(.top, 28)
                Spacer()
            }
            .allowsHitTesting(false)

            // Shop now button at bottom
            VStack {
                Spacer()
                Button(action: { Haptics.light() }) {
                    Text("Shop now")
                        .font(.system(size: Tokens.bodySize, weight: .semibold))
                        .tracking(Tokens.bodyTracking)
                        .foregroundColor(selectedShoe.background)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(Capsule().fill(.white))
                }
                .padding(.bottom, 40)
            }

            // Tap-to-dismiss overlay when expanded
            if isExpanded {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(Tokens.springExpand) {
                            isExpanded = false
                        }
                        Haptics.light()
                    }
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .contentShape(Rectangle())
        .simultaneousGesture(
            isExpanded ? nil :
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    guard abs(value.translation.width) > abs(value.translation.height) else { return }

                    let translation = value.translation.width
                    let isPushingLeftEdge = selectedIndex == 0 && translation > 0
                    let isPushingRightEdge = selectedIndex == shoes.count - 1 && translation < 0
                    let isAtEdge = isPushingLeftEdge || isPushingRightEdge

                    if isAtEdge && !hitEdge {
                        Haptics.soft(intensity: 0.5)
                        hitEdge = true
                    } else if !isAtEdge {
                        hitEdge = false
                    }

                    dragTranslation = isAtEdge ? translation * 0.24 : translation
                }
                .onEnded { value in
                    hitEdge = false

                    guard abs(value.translation.width) > abs(value.translation.height) else {
                        withAnimation(Tokens.springDefault) {
                            dragTranslation = 0
                        }
                        return
                    }

                    let projected = value.predictedEndTranslation.width
                    let threshold: CGFloat = 70
                    var newIndex = selectedIndex

                    if projected < -threshold {
                        newIndex += 1
                    } else if projected > threshold {
                        newIndex -= 1
                    }

                    newIndex = max(0, min(shoes.count - 1, newIndex))

                    if newIndex != selectedIndex {
                        Haptics.selection()
                    }

                    withAnimation(Tokens.springSnappy) {
                        selectedIndex = newIndex
                        dragTranslation = 0
                    }
                }
        )
    }

    // MARK: - Individual shoe view

    @ViewBuilder
    private func shoeView(index: Int, isActive: Bool, relative: CGFloat, stride: CGFloat) -> some View {
        let expandedActive = isExpanded && isActive

        Image(shoes[index].imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(
                width: expandedActive ? 278 : shoeWidth,
                height: expandedActive ? 186 : shoeHeight
            )
            .rotationEffect(.degrees(expandedActive ? 90 : 0))
            .scaleEffect(expandedActive ? 1.0 : (isActive ? 1.0 : 0.9))
            .opacity(isExpanded ? (isActive ? 1.0 : 0) : (isActive ? 1.0 : 0.98))
            .shadow(
                color: .black.opacity(isActive ? 0.10 : 0.05),
                radius: isActive ? 20 : 12,
                x: 0,
                y: isActive ? 12 : 6
            )
            .offset(
                x: isExpanded
                    ? (isActive ? 0 : (relative < 0 ? -500 : 500))
                    : (relative * stride + dragTranslation),
                y: expandedActive ? -6 : -32
            )
            .zIndex(isActive ? 10 : 1)
            .onTapGesture {
                guard isActive && !isExpanded else { return }
                withAnimation(Tokens.springExpand) {
                    isExpanded = true
                }
                Haptics.light()
            }
    }

    // MARK: - Product tile (white card behind the shoe when expanded)

    private var productTile: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(.white)
            .frame(width: tileSize, height: tileSize)
            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
            .overlay(alignment: .topLeading) {
                Text("$50.00")
                    .font(.system(size: Tokens.captionSize, weight: .semibold))
                    .tracking(Tokens.cozyTracking)
                    .foregroundColor(.white)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(
                        Capsule(style: .continuous)
                            .fill(.black.opacity(0.30))
                    )
                    .padding(.top, 14)
                    .padding(.leading, 14)
            }
            .overlay(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(hex: 0xE0E0E0))
                    .frame(width: 36, height: 36)
                    .overlay {
                        Image("HeartOutlineIcon")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color(hex: 0x888888))
                    }
                    .padding(.bottom, 14)
                    .padding(.trailing, 14)
            }
            .zIndex(5)
    }
}

private struct ShoeSlide {
    let imageName: String
    let background: Color
}
