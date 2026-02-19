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
    @State private var focusedChipOffset: CGSize = .zero
    @State private var focusedHotspot: ClothesAreaHotspot?
    @State private var favoritedHotspotIDs: Set<String> = []
    @State private var logoDisplayedIndex: Int = 0
    @State private var logoIncomingIndex: Int?
    @State private var logoRollProgress: CGFloat = 0
    @State private var logoRollID: UUID = .init()

    private let slides: [ClothesPileSlide] = [
        .init(imageName: "OutfitFloat01", logoImageName: "ClothesLogoGalleryDept", background: Color(hex: 0x2F3218)),
        .init(imageName: "OutfitFloat02", logoImageName: "ClothesLogoJnco", background: Color(hex: 0x262525)),
        .init(imageName: "OutfitFloat03", logoImageName: "ClothesLogoComfrt", background: Color(hex: 0x331515)),
        .init(imageName: "OutfitFloat04", logoImageName: "ClothesLogoAffliction", background: Color(hex: 0x2D3740)),
        .init(imageName: "OutfitFloat05", logoImageName: "ClothesLogoTrueClassic", background: Color(hex: 0x3B2F2A)),
        .init(imageName: "OutfitFloat06", logoImageName: "ClothesLogoKicksCrew", background: Color(hex: 0x28323D)),
        .init(imageName: "OutfitFloat07", logoImageName: "ClothesLogoYoungLA", background: Color(hex: 0x3A2E49)),
    ]

    private let itemWidth: CGFloat = 336
    private let itemHeight: CGFloat = 504
    private let itemSpacing: CGFloat = -110
    private let spreadMultiplier: CGFloat = 2.0
    private let tileSize: CGFloat = 242
    private let areaZoomScale: CGFloat = 1.30

    private func hotspots(for imageName: String) -> [ClothesAreaHotspot] {
        ClothesAreaHotspot.byImageName[imageName] ?? ClothesAreaHotspot.fallback
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

    private func nearestHotspot(
        for imageName: String,
        location: CGPoint,
        frameSize: CGSize
    ) -> ClothesAreaHotspot? {
        let points = hotspots(for: imageName)
        let normalized = normalizedPoint(for: location, in: frameSize)
        return points.min { lhs, rhs in
            pointDistance(lhs.point, normalized) < pointDistance(rhs.point, normalized)
        }
    }

    private enum LogoRollLayout {
        static let width: CGFloat = 240
        static let height: CGFloat = 62
        static let travelDistance: CGFloat = 102
        static let animationDuration: Double = 0.38
        static let animation = Animation.timingCurve(0.18, 0.86, 0.2, 1, duration: animationDuration)
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

    private func chipOffset(for location: CGPoint, in frameSize: CGSize) -> CGSize {
        let x = (location.x - frameSize.width / 2) * 0.72
        let y = (location.y - frameSize.height / 2) * 0.72 + 8
        let maxX = frameSize.width * 0.30
        let maxY = frameSize.height * 0.30

        return CGSize(
            width: min(max(x, -maxX), maxX),
            height: min(max(y, -maxY), maxY)
        )
    }

    private func clearAreaFocus(animated: Bool = true) {
        let update = {
            isAreaFocused = false
            areaFocusOffset = .zero
            focusedChipOffset = .zero
            focusedHotspot = nil
        }

        if animated {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.86, blendDuration: 0.2), update)
        } else {
            update()
        }
    }

    @ViewBuilder
    private func areaPriceChip(for hotspot: ClothesAreaHotspot) -> some View {
        let isFavorite = favoritedHotspotIDs.contains(hotspot.id)
        let chipShape = Capsule(style: .continuous)
        let chipContent = HStack(spacing: 10) {
            Text(hotspot.price)
                .shopTextStyle(.bodySmallBold)
                .foregroundStyle(.white)

            Spacer(minLength: 8)

            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if isFavorite {
                        favoritedHotspotIDs.remove(hotspot.id)
                    } else {
                        favoritedHotspotIDs.insert(hotspot.id)
                    }
                }
                Haptics.light()
            } label: {
                Circle()
                    .fill(.white.opacity(0.22))
                    .frame(width: 28, height: 28)
                    .overlay {
                        Image(isFavorite ? "HeartIcon" : "HeartOutlineIcon")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.white)
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(width: 128, height: 46)

        if #available(iOS 26.0, *) {
            chipContent
                .background(.ultraThinMaterial, in: chipShape)
                .background(
                    chipShape
                        .fill(Color(hex: 0x35537B).opacity(0.56))
                )
                .overlay(
                    chipShape
                        .stroke(.white.opacity(0.45), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.20), radius: 10, x: 0, y: 4)
                .glassEffect(.regular.interactive(), in: .capsule)
        } else {
            chipContent
                .background(.ultraThinMaterial, in: chipShape)
                .background(
                    chipShape
                        .fill(Color(hex: 0x35537B).opacity(0.56))
                )
                .overlay(
                    chipShape
                        .stroke(.white.opacity(0.45), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.20), radius: 10, x: 0, y: 4)
        }
    }

    private var slotLogoView: some View {
        let rollPhase: CGFloat = min(1, max(0, -logoRollProgress))

        return ZStack {
            logoImageView(for: logoDisplayedIndex)
                .offset(y: logoRollProgress * LogoRollLayout.travelDistance)
                .opacity(Double(1 - rollPhase * 0.52))
                .blur(radius: rollPhase * 0.9)

            if let logoIncomingIndex {
                logoImageView(for: logoIncomingIndex)
                    .offset(y: (logoRollProgress + 1) * LogoRollLayout.travelDistance)
                    .opacity(Double(0.55 + rollPhase * 0.45))
                    .blur(radius: (1 - rollPhase) * 0.9)
            }
        }
        .frame(width: LogoRollLayout.width, height: LogoRollLayout.height)
        .clipped()
    }

    private func logoImageView(for index: Int) -> some View {
        let bounded = min(max(index, 0), max(0, slides.count - 1))
        return Image(slides[bounded].logoImageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: LogoRollLayout.width, height: LogoRollLayout.height)
    }

    private func rollLogo(to newIndex: Int) {
        guard !slides.isEmpty else { return }
        let bounded = min(max(newIndex, 0), slides.count - 1)
        guard bounded != logoDisplayedIndex || logoIncomingIndex != nil else { return }

        if let logoIncomingIndex {
            logoDisplayedIndex = logoIncomingIndex
            self.logoIncomingIndex = nil
            logoRollProgress = 0
        }

        let rollID = UUID()
        logoRollID = rollID
        logoIncomingIndex = bounded
        logoRollProgress = 0

        withAnimation(LogoRollLayout.animation) {
            logoRollProgress = -1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + LogoRollLayout.animationDuration) {
            guard logoRollID == rollID else { return }
            logoDisplayedIndex = bounded
            logoIncomingIndex = nil
            logoRollProgress = 0
        }
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
                slotLogoView
                    .padding(.top, 28)
                Spacer()
            }
            .allowsHitTesting(false)

            VStack {
                Spacer()
                Button(action: { Haptics.light() }) {
                    Text("Shop now")
                        .shopTextStyle(.bodyLargeBold)
                        .foregroundStyle(selectedSlide.background)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(
                            Capsule(style: .continuous)
                                .fill(.white)
                        )
                }
                .padding(.bottom, 36)
                .opacity(isExpanded ? 0 : 1)
                .animation(.easeInOut(duration: 0.2), value: isExpanded)
            }

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
        .onAppear {
            logoDisplayedIndex = selectedIndex
            logoIncomingIndex = nil
            logoRollProgress = 0
        }
        .onChange(of: selectedIndex) { _, _ in
            clearAreaFocus(animated: false)
        }
        .onChange(of: selectedIndex) { _, newValue in
            rollLogo(to: newValue)
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
            .overlay {
                if isActive, !isExpanded, isAreaFocused, let focusedHotspot {
                    areaPriceChip(for: focusedHotspot)
                        .offset(x: focusedChipOffset.width, y: focusedChipOffset.height)
                        .transition(.scale(scale: 0.92).combined(with: .opacity))
                        .animation(.spring(response: 0.34, dampingFraction: 0.82), value: focusedHotspot.id)
                }
            }
            .gesture(
                SpatialTapGesture()
                    .onEnded { value in
                        guard isActive && !isExpanded else { return }
                        let mappedHotspot = nearestHotspot(
                            for: slides[index].imageName,
                            location: value.location,
                            frameSize: frameSize
                        ) ?? hotspots(for: slides[index].imageName).first

                        withAnimation(.spring(response: 0.42, dampingFraction: 0.84, blendDuration: 0.2)) {
                            isAreaFocused = true
                            areaFocusOffset = focusOffset(for: value.location, in: frameSize)
                            focusedChipOffset = chipOffset(for: value.location, in: frameSize)
                            focusedHotspot = mappedHotspot
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
    let logoImageName: String
    let background: Color
}

private struct ClothesAreaHotspot: Identifiable {
    let id: String
    let point: CGPoint
    let price: String

    private static func make(_ imageName: String, _ x: CGFloat, _ y: CGFloat, _ price: String, index: Int) -> ClothesAreaHotspot {
        ClothesAreaHotspot(
            id: "\(imageName)-\(index)",
            point: CGPoint(x: x, y: y),
            price: price
        )
    }

    static let byImageName: [String: [ClothesAreaHotspot]] = [
        "OutfitFloat01": [
            make("OutfitFloat01", 0.50, 0.30, "$188", index: 0),
            make("OutfitFloat01", 0.36, 0.48, "$84", index: 1),
            make("OutfitFloat01", 0.62, 0.58, "$142", index: 2),
            make("OutfitFloat01", 0.49, 0.78, "$96", index: 3),
        ],
        "OutfitFloat02": [
            make("OutfitFloat02", 0.46, 0.26, "$210", index: 0),
            make("OutfitFloat02", 0.33, 0.48, "$128", index: 1),
            make("OutfitFloat02", 0.59, 0.56, "$76", index: 2),
            make("OutfitFloat02", 0.52, 0.80, "$104", index: 3),
        ],
        "OutfitFloat03": [
            make("OutfitFloat03", 0.55, 0.24, "$164", index: 0),
            make("OutfitFloat03", 0.38, 0.44, "$92", index: 1),
            make("OutfitFloat03", 0.62, 0.56, "$138", index: 2),
            make("OutfitFloat03", 0.47, 0.78, "$88", index: 3),
        ],
        "OutfitFloat04": [
            make("OutfitFloat04", 0.48, 0.28, "$236", index: 0),
            make("OutfitFloat04", 0.34, 0.50, "$66", index: 1),
            make("OutfitFloat04", 0.60, 0.58, "$124", index: 2),
            make("OutfitFloat04", 0.50, 0.79, "$112", index: 3),
        ],
        "OutfitFloat05": [
            make("OutfitFloat05", 0.52, 0.27, "$172", index: 0),
            make("OutfitFloat05", 0.35, 0.46, "$98", index: 1),
            make("OutfitFloat05", 0.61, 0.60, "$152", index: 2),
            make("OutfitFloat05", 0.47, 0.80, "$74", index: 3),
        ],
        "OutfitFloat06": [
            make("OutfitFloat06", 0.50, 0.30, "$198", index: 0),
            make("OutfitFloat06", 0.35, 0.52, "$106", index: 1),
            make("OutfitFloat06", 0.63, 0.56, "$86", index: 2),
            make("OutfitFloat06", 0.48, 0.80, "$118", index: 3),
        ],
        "OutfitFloat07": [
            make("OutfitFloat07", 0.50, 0.28, "$146", index: 0),
            make("OutfitFloat07", 0.36, 0.50, "$82", index: 1),
            make("OutfitFloat07", 0.62, 0.59, "$134", index: 2),
            make("OutfitFloat07", 0.49, 0.80, "$92", index: 3),
        ],
    ]

    static let fallback: [ClothesAreaHotspot] = [
        make("fallback", 0.50, 0.32, "$120", index: 0),
        make("fallback", 0.36, 0.54, "$88", index: 1),
        make("fallback", 0.62, 0.60, "$144", index: 2),
        make("fallback", 0.49, 0.80, "$96", index: 3),
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
