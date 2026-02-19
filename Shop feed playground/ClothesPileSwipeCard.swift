//
//  ClothesPileSwipeCard.swift
//  Shop feed playground
//
//  Gift-style swipe card using clothes pile hero assets.
//  Interaction and layout intentionally mirror ShoeSwipeCard.
//

import SwiftUI
import UIKit

struct ClothesPileSwipeCard: View {
    @State private var selectedIndex: Int = 0
    @State private var dragTranslation: CGFloat = 0
    @State private var hitEdge: Bool = false
    @State private var isExpanded: Bool = false
    @State private var isAreaFocused: Bool = false
    @State private var areaFocusOffset: CGSize = .zero
    @State private var focusedProduct: ClothesAreaProduct?
    @State private var productCardXOffset: CGFloat = 0

    private let slides: [ClothesPileSlide] = [
        .init(imageName: "OutfitFloat01", background: Color(hex: 0x2F3218)),
        .init(imageName: "OutfitFloat02", background: Color(hex: 0x262525)),
        .init(imageName: "OutfitFloat03", background: Color(hex: 0x331515)),
        .init(imageName: "OutfitFloat04", background: Color(hex: 0x2D3740)),
        .init(imageName: "OutfitFloat05", background: Color(hex: 0x3B2F2A)),
        .init(imageName: "OutfitFloat06", background: Color(hex: 0x28323D)),
        .init(imageName: "OutfitFloat07", background: Color(hex: 0x3A2E49)),
    ]

    private let itemWidth: CGFloat = 336
    private let itemHeight: CGFloat = 504
    private let itemSpacing: CGFloat = -110
    private let spreadMultiplier: CGFloat = 2.0
    private let tileSize: CGFloat = 242
    private let areaZoomScale: CGFloat = 1.30

    private func products(for imageName: String) -> [ClothesAreaProduct] {
        ClothesAreaProduct.byImageName[imageName] ?? ClothesAreaProduct.fallback
    }

    private func normalizedPoint(for location: CGPoint, in frameSize: CGSize) -> CGPoint {
        let width = max(frameSize.width, 1)
        let height = max(frameSize.height, 1)
        return CGPoint(
            x: min(max(location.x / width, 0), 1),
            y: min(max(location.y / height, 0), 1)
        )
    }

    private func pointDistance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        hypot(a.x - b.x, a.y - b.y)
    }

    private func nearestProduct(
        for imageName: String,
        location: CGPoint,
        frameSize: CGSize
    ) -> ClothesAreaProduct? {
        let spots = products(for: imageName)
        let normalized = normalizedPoint(for: location, in: frameSize)
        return spots.min {
            pointDistance($0.point, normalized) < pointDistance($1.point, normalized)
        }
    }

    private func floatingYOffset(for index: Int, time: TimeInterval, isActive: Bool) -> CGFloat {
        let speed = 0.86 + Double(index % 5) * 0.07
        let phase = Double(index) * 0.88
        let primary = sin(time * speed + phase)
        let secondary = sin(time * (speed * 0.56) + phase * 1.64)
        let amplitude: CGFloat = isActive ? 4.2 : 3.0
        return CGFloat(primary) * amplitude + CGFloat(secondary) * 1.15
    }

    private func focusOffset(for location: CGPoint, in frameSize: CGSize) -> CGSize {
        let rawX = (frameSize.width / 2 - location.x) * areaZoomScale
        let rawY = (frameSize.height / 2 - location.y) * areaZoomScale
        let maxX = (frameSize.width * (areaZoomScale - 1)) / 2
        let maxY = (frameSize.height * (areaZoomScale - 1)) / 2

        return CGSize(
            width: min(max(rawX, -maxX), maxX),
            height: min(max(rawY, -maxY), maxY)
        )
    }

    private func clearAreaFocus(animated: Bool = true) {
        let update = {
            isAreaFocused = false
            areaFocusOffset = .zero
            focusedProduct = nil
            productCardXOffset = 0
        }

        if animated {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.86, blendDuration: 0.2), update)
        } else {
            update()
        }
    }

    private var floatingProductCard: some View {
        VStack {
            Spacer()

            if let focusedProduct {
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(focusedProduct.title)
                            .shopTextStyle(.bodySmallBold)
                            .foregroundStyle(Tokens.ShopClient.text)
                            .lineLimit(1)

                        Text(focusedProduct.subtitle)
                            .shopTextStyle(.caption)
                            .foregroundStyle(Tokens.ShopClient.textSecondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 10)

                    Text(focusedProduct.price)
                        .shopTextStyle(.bodySmallBold)
                        .foregroundStyle(Tokens.ShopClient.text)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                        .fill(.white.opacity(0.94))
                        .overlay(
                            RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                                .stroke(Tokens.ShopClient.borderImage, lineWidth: 0.5)
                        )
                        .shadow(
                            color: Tokens.ShopClient.shadowMColor,
                            radius: Tokens.ShopClient.shadowMRadius,
                            x: 0,
                            y: Tokens.ShopClient.shadowMY
                        )
                )
                .offset(x: productCardXOffset)
                .padding(.horizontal, 22)
                .padding(.bottom, 54)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.24), value: focusedProduct?.id)
        .animation(.easeInOut(duration: 0.24), value: productCardXOffset)
    }

    var body: some View {
        let selectedSlide = slides[selectedIndex]

        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(selectedSlide.background)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                        .stroke(.white.opacity(0.06), lineWidth: 0.5)
                )
                .animation(.easeInOut(duration: 0.25), value: selectedIndex)

            let stride = itemWidth + itemSpacing

            TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: false)) { timeline in
                let t = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    if !isExpanded {
                        Ellipse()
                            .fill(.black.opacity(0.12))
                            .frame(width: 220, height: 28)
                            .blur(radius: 24)
                            .offset(y: 196)
                    }

                    if isExpanded {
                        productTile
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                            .zIndex(4)
                    }

                    ForEach(slides.indices, id: \.self) { index in
                        let relative = CGFloat(index - selectedIndex)
                        let isActive = index == selectedIndex

                        slideView(index: index, isActive: isActive, relative: relative, stride: stride, time: t)
                    }
                    .animation(Tokens.springExpand, value: isExpanded)
                    .animation(Tokens.springSnappy, value: selectedIndex)
                }
            }
            .offset(y: 20)

            VStack {
                Image("ShoeSwipeKithLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 48)
                    .padding(.top, 28)
                Spacer()
            }
            .allowsHitTesting(false)

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

            if !isExpanded {
                floatingProductCard
                    .allowsHitTesting(false)
            }
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .contentShape(Rectangle())
        .onChange(of: selectedIndex) { _, _ in
            clearAreaFocus(animated: false)
        }
        .onChange(of: isExpanded) { _, expanded in
            if expanded {
                clearAreaFocus(animated: false)
            }
        }
        .simultaneousGesture(
            isExpanded ? nil :
            DragGesture(minimumDistance: 20)
                .onChanged { value in
                    guard abs(value.translation.width) > abs(value.translation.height) else { return }

                    let translation = value.translation.width
                    let isPushingLeftEdge = selectedIndex == 0 && translation > 0
                    let isPushingRightEdge = selectedIndex == slides.count - 1 && translation < 0
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

                    newIndex = max(0, min(slides.count - 1, newIndex))

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

    @ViewBuilder
    private func slideView(index: Int, isActive: Bool, relative: CGFloat, stride: CGFloat, time: TimeInterval) -> some View {
        let expandedActive = isExpanded && isActive
        let frameSize = CGSize(
            width: expandedActive ? 278 : itemWidth,
            height: expandedActive ? 186 : itemHeight
        )
        let distanceFromCenter = abs(relative)
        let sideScale: CGFloat = {
            if isActive { return 1.15 }
            return 0.80
        }()
        let sideBlur: CGFloat = {
            if isExpanded || isActive { return 0 }
            if distanceFromCenter <= 1.0 { return 2.0 }
            return 3.2
        }()
        let zoomScale = (!isExpanded && isActive && isAreaFocused) ? areaZoomScale : 1.0
        let zoomOffset = (!isExpanded && isActive && isAreaFocused) ? areaFocusOffset : .zero
        let floatYOffset = isExpanded ? 0 : floatingYOffset(for: index, time: time, isActive: isActive)

        ClothesPileKeyedImage(imageName: slides[index].imageName)
            .scaleEffect(zoomScale)
            .offset(zoomOffset)
            .frame(
                width: frameSize.width,
                height: frameSize.height
            )
            .clipped()
            .rotationEffect(.degrees(expandedActive ? 90 : 0))
            .scaleEffect(expandedActive ? 1.0 : sideScale)
            .blur(radius: sideBlur)
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
                    : (relative * stride * spreadMultiplier + dragTranslation),
                y: (expandedActive ? -6 : -32) + floatYOffset
            )
            .zIndex(isActive ? 10 : 1)
            .gesture(
                SpatialTapGesture()
                    .onEnded { value in
                        guard isActive && !isExpanded else { return }
                        let normalized = normalizedPoint(for: value.location, in: frameSize)
                        let mappedProduct = nearestProduct(
                            for: slides[index].imageName,
                            location: value.location,
                            frameSize: frameSize
                        ) ?? products(for: slides[index].imageName).first

                        withAnimation(.spring(response: 0.42, dampingFraction: 0.84, blendDuration: 0.2)) {
                            isAreaFocused = true
                            areaFocusOffset = focusOffset(for: value.location, in: frameSize)
                            focusedProduct = mappedProduct
                            productCardXOffset = (normalized.x - 0.5) * 132
                        }
                        Haptics.light()
                    }
            )
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        guard isActive && !isExpanded else { return }
                        clearAreaFocus(animated: true)
                        Haptics.selection()
                    }
            )
    }

    private var productTile: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(.white)
            .frame(width: tileSize, height: tileSize)
            .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
            .overlay(alignment: .topLeading) {
                Text("$50.00")
                    .shopTextStyle(.captionBold)
                    .foregroundStyle(.white)
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
                            .foregroundStyle(Color(hex: 0x888888))
                    }
                    .padding(.bottom, 14)
                    .padding(.trailing, 14)
            }
            .zIndex(5)
    }
}

private struct ClothesPileSlide {
    let imageName: String
    let background: Color
}

private struct ClothesAreaProduct: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let price: String
    let point: CGPoint
}

private extension ClothesAreaProduct {
    static func make(
        _ id: String,
        _ title: String,
        _ subtitle: String,
        _ price: String,
        x: CGFloat,
        y: CGFloat
    ) -> ClothesAreaProduct {
        .init(
            id: id,
            title: title,
            subtitle: subtitle,
            price: price,
            point: .init(x: x, y: y)
        )
    }

    static let fallback: [ClothesAreaProduct] = [
        .make("fallback-top", "Layered top", "Cotton blend", "$88", x: 0.50, y: 0.40),
        .make("fallback-bottom", "Relaxed pants", "Straight fit", "$112", x: 0.30, y: 0.66),
        .make("fallback-shoes", "Low sneakers", "Cushioned sole", "$138", x: 0.72, y: 0.70),
    ]

    static let byImageName: [String: [ClothesAreaProduct]] = [
        "OutfitFloat01": [
            .make("o1-cap", "Logo cap", "Washed burgundy", "$42", x: 0.52, y: 0.15),
            .make("o1-jacket", "Pattern jacket", "Oversized fit", "$248", x: 0.52, y: 0.37),
            .make("o1-jeans", "Light denim", "Relaxed straight", "$128", x: 0.25, y: 0.62),
            .make("o1-tee", "Graphic tee", "Heavy jersey", "$54", x: 0.52, y: 0.74),
            .make("o1-shoes", "Court sneakers", "Leather low-top", "$168", x: 0.75, y: 0.67),
        ],
        "OutfitFloat02": [
            .make("o2-hat", "Knit beanie", "Soft ribbed wool", "$36", x: 0.49, y: 0.16),
            .make("o2-outer", "Coach jacket", "Matte shell finish", "$198", x: 0.52, y: 0.38),
            .make("o2-pants", "Utility trouser", "Relaxed taper", "$122", x: 0.28, y: 0.64),
            .make("o2-shirt", "Box tee", "Midweight cotton", "$48", x: 0.51, y: 0.73),
            .make("o2-shoe", "Retro runner", "Foam support", "$152", x: 0.74, y: 0.68),
        ],
        "OutfitFloat03": [
            .make("o3-hat", "Dad cap", "Brushed twill", "$34", x: 0.50, y: 0.15),
            .make("o3-shell", "Cropped shell", "Wind resistant", "$214", x: 0.52, y: 0.37),
            .make("o3-jean", "Vintage jean", "Loose straight", "$118", x: 0.26, y: 0.65),
            .make("o3-tee", "Core tee", "Soft heavyweight", "$46", x: 0.51, y: 0.74),
            .make("o3-shoes", "Trail shoes", "All-terrain grip", "$178", x: 0.74, y: 0.69),
        ],
        "OutfitFloat04": [
            .make("o4-cap", "Cord cap", "Structured brim", "$38", x: 0.51, y: 0.16),
            .make("o4-layer", "Plaid overshirt", "Brushed weave", "$162", x: 0.52, y: 0.38),
            .make("o4-pants", "Wide trouser", "Pressed twill", "$136", x: 0.28, y: 0.64),
            .make("o4-top", "Plain tee", "Premium cotton", "$42", x: 0.50, y: 0.74),
            .make("o4-shoe", "Court leather", "Minimal profile", "$158", x: 0.73, y: 0.69),
        ],
        "OutfitFloat05": [
            .make("o5-cap", "6-panel cap", "Stone wash", "$34", x: 0.50, y: 0.15),
            .make("o5-jacket", "Coach jacket", "Water resistant", "$176", x: 0.51, y: 0.37),
            .make("o5-pant", "Tech jogger", "Tapered fit", "$106", x: 0.29, y: 0.65),
            .make("o5-tee", "Logo tee", "Relaxed fit", "$52", x: 0.50, y: 0.74),
            .make("o5-shoe", "Foam runner", "Cloud midsole", "$148", x: 0.74, y: 0.69),
        ],
        "OutfitFloat06": [
            .make("o6-hat", "Beanie", "Merino blend", "$40", x: 0.50, y: 0.15),
            .make("o6-shirt", "Oxford shirt", "Crisp cotton", "$92", x: 0.51, y: 0.37),
            .make("o6-bottom", "Indigo jean", "Mid-rise straight", "$124", x: 0.27, y: 0.64),
            .make("o6-knit", "Cable vest", "Layer friendly", "$96", x: 0.51, y: 0.74),
            .make("o6-loafer", "Penny loafer", "Soft leather", "$176", x: 0.74, y: 0.69),
        ],
        "OutfitFloat07": [
            .make("o7-cap", "Work cap", "Faded black", "$36", x: 0.50, y: 0.15),
            .make("o7-jacket", "Chore jacket", "Boxy silhouette", "$154", x: 0.52, y: 0.37),
            .make("o7-chino", "Relaxed chino", "Garment dyed", "$108", x: 0.29, y: 0.65),
            .make("o7-henley", "Waffle henley", "Natural stretch", "$58", x: 0.51, y: 0.74),
            .make("o7-shoe", "Canvas high-top", "Flexible sole", "$82", x: 0.74, y: 0.69),
        ],
    ]
}

private struct ClothesPileKeyedImage: View {
    let imageName: String
    @State private var processedImage: UIImage?

    var body: some View {
        Group {
            if let processedImage {
                Image(uiImage: processedImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            }
        }
        .task(id: imageName) {
            processedImage = await ClothesPileBlackKeyProcessor.shared.processedImage(named: imageName)
        }
    }
}

private actor ClothesPileBlackKeyProcessor {
    static let shared = ClothesPileBlackKeyProcessor()
    private var cache: [String: UIImage] = [:]

    func processedImage(named name: String) async -> UIImage? {
        if let cached = cache[name] {
            return cached
        }

        guard let source = await MainActor.run(body: { UIImage(named: name) }) else {
            return nil
        }

        let processed = Self.removeNearBlackBackground(from: source) ?? source
        cache[name] = processed
        return processed
    }

    private static func removeNearBlackBackground(from image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bufferSize = bytesPerRow * height
        var data = [UInt8](repeating: 0, count: bufferSize)

        guard let context = CGContext(
            data: &data,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        // Key out near-black matte while preserving darker garment details.
        let hardCut: UInt8 = 8
        let softCut: UInt8 = 22

        for pixelIndex in stride(from: 0, to: bufferSize, by: bytesPerPixel) {
            let r = data[pixelIndex]
            let g = data[pixelIndex + 1]
            let b = data[pixelIndex + 2]
            let maxChannel = max(r, max(g, b))

            if maxChannel <= hardCut {
                data[pixelIndex + 3] = 0
            } else if maxChannel < softCut {
                let range = Float(softCut - hardCut)
                let t = Float(maxChannel - hardCut) / range
                let alpha = Float(data[pixelIndex + 3]) * t
                data[pixelIndex + 3] = UInt8(max(0, min(255, Int(alpha))))
            }
        }

        guard let outputCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
