//
//  RadialDialCard.swift
//  Shop feed playground
//
//  Skeuomorphic radial knob with LED indicator dots that light up
//  as you rotate. Drag to turn the dial.
//  Inspired by Philip Davis's RadialDial prototype.
//

import SwiftUI

// MARK: - Layout

private enum Layout {
    static let dialSize: CGFloat = 180
    static let ledCount = 15
    static let ledDotSize: CGFloat = 8
    static let ledRingOffset: CGFloat = -110
    static let ledArc: Int = 260
    static let ledRingRotation: Double = -136
    static let ledBlurOn: CGFloat = 4
    static let ledBlurOff: CGFloat = 0

    static let angleMin: CGFloat = -120
    static let angleMax: CGFloat = 105
    static let maskMin: CGFloat = -0.30
    static let maskMax: CGFloat = 0.30

    static let notchWidth: CGFloat = 4
    static let notchHeight: CGFloat = 10
    static let notchRadius: CGFloat = 4
    static let notchOffset: CGFloat = -70
    static let notchBrightness: Double = 0.2

    static let shadowBlur1: CGFloat = 9
    static let shadowOpacity1: Double = 0.4
    static let shadowOffset1: CGFloat = 5
    static let shadowBrightness1: Double = -0.1
    static let shadowBlur2: CGFloat = 4
    static let shadowOffset2: CGFloat = 3

    static let dialGradientEnd: CGFloat = 130
    static let bgGradientEnd: CGFloat = 500
    static let innerShadowRadius: CGFloat = 6
    static let innerShadowY: CGFloat = 10

    static let contentOffsetY: CGFloat = 30
}

// MARK: - Radial Dial Card

struct RadialDialCard: View {
    @State private var angle: Double = 0

    // MARK: Helpers

    private func ledOn(_ index: Int) -> Bool {
        let normAngle = lerp(inMin: Layout.angleMin, inMax: Layout.angleMax,
                             outMin: 0, outMax: 100, CGFloat(angle))
        let normLed = lerp(inMin: 0, inMax: CGFloat(Layout.ledCount),
                           outMin: 0, outMax: 100, CGFloat(index))
        return normAngle >= normLed
    }

    private func maskOffset() -> CGFloat {
        lerp(inMin: -100, inMax: 100,
             outMin: Layout.maskMin, outMax: Layout.maskMax, CGFloat(angle))
    }

    // MARK: Body

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous)
                .fill(
                    RadialGradient(colors: [Color(hex: 0x3A3A3A), Color(hex: 0x1A1A1A)],
                                   center: .top, startRadius: 0, endRadius: Layout.bgGradientEnd)
                )

            CardHeader(subtitle: "Control", title: "Turn the dial", lightText: true)

            ZStack {
                // MARK: Dial Shadow

                Circle().fill(Color(hex: 0x1A1A1A)).frame(width: Layout.dialSize)
                    .blur(radius: Layout.shadowBlur1)
                    .brightness(Layout.shadowBrightness1)
                    .opacity(Layout.shadowOpacity1)
                    .offset(y: Layout.shadowOffset1)
                Circle().fill(Color(hex: 0x1A1A1A)).frame(width: Layout.dialSize)
                    .blur(radius: Layout.shadowBlur2)
                    .brightness(Layout.shadowBrightness1)
                    .offset(y: Layout.shadowOffset2)

                // MARK: Dial Body

                Circle()
                    .fill(RadialGradient(colors: [Color(hex: 0x4A4A4A), Color(hex: 0x1A1A1A)],
                                         center: .top, startRadius: 0, endRadius: Layout.dialGradientEnd))
                    .frame(width: Layout.dialSize)

                // MARK: Lit Portion Mask

                Circle()
                    .fill(RadialGradient(colors: [Color(hex: 0x4A4A4A), Color(hex: 0x1A1A1A)],
                                         center: .top, startRadius: 0, endRadius: Layout.dialGradientEnd)
                        .shadow(.inner(color: Color(hex: 0x3A3A3A),
                                       radius: Layout.innerShadowRadius, x: 0, y: Layout.innerShadowY)))
                    .frame(width: Layout.dialSize)
                    .allowsHitTesting(false)
                    .mask {
                        AngularGradient(
                            stops: [
                                .init(color: .white, location: 0.00),
                                .init(color: .white, location: 0.15),
                                .init(color: .clear, location: 0.16),
                                .init(color: .clear, location: 0.45 + maskOffset()),
                                .init(color: .white, location: 0.55 + maskOffset()),
                                .init(color: .white, location: 1.0),
                            ],
                            center: .center,
                            startAngle: .degrees(90),
                            endAngle: .degrees(450)
                        )
                    }

                // MARK: Indicator Notch

                ZStack {
                    Circle().fill(.clear).frame(width: Layout.dialSize)
                    RoundedRectangle(cornerRadius: Layout.notchRadius)
                        .fill(.white)
                        .frame(width: Layout.notchWidth, height: Layout.notchHeight)
                        .offset(y: Layout.notchOffset)
                        .brightness(Layout.notchBrightness)
                }
                .rotationEffect(.degrees(angle))
                .gesture(
                    DragGesture()
                        .onChanged { g in
                            angle = atan2(g.location.x - Layout.dialSize / 2,
                                          Layout.dialSize / 2 - g.location.y) * (180 / .pi)
                        }
                )

                // MARK: LED Ring

                ZStack {
                    ForEach(1...Layout.ledCount, id: \.self) { i in
                        Circle()
                            .fill(ledOn(i) ? Color(hex: 0xE84855) : .black)
                            .frame(width: Layout.ledDotSize)
                            .offset(y: Layout.ledRingOffset)
                            .rotationEffect(.degrees(Double((Layout.ledArc / Layout.ledCount) * i)))
                            .shadow(color: Color(hex: 0xE84855),
                                    radius: ledOn(i) ? Layout.ledBlurOn : Layout.ledBlurOff)
                    }
                }
                .rotationEffect(.degrees(Layout.ledRingRotation))
            }
            .offset(y: Layout.contentOffsetY)
        }
        .frame(width: Tokens.cardWidth, height: Tokens.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.radiusCard, style: .continuous))
    }
}
