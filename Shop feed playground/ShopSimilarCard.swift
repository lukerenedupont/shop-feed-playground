//
//  ShopSimilarCard.swift
//  Shop feed playground
//
//  Tap carousel shoe → 3×3 grid appears.
//  Tap any grid shoe → smooth hero transition to center (matchedGeometryEffect).
//  Tap background → shoe flies back to grid.
//

import SwiftUI

struct ShopSimilarCard: View {
    @State private var selectedIndex: Int = 0
    @State private var dragTranslation: CGFloat = 0
    @State private var hitEdge: Bool = false
    @State private var isExpanded: Bool = false
    @State private var showGrid: Bool = false
    @State private var focusedShoe: Int? = nil

    @Namespace private var heroNS

    private let shoes: [ShopSimilarSlide] = [
        .init(imageName: "ShoeSwipeGreen", background: Color(hex: 0x2F3218)),
        .init(imageName: "ShoeSwipeBlack", background: Color(hex: 0x262525)),
        .init(imageName: "ShoeSwipeWhiteRed", background: Color(hex: 0x331515)),
    ]

    private let shoeWidth: CGFloat = 336
    private let shoeHeight: CGFloat = 504
    private let shoeSpacing: CGFloat = -110
    private let gridSpacing: CGFloat = 6

    private var tileSize: CGFloat {
        floor((Tokens.cardWidth - 32 - gridSpacing * 2) / 3)
    }

    private let gridShoes: [String] = [
        "SimilarShoe1", "SimilarShoe2", "SimilarShoe3", "SimilarShoe4",
        "SimilarShoe5", "SimilarShoe6", "SimilarShoe7", "SimilarShoe8",
    ]

    private let shoeRotations: [Double] = [
        -78, -95, -85, -100, -72, -88, -105, -82
    ]

    // iOS-style spring — matches UIKit's default interactive spring
    private let heroSpring = Animation.spring(response: 0.6, dampingFraction: 0.86)

    var body: some View {
        let selectedShoe = shoes[selectedIndex]
        let hasFocus = focusedShoe != nil

        ZStack {
            // Background
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(selectedShoe.background)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                )
                .animation(.easeInOut(duration: 0.25), value: selectedIndex)

            let stride = shoeWidth + shoeSpacing

            // Ground shadow
            if !isExpanded {
                Ellipse()
                    .fill(.black.opacity(0.12))
                    .frame(width: 220, height: 28)
                    .blur(radius: 24)
                    .offset(y: 196)
            }

            // === CAROUSEL MODE ===
            if !showGrid {
                ForEach(shoes.indices, id: \.self) { index in
                    let relative = CGFloat(index - selectedIndex)
                    let isActive = index == selectedIndex
                    let expandedActive = isExpanded && isActive

                    Image(shoes[index].imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: expandedActive ? tileSize * 1.5 : shoeWidth,
                            height: expandedActive ? tileSize * 1.5 : shoeHeight
                        )
                        .rotationEffect(.degrees(expandedActive ? 45 : 0))
                        .scaleEffect(isActive ? 1.0 : 0.9)
                        .opacity(isActive ? 1.0 : 0.98)
                        .shadow(color: .black.opacity(isActive ? 0.10 : 0.05), radius: isActive ? 20 : 12, x: 0, y: isActive ? 12 : 6)
                        .offset(
                            x: isExpanded ? (isActive ? 0 : (relative < 0 ? -500 : 500)) : (relative * stride + dragTranslation),
                            y: expandedActive ? 0 : -32
                        )
                        .onTapGesture {
                            guard isActive else { return }
                            expand()
                        }
                }
                .animation(.spring(response: 0.45, dampingFraction: 0.8), value: isExpanded)
                .animation(Tokens.springSnappy, value: selectedIndex)
            }

            // === GRID MODE ===
            if showGrid {
                // Center carousel shoe
                Image(shoes[selectedIndex].imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: tileSize * 1.5, height: tileSize * 1.5)
                    .rotationEffect(.degrees(45))
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                    .opacity(hasFocus ? 0 : 1)
                    .allowsHitTesting(false)
                    .animation(heroSpring, value: hasFocus)

                // Grid — each shoe is always present, just changes position/size
                ZStack {
                    ForEach(0..<8, id: \.self) { i in
                        let isFocused = focusedShoe == i
                        let otherFocused = hasFocus && !isFocused
                        let slot = i < 4 ? i : i + 1  // skip center slot 4
                        let col = slot % 3
                        let row = slot / 3
                        let cellStride = tileSize + gridSpacing
                        let gridX = CGFloat(col - 1) * cellStride
                        let gridY = CGFloat(row - 1) * (cellStride + (row == 0 ? -60 : (row == 2 ? 60 : 0)))
                            + (row == 1 ? 0 : (row == 0 ? -60 : 60))

                        Image(gridShoes[i])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(
                                width: isFocused ? Tokens.cardWidth * 0.7 : tileSize,
                                height: isFocused ? Tokens.cardWidth * 0.7 : tileSize
                            )
                            .rotationEffect(.degrees(isFocused ? shoeRotations[i] * 0.25 : shoeRotations[i]))
                            .shadow(
                                color: .black.opacity(isFocused ? 0.3 : 0),
                                radius: isFocused ? 30 : 0,
                                x: 0, y: isFocused ? 16 : 0
                            )
                            .offset(
                                x: isFocused ? 0 : gridX,
                                y: isFocused ? 0 : gridY
                            )
                            .opacity(otherFocused ? 0 : 1)
                            .scaleEffect(otherFocused ? 0.6 : 1)
                            .animation(heroSpring, value: focusedShoe)
                            .zIndex(isFocused ? 50 : 0)
                            .onTapGesture {
                                Haptics.light()
                                withAnimation(heroSpring) {
                                    if isFocused {
                                        focusedShoe = nil
                                    } else {
                                        focusedShoe = i
                                    }
                                }
                            }
                    }
                }
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }

            // Tap background to unfocus or collapse
            if isExpanded {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if hasFocus {
                            Haptics.light()
                            withAnimation(heroSpring) { focusedShoe = nil }
                        } else {
                            collapse()
                        }
                    }
                    .zIndex(-1)
            }

            // Close button
            if showGrid {
                Button {
                    if hasFocus {
                        withAnimation(heroSpring) { focusedShoe = nil }
                    }
                    collapse()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white.opacity(0.6))
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(.white.opacity(0.12)))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 16)
                .padding(.trailing, 16)
                .transition(.opacity)
                .animation(.easeOut(duration: 0.2), value: showGrid)
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
                    if isAtEdge && !hitEdge { Haptics.soft(intensity: 0.5); hitEdge = true }
                    else if !isAtEdge { hitEdge = false }
                    dragTranslation = isAtEdge ? translation * 0.24 : translation
                }
                .onEnded { value in
                    hitEdge = false
                    guard abs(value.translation.width) > abs(value.translation.height) else {
                        withAnimation(Tokens.springDefault) { dragTranslation = 0 }; return
                    }
                    let projected = value.predictedEndTranslation.width
                    var newIndex = selectedIndex
                    if projected < -70 { newIndex += 1 } else if projected > 70 { newIndex -= 1 }
                    newIndex = max(0, min(shoes.count - 1, newIndex))
                    if newIndex != selectedIndex { Haptics.selection() }
                    withAnimation(Tokens.springSnappy) { selectedIndex = newIndex; dragTranslation = 0 }
                }
        )
    }

    // MARK: - Actions

    private func expand() {
        Haptics.light()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { isExpanded = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) { showGrid = true }
        }
    }

    private func collapse() {
        Haptics.light()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { showGrid = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { isExpanded = false }
        }
    }
}

private struct ShopSimilarSlide {
    let imageName: String
    let background: Color
}
