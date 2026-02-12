//
//  PileCard.swift
//  Shop feed playground
//
//  Interactive "pile" card — product cutouts on a colored card.
//  Drag items around. Tap to focus with merchant logo, info, price.
//  Data: PileCardData.swift
//

import SwiftUI

// MARK: - Pile Card

struct PileCard: View {
    @State private var items: [PileItem] = PileItem.defaults
    @State private var topZ: Double = 13
    @State private var focusedItemId: Int? = nil

    private var focusedItem: PileItem? {
        guard let id = focusedItemId else { return nil }
        return items.first { $0.id == id }
    }

    private var bgColor: Color {
        focusedItem?.dominantColor ?? Color(hex: 0xC4B4E0)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(bgColor)
                .animation(Tokens.springDefault, value: focusedItemId)

            // Header
            if focusedItemId == nil {
                CardHeader(subtitle: "Shop the bin", title: "Dig in to find something great")
                    .zIndex(50)
                    .transition(.opacity)
                    .allowsHitTesting(false)
            }

            // Draggable items
            ForEach($items) { $item in
                let isFocused = focusedItemId == item.id
                let isBackground = focusedItemId != nil && !isFocused

                DraggablePileItem(
                    item: $item, topZ: $topZ,
                    isFocused: isFocused,
                    disabled: isBackground,
                    onTap: {
                        withAnimation(Tokens.springDefault) {
                            if isFocused { focusedItemId = nil }
                            else {
                                focusedItemId = item.id
                                topZ += 1
                                item.zIndex = topZ
                            }
                        }
                    }
                )
                .blur(radius: isBackground ? 4 : 0)
                .opacity(isBackground ? 0.4 : 1)
                .animation(Tokens.springDefault, value: focusedItemId)
            }

            // Focused overlay (logo + shop button)
            if let focused = focusedItem {
                FocusedProductOverlay(item: focused) {
                    withAnimation(Tokens.springDefault) { focusedItemId = nil }
                }
                .zIndex(300)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }

            // Tap background to dismiss
            if focusedItemId != nil {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(Tokens.springDefault) { focusedItemId = nil }
                    }
                    .zIndex(-1)
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}

// MARK: - Card Header (reusable)

struct CardHeader: View {
    let subtitle: String
    let title: String
    var lightText: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(subtitle)
                .font(.system(size: Tokens.bodySmSize, weight: .semibold))
                .tracking(Tokens.cozyTracking)
                .foregroundColor(lightText ? .white.opacity(0.56) : Tokens.textTertiary)

            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .tracking(-1.0)
                .foregroundColor(lightText ? .white : Tokens.textPrimary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, Tokens.space20)
        .padding(.top, Tokens.space20)
    }
}

// MARK: - Focused Product Overlay

private struct FocusedProductOverlay: View {
    let item: PileItem
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            merchantLogo.padding(.top, 50)
            Spacer()
            Button(action: {}) {
                Text("Shop now")
                    .font(.system(size: Tokens.bodySize, weight: .semibold))
                    .tracking(Tokens.bodyTracking)
                    .foregroundColor(.black)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(.white))
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(true)
    }

    @ViewBuilder
    private var merchantLogo: some View {
        if let logoName = item.logoImage {
            Image(logoName)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(height: item.logoHeight)
        } else {
            Text(item.merchant)
                .font(.system(size: 18, weight: .black))
                .tracking(1.5)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Draggable Pile Item

private struct DraggablePileItem: View {
    @Binding var item: PileItem
    @Binding var topZ: Double
    let isFocused: Bool
    let disabled: Bool
    let onTap: () -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false

    private var focusedSize: CGSize {
        let maxW: CGFloat = Tokens.cardWidth - 80
        let maxH: CGFloat = 280
        let aspect = item.size.width / item.size.height
        return aspect > maxW / maxH
            ? CGSize(width: maxW, height: maxW / aspect)
            : CGSize(width: maxH * aspect, height: maxH)
    }

    var body: some View {
        VStack(spacing: Tokens.space12) {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: isFocused ? focusedSize.width : item.size.width,
                    height: isFocused ? focusedSize.height : item.size.height
                )

            if isFocused {
                VStack(spacing: Tokens.space12) {
                    Text(item.productName)
                        .font(.system(size: Tokens.bodySize, weight: .semibold))
                        .tracking(Tokens.bodyTracking)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text(item.price)
                        .font(.system(size: Tokens.bodySize, weight: .semibold))
                        .tracking(Tokens.bodyTracking)
                        .foregroundColor(.white)
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .rotationEffect(.degrees(isFocused ? 0 : item.rotation))
        .offset(
            x: isFocused ? 0 : item.offset.width + dragOffset.width,
            y: isFocused ? -20 : item.offset.height + dragOffset.height
        )
        .zIndex(item.zIndex + (isFocused ? 200 : (isDragging ? 100 : 0)))
        .scaleEffect(isDragging && !isFocused ? 1.1 : 1.0)
        .shadow(
            color: .black.opacity(isFocused ? 0.3 : (isDragging ? 0.35 : 0.2)),
            radius: isFocused ? 20 : (isDragging ? 16 : 6),
            x: 0, y: isFocused ? 16 : (isDragging ? 12 : 4)
        )
        .animation(Tokens.springDefault, value: isFocused)
        .animation(Tokens.springDrag, value: isDragging)
        .onTapGesture { onTap() }
        .gesture(
            isFocused ? nil :
            DragGesture()
                .onChanged { value in
                    if !isDragging { isDragging = true; topZ += 1; item.zIndex = topZ }
                    dragOffset = value.translation
                }
                .onEnded { value in
                    isDragging = false
                    item.offset.width += value.translation.width
                    item.offset.height += value.translation.height
                    dragOffset = .zero
                }
        )
        .allowsHitTesting(!disabled)
    }
}
