//
//  OutfitFloatGridCard.swift
//  Shop feed playground
//
//  Floating outfit grid with subtle out-of-phase bounce.
//

import SwiftUI
import UIKit

struct OutfitFloatGridCard: View {
    @State private var centerIndex: Int = 0
    @State private var selectedSpotByOutfitID: [String: String] = [:]
    @State private var draggingSlot: CornerSlot?
    @State private var dragTranslation: CGSize = .zero

    private let outfits = OutfitFloatItem.defaults

    private enum CornerSlot: CaseIterable, Hashable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight

        var unitOffset: CGSize {
            switch self {
            case .topLeft: return .init(width: -1, height: -1)
            case .topRight: return .init(width: 1, height: -1)
            case .bottomLeft: return .init(width: -1, height: 1)
            case .bottomRight: return .init(width: 1, height: 1)
            }
        }

        var indexOffset: Int {
            switch self {
            case .topLeft: return -2
            case .topRight: return 1
            case .bottomLeft: return -1
            case .bottomRight: return 2
            }
        }

        var sphereXTiltDegrees: Double {
            switch self {
            case .topLeft, .topRight: return -22
            case .bottomLeft, .bottomRight: return 22
            }
        }

        var sphereYTiltDegrees: Double {
            switch self {
            case .topLeft, .bottomLeft: return 22
            case .topRight, .bottomRight: return -22
            }
        }
    }

    private enum Layout {
        static let horizontalPadding: CGFloat = 18
        static let verticalPadding: CGFloat = 22
        static let itemScale: CGFloat = 1.86
        static let borderOpacity: Double = 0.10
        static let itemShadowOpacity: Double = 0.62
        static let backgroundDetailBottomPadding: CGFloat = 16

        static let focusScaleFront: CGFloat = 1.02
        static let cornerScale: CGFloat = 0.48
        static let cornerOpacity: CGFloat = 0.96
        static let cornerSaturation: CGFloat = 1.00
        static let cornerBlur: CGFloat = 0
        static let centerDrift: CGFloat = 0.26
        static let cornerDrift: CGFloat = 0.34
        static let gridSlotInset: CGFloat = 34
        static let spherePerspective: CGFloat = 0.65
        static let cornerBackBrightness: CGFloat = -0.12

        static let snapDistance: CGFloat = 86
        static let snapResponse: Double = 0.46
        static let snapDamping: Double = 0.84
    }

    private func lunarOffset(for outfit: OutfitFloatItem, time: TimeInterval) -> CGSize {
        let phase = time * outfit.floatSpeed + outfit.phase
        let x = cos(phase) * outfit.floatRadius.width
            + sin(phase * 0.63 + outfit.phase) * outfit.secondaryRadius.width
        let y = sin(phase) * outfit.floatRadius.height
            + cos(phase * 0.58 + outfit.phase) * outfit.secondaryRadius.height
        return CGSize(width: x, height: y)
    }

    private func lunarRotation(for outfit: OutfitFloatItem, time: TimeInterval) -> Angle {
        let wobble = sin(time * outfit.rotationSpeed + outfit.phase) * outfit.rotationAmplitude
        return .degrees(outfit.baseRotation + wobble)
    }

    private func lunarScale(for outfit: OutfitFloatItem, time: TimeInterval) -> CGFloat {
        1 + CGFloat(sin(time * (outfit.floatSpeed * 0.8) + outfit.phase)) * outfit.scaleAmplitude
    }

    private func wrappedIndex(_ index: Int) -> Int {
        let count = outfits.count
        guard count > 0 else { return 0 }
        let normalized = index % count
        return normalized >= 0 ? normalized : (normalized + count)
    }

    private func outfit(at index: Int) -> OutfitFloatItem {
        outfits[wrappedIndex(index)]
    }

    private func detailSpots(for outfit: OutfitFloatItem) -> [OutfitDetailSpot] {
        OutfitDetailSpot.byImageName[outfit.imageName] ?? OutfitDetailSpot.fallback
    }

    private var focusedOutfit: OutfitFloatItem {
        outfit(at: centerIndex)
    }

    private var focusedSpots: [OutfitDetailSpot] {
        let spots = detailSpots(for: focusedOutfit)
        return spots.isEmpty ? OutfitDetailSpot.fallback : spots
    }

    private var focusedSpotID: String? {
        selectedSpotByOutfitID[focusedOutfit.id] ?? focusedSpots.first?.id
    }

    private var selectedSpot: OutfitDetailSpot? {
        guard let focusedSpotID else { return focusedSpots.first }
        return focusedSpots.first(where: { $0.id == focusedSpotID }) ?? focusedSpots.first
    }

    private func ensureFocusedSpotSelection() {
        guard let firstID = focusedSpots.first?.id else { return }
        if selectedSpotByOutfitID[focusedOutfit.id] == nil {
            selectedSpotByOutfitID[focusedOutfit.id] = firstID
        }
    }

    private func cornerIndex(for slot: CornerSlot) -> Int {
        wrappedIndex(centerIndex + slot.indexOffset)
    }

    private func cornerPosition(for slot: CornerSlot, in size: CGSize) -> CGPoint {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let distance = max(
            0,
            min(
                (size.width / 2) - Layout.gridSlotInset,
                (size.height / 2) - Layout.gridSlotInset
            )
        )
        return CGPoint(
            x: center.x + slot.unitOffset.width * distance,
            y: center.y + slot.unitOffset.height * distance
        )
    }

    private func distance(_ lhs: CGPoint, _ rhs: CGPoint) -> CGFloat {
        hypot(lhs.x - rhs.x, lhs.y - rhs.y)
    }

    private func dragProgress(
        for slot: CornerSlot,
        basePosition: CGPoint,
        centerPosition: CGPoint
    ) -> CGFloat {
        guard draggingSlot == slot else { return 0 }
        let startDistance = distance(basePosition, centerPosition)
        guard startDistance > 0.0001 else { return 0 }

        let currentPosition = CGPoint(
            x: basePosition.x + dragTranslation.width,
            y: basePosition.y + dragTranslation.height
        )
        let currentDistance = distance(currentPosition, centerPosition)
        let progress = 1 - (currentDistance / startDistance)
        return max(0, min(1, progress))
    }

    private func cornerDragGesture(
        for slot: CornerSlot,
        basePosition: CGPoint,
        centerPosition: CGPoint,
        targetIndex: Int
    ) -> some Gesture {
        DragGesture(minimumDistance: 2)
            .onChanged { value in
                guard draggingSlot == nil || draggingSlot == slot else { return }
                draggingSlot = slot
                dragTranslation = value.translation
            }
            .onEnded { value in
                guard draggingSlot == slot else { return }

                let projectedPoint = CGPoint(
                    x: basePosition.x + value.predictedEndTranslation.width,
                    y: basePosition.y + value.predictedEndTranslation.height
                )
                let shouldSnap = distance(projectedPoint, centerPosition) <= Layout.snapDistance

                withAnimation(.spring(response: Layout.snapResponse, dampingFraction: Layout.snapDamping, blendDuration: 0.2)) {
                    if shouldSnap {
                        centerIndex = targetIndex
                    }
                    draggingSlot = nil
                    dragTranslation = .zero
                }

                if shouldSnap {
                    Haptics.selection()
                }
            }
    }

    private var backgroundGradient: some View {
        RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color(hex: 0xFCFAF5), Color(hex: 0xF4EEE4), Color(hex: 0xEEE6D8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.34), .clear],
                            center: .topLeading,
                            startRadius: 10,
                            endRadius: 280
                        )
                    )
            )
    }

    private var detailCardOverlay: some View {
        VStack {
            Spacer()

            if let spot = selectedSpot {
                HStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(spot.title)
                            .shopTextStyle(.bodySmallBold)
                            .foregroundStyle(Tokens.ShopClient.text)
                            .lineLimit(1)

                        Text(spot.subtitle)
                            .shopTextStyle(.caption)
                            .foregroundStyle(Tokens.ShopClient.textSecondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 10)

                    Text(spot.price)
                        .shopTextStyle(.bodySmallBold)
                        .foregroundStyle(Tokens.ShopClient.text)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: Tokens.radius12, style: .continuous)
                        .fill(.white.opacity(0.92))
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
                .padding(.horizontal, Layout.horizontalPadding)
                .padding(.bottom, Layout.backgroundDetailBottomPadding)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.24), value: focusedOutfit.id)
        .animation(.easeInOut(duration: 0.24), value: focusedSpotID)
    }

    @ViewBuilder
    private func focusedNode(
        time: TimeInterval,
        viewportSize: CGSize
    ) -> some View {
        let outfit = focusedOutfit
        let drift = lunarOffset(for: outfit, time: time)
        let focusedScale = lunarScale(for: outfit, time: time) * Layout.focusScaleFront

        OutfitKeyedImage(imageName: outfit.imageName)
            .frame(
                width: outfit.size * Layout.itemScale,
                height: outfit.size * Layout.itemScale
            )
            .rotationEffect(lunarRotation(for: outfit, time: time))
            .scaleEffect(focusedScale)
            .position(
                x: (viewportSize.width / 2) + (drift.width * Layout.centerDrift),
                y: (viewportSize.height / 2) + (drift.height * Layout.centerDrift)
            )
            .shadow(
                color: Tokens.ShopClient.shadowMColor.opacity(Layout.itemShadowOpacity),
                radius: Tokens.ShopClient.shadowMRadius,
                x: 0,
                y: Tokens.ShopClient.shadowMY
            )
            .zIndex(20)
            .animation(.spring(response: 0.42, dampingFraction: 0.84, blendDuration: 0.2), value: centerIndex)
    }

    @ViewBuilder
    private func cornerNode(
        slot: CornerSlot,
        time: TimeInterval,
        viewportSize: CGSize,
        centerPosition: CGPoint
    ) -> some View {
        let itemIndex = cornerIndex(for: slot)
        let outfit = outfit(at: itemIndex)
        let basePosition = cornerPosition(for: slot, in: viewportSize)
        let localProgress = dragProgress(for: slot, basePosition: basePosition, centerPosition: centerPosition)
        let localOffset = draggingSlot == slot ? dragTranslation : .zero
        let drift = lunarOffset(for: outfit, time: time)

        let cornerScale = Layout.cornerScale + (Layout.focusScaleFront - Layout.cornerScale) * localProgress * 0.9
        let cornerOpacity = Double(Layout.cornerOpacity + (1 - Layout.cornerOpacity) * localProgress)
        let cornerSaturation = Double(Layout.cornerSaturation + (1 - Layout.cornerSaturation) * localProgress)
        let cornerBlur = Layout.cornerBlur * (1 - localProgress)
        let xTilt = slot.sphereXTiltDegrees * (1 - localProgress)
        let yTilt = slot.sphereYTiltDegrees * (1 - localProgress)
        let backBrightness = Layout.cornerBackBrightness * (1 - localProgress)

        OutfitKeyedImage(imageName: outfit.imageName)
            .frame(
                width: outfit.size * Layout.itemScale,
                height: outfit.size * Layout.itemScale
            )
            .rotationEffect(lunarRotation(for: outfit, time: time))
            .scaleEffect(lunarScale(for: outfit, time: time) * cornerScale)
            .rotation3DEffect(
                .degrees(xTilt),
                axis: (x: 1, y: 0, z: 0),
                perspective: Layout.spherePerspective
            )
            .rotation3DEffect(
                .degrees(yTilt),
                axis: (x: 0, y: 1, z: 0),
                perspective: Layout.spherePerspective
            )
            .position(
                x: basePosition.x + (drift.width * Layout.cornerDrift) + localOffset.width,
                y: basePosition.y + (drift.height * Layout.cornerDrift) + localOffset.height
            )
            .blur(radius: cornerBlur)
            .opacity(cornerOpacity)
            .saturation(cornerSaturation)
            .brightness(backBrightness)
            .shadow(
                color: Tokens.ShopClient.shadowMColor.opacity(Layout.itemShadowOpacity),
                radius: Tokens.ShopClient.shadowMRadius,
                x: 0,
                y: Tokens.ShopClient.shadowMY
            )
            .zIndex(draggingSlot == slot ? 24 : 6)
            .animation(.spring(response: 0.38, dampingFraction: 0.86, blendDuration: 0.2), value: draggingSlot)
            .gesture(
                cornerDragGesture(
                    for: slot,
                    basePosition: basePosition,
                    centerPosition: centerPosition,
                    targetIndex: itemIndex
                )
            )
            .onTapGesture {
                guard draggingSlot == nil else { return }
                withAnimation(.spring(response: Layout.snapResponse, dampingFraction: Layout.snapDamping, blendDuration: 0.2)) {
                    centerIndex = itemIndex
                }
                Haptics.selection()
            }
            .allowsHitTesting(draggingSlot == nil || draggingSlot == slot)
    }

    var body: some View {
        ZStack {
            backgroundGradient

            GeometryReader { proxy in
                let viewportSize = proxy.size
                let centerPosition = CGPoint(
                    x: viewportSize.width / 2,
                    y: viewportSize.height / 2
                )

                TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: false)) { timeline in
                    let t = timeline.date.timeIntervalSinceReferenceDate

                    ZStack {
                        ForEach(CornerSlot.allCases, id: \.self) { slot in
                            cornerNode(
                                slot: slot,
                                time: t,
                                viewportSize: viewportSize,
                                centerPosition: centerPosition
                            )
                        }

                        focusedNode(
                            time: t,
                            viewportSize: viewportSize
                        )
                    }
                    .frame(width: viewportSize.width, height: viewportSize.height)
                    .contentShape(Rectangle())
                    .clipped()
                    .overlay(detailCardOverlay.allowsHitTesting(false))
                }
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .stroke(.black.opacity(Layout.borderOpacity), lineWidth: 0.5)
        )
        .shadow(
            color: Tokens.ShopClient.shadowLColor,
            radius: Tokens.ShopClient.shadowLRadius,
            x: 0,
            y: Tokens.ShopClient.shadowLY
        )
        .onAppear {
            ensureFocusedSpotSelection()
        }
        .onChange(of: centerIndex) { _, _ in
            ensureFocusedSpotSelection()
        }
    }
}

private struct OutfitFloatItem: Identifiable {
    let id: String
    let imageName: String
    let size: CGFloat
    let anchor: CGPoint
    let baseRotation: Double
    let floatRadius: CGSize
    let secondaryRadius: CGSize
    let floatSpeed: Double
    let phase: Double
    let rotationAmplitude: Double
    let rotationSpeed: Double
    let scaleAmplitude: CGFloat
}

private extension OutfitFloatItem {
    static let defaults: [OutfitFloatItem] = [
        .init(
            id: "fit-01",
            imageName: "OutfitFloat01",
            size: 118,
            anchor: .init(x: 0.08, y: 0.12),
            baseRotation: -8.0,
            floatRadius: .init(width: 6, height: 8),
            secondaryRadius: .init(width: 2, height: 3),
            floatSpeed: 0.70,
            phase: 0.00,
            rotationAmplitude: 2.3,
            rotationSpeed: 0.30,
            scaleAmplitude: 0.012
        ),
        .init(
            id: "fit-02",
            imageName: "OutfitFloat02",
            size: 121,
            anchor: .init(x: 0.38, y: 0.18),
            baseRotation: 5.8,
            floatRadius: .init(width: 5, height: 7),
            secondaryRadius: .init(width: 2, height: 3),
            floatSpeed: 0.64,
            phase: 0.85,
            rotationAmplitude: 2.0,
            rotationSpeed: 0.24,
            scaleAmplitude: 0.010
        ),
        .init(
            id: "fit-03",
            imageName: "OutfitFloat03",
            size: 120,
            anchor: .init(x: 0.74, y: 0.14),
            baseRotation: -4.4,
            floatRadius: .init(width: 7, height: 6),
            secondaryRadius: .init(width: 2, height: 2),
            floatSpeed: 0.76,
            phase: 1.38,
            rotationAmplitude: 2.4,
            rotationSpeed: 0.27,
            scaleAmplitude: 0.011
        ),
        .init(
            id: "fit-04",
            imageName: "OutfitFloat04",
            size: 122,
            anchor: .init(x: 0.15, y: 0.42),
            baseRotation: -6.3,
            floatRadius: .init(width: 6, height: 7),
            secondaryRadius: .init(width: 3, height: 2),
            floatSpeed: 0.67,
            phase: 2.05,
            rotationAmplitude: 2.2,
            rotationSpeed: 0.25,
            scaleAmplitude: 0.012
        ),
        .init(
            id: "fit-05",
            imageName: "OutfitFloat05",
            size: 119,
            anchor: .init(x: 0.50, y: 0.50),
            baseRotation: 3.7,
            floatRadius: .init(width: 6, height: 8),
            secondaryRadius: .init(width: 2, height: 3),
            floatSpeed: 0.73,
            phase: 2.62,
            rotationAmplitude: 2.1,
            rotationSpeed: 0.28,
            scaleAmplitude: 0.010
        ),
        .init(
            id: "fit-06",
            imageName: "OutfitFloat06",
            size: 120,
            anchor: .init(x: 0.84, y: 0.43),
            baseRotation: -7.1,
            floatRadius: .init(width: 5, height: 7),
            secondaryRadius: .init(width: 2, height: 3),
            floatSpeed: 0.69,
            phase: 3.21,
            rotationAmplitude: 2.5,
            rotationSpeed: 0.26,
            scaleAmplitude: 0.011
        ),
        .init(
            id: "fit-07",
            imageName: "OutfitFloat07",
            size: 124,
            anchor: .init(x: 0.24, y: 0.78),
            baseRotation: -5.0,
            floatRadius: .init(width: 7, height: 6),
            secondaryRadius: .init(width: 2, height: 2),
            floatSpeed: 0.62,
            phase: 3.86,
            rotationAmplitude: 2.0,
            rotationSpeed: 0.22,
            scaleAmplitude: 0.010
        ),
        .init(
            id: "fit-08",
            imageName: "OutfitFloat04",
            size: 122,
            anchor: .init(x: 0.92, y: 0.08),
            baseRotation: 7.5,
            floatRadius: .init(width: 6, height: 7),
            secondaryRadius: .init(width: 2, height: 3),
            floatSpeed: 0.71,
            phase: 4.43,
            rotationAmplitude: 2.1,
            rotationSpeed: 0.29,
            scaleAmplitude: 0.010
        ),
        .init(
            id: "fit-09",
            imageName: "OutfitFloat03",
            size: 120,
            anchor: .init(x: 0.04, y: 0.86),
            baseRotation: -9.0,
            floatRadius: .init(width: 7, height: 6),
            secondaryRadius: .init(width: 3, height: 2),
            floatSpeed: 0.66,
            phase: 5.02,
            rotationAmplitude: 2.4,
            rotationSpeed: 0.23,
            scaleAmplitude: 0.011
        ),
        .init(
            id: "fit-10",
            imageName: "OutfitFloat02",
            size: 121,
            anchor: .init(x: 0.90, y: 0.83),
            baseRotation: 4.2,
            floatRadius: .init(width: 6, height: 8),
            secondaryRadius: .init(width: 2, height: 2),
            floatSpeed: 0.63,
            phase: 5.69,
            rotationAmplitude: 1.9,
            rotationSpeed: 0.21,
            scaleAmplitude: 0.010
        ),
        .init(
            id: "fit-11",
            imageName: "OutfitFloat05",
            size: 119,
            anchor: .init(x: 0.45, y: 0.95),
            baseRotation: -4.8,
            floatRadius: .init(width: 5, height: 7),
            secondaryRadius: .init(width: 2, height: 3),
            floatSpeed: 0.72,
            phase: 6.24,
            rotationAmplitude: 2.2,
            rotationSpeed: 0.24,
            scaleAmplitude: 0.010
        ),
        .init(
            id: "fit-12",
            imageName: "OutfitFloat06",
            size: 120,
            anchor: .init(x: 0.63, y: 0.06),
            baseRotation: -2.6,
            floatRadius: .init(width: 5, height: 6),
            secondaryRadius: .init(width: 2, height: 2),
            floatSpeed: 0.68,
            phase: 4.12,
            rotationAmplitude: 1.8,
            rotationSpeed: 0.22,
            scaleAmplitude: 0.010
        ),
    ]
}

private struct OutfitDetailSpot: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let price: String
    let point: CGPoint
    let phase: Double
}

private extension OutfitDetailSpot {
    static func make(
        _ id: String,
        _ title: String,
        _ subtitle: String,
        _ price: String,
        x: CGFloat,
        y: CGFloat,
        phase: Double
    ) -> OutfitDetailSpot {
        .init(
            id: id,
            title: title,
            subtitle: subtitle,
            price: price,
            point: .init(x: x, y: y),
            phase: phase
        )
    }

    static let fallback: [OutfitDetailSpot] = [
        .make("fallback-core", "Core Piece", "Tap other looks for more", "$98", x: 0.5, y: 0.48, phase: 0)
    ]

    static let byImageName: [String: [OutfitDetailSpot]] = [
        "OutfitFloat01": [
            .make("of1-cap", "Wool cap", "Graphite, one size", "$38", x: 0.43, y: 0.16, phase: 0.12),
            .make("of1-jacket", "Field jacket", "Relaxed cotton shell", "$188", x: 0.52, y: 0.37, phase: 0.68),
            .make("of1-pant", "Work pant", "Straight fit twill", "$124", x: 0.49, y: 0.63, phase: 1.28),
            .make("of1-shoe", "Trail sneaker", "Foam comfort sole", "$142", x: 0.56, y: 0.86, phase: 1.84),
        ],
        "OutfitFloat02": [
            .make("of2-beanie", "Rib beanie", "Soft merino blend", "$34", x: 0.44, y: 0.14, phase: 0.22),
            .make("of2-top", "Layered knit", "Boxy everyday fit", "$112", x: 0.51, y: 0.36, phase: 0.86),
            .make("of2-denim", "Light denim", "Relaxed vintage wash", "$136", x: 0.49, y: 0.62, phase: 1.34),
            .make("of2-runner", "Retro runner", "Breathable mesh upper", "$158", x: 0.54, y: 0.84, phase: 1.98),
        ],
        "OutfitFloat03": [
            .make("of3-jacket", "Cropped shell", "Wind-resistant layer", "$174", x: 0.54, y: 0.28, phase: 0.26),
            .make("of3-tee", "Heavy tee", "Loose drape cotton", "$48", x: 0.51, y: 0.44, phase: 0.92),
            .make("of3-cargo", "Nylon cargo", "Adjustable ankle hem", "$146", x: 0.48, y: 0.67, phase: 1.46),
            .make("of3-shoe", "Hiker low", "Grip-ready outsole", "$168", x: 0.56, y: 0.88, phase: 2.08),
        ],
        "OutfitFloat04": [
            .make("of4-cap", "Cord cap", "Soft structured brim", "$42", x: 0.45, y: 0.16, phase: 0.34),
            .make("of4-overshirt", "Plaid overshirt", "Mid-weight brushed weave", "$129", x: 0.51, y: 0.37, phase: 0.78),
            .make("of4-trouser", "Wide trouser", "Pressed twill finish", "$118", x: 0.49, y: 0.64, phase: 1.28),
            .make("of4-shoe", "Court leather", "Minimal profile", "$152", x: 0.55, y: 0.86, phase: 1.82),
        ],
        "OutfitFloat05": [
            .make("of5-jacket", "Coach jacket", "Water-resistant matte", "$162", x: 0.52, y: 0.30, phase: 0.18),
            .make("of5-hoodie", "Fleece hoodie", "Soft brushed interior", "$92", x: 0.49, y: 0.44, phase: 0.74),
            .make("of5-pant", "Tech jogger", "Tapered with stretch", "$106", x: 0.47, y: 0.67, phase: 1.42),
            .make("of5-shoe", "Foam runner", "Cloud rebound midsole", "$138", x: 0.55, y: 0.86, phase: 2.02),
        ],
        "OutfitFloat06": [
            .make("of6-shirt", "Oxford shirt", "Relaxed crisp cotton", "$88", x: 0.52, y: 0.34, phase: 0.24),
            .make("of6-knit", "Cable vest", "Layer-friendly weight", "$96", x: 0.50, y: 0.47, phase: 0.96),
            .make("of6-jean", "Indigo jean", "Straight leg, mid-rise", "$124", x: 0.49, y: 0.66, phase: 1.38),
            .make("of6-loafer", "Penny loafer", "Soft leather upper", "$176", x: 0.56, y: 0.87, phase: 1.94),
        ],
        "OutfitFloat07": [
            .make("of7-top", "Waffle henley", "Natural stretch jersey", "$56", x: 0.49, y: 0.34, phase: 0.18),
            .make("of7-jacket", "Utility chore", "Boxy workwear cut", "$148", x: 0.53, y: 0.47, phase: 0.84),
            .make("of7-pant", "Relaxed chino", "Garment-dyed tan", "$102", x: 0.49, y: 0.67, phase: 1.48),
            .make("of7-shoe", "Canvas high-top", "Flexible vulcanized sole", "$78", x: 0.55, y: 0.87, phase: 2.10),
        ],
    ]
}

private struct OutfitDetailDotsOverlay: View {
    let spots: [OutfitDetailSpot]
    let selectedSpotID: String?
    let time: TimeInterval
    let onSelect: (OutfitDetailSpot) -> Void

    var body: some View {
        GeometryReader { proxy in
            ForEach(spots) { spot in
                let isSelected = selectedSpotID == spot.id
                let bobOffset = CGFloat(sin(time * 1.12 + spot.phase)) * 2.5

                Button {
                    onSelect(spot)
                } label: {
                    Circle()
                        .fill(.white.opacity(isSelected ? 0.98 : 0.86))
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(isSelected ? 1.0 : 0.75), lineWidth: isSelected ? 2 : 1)
                        )
                        .frame(width: isSelected ? 17 : 13, height: isSelected ? 17 : 13)
                        .shadow(color: .white.opacity(0.45), radius: isSelected ? 8 : 5, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.16), radius: 3, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .position(
                    x: spot.point.x * proxy.size.width,
                    y: spot.point.y * proxy.size.height + bobOffset
                )
            }
        }
    }
}

private struct OutfitKeyedImage: View {
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
            processedImage = await OutfitBlackKeyProcessor.shared.processedImage(named: imageName)
        }
    }
}

private actor OutfitBlackKeyProcessor {
    static let shared = OutfitBlackKeyProcessor()
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

        // Remove pure/near-black background while preserving most dark garment details.
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
