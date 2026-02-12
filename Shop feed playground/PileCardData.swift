//
//  PileCardData.swift
//  Shop feed playground
//
//  Data models and defaults for the interactive pile card.
//

import SwiftUI

// MARK: - Pile Item

struct PileItem: Identifiable {
    let id: Int
    let imageName: String
    var offset: CGSize
    var rotation: Double
    let size: CGSize
    var zIndex: Double
    let dominantColor: Color
    let merchant: String
    let logoImage: String?
    let logoHeight: CGFloat
    let productName: String
    let price: String

    static var defaults: [PileItem] {
        [
            .init(id: 0, imageName: "PileLantern",
                  offset: .init(width: 0, height: -120), rotation: -5,
                  size: .init(width: 315, height: 315), zIndex: 0,
                  dominantColor: Color(hex: 0xE8DCC8),
                  merchant: "NOGUCHI", logoImage: "LogoNoguchi", logoHeight: 36,
                  productName: "Akari Paper Lantern", price: "$295"),

            .init(id: 1, imageName: "PileReebok",
                  offset: .init(width: -50, height: 30), rotation: -12,
                  size: .init(width: 338, height: 203), zIndex: 1,
                  dominantColor: Color(hex: 0xE8E4DE),
                  merchant: "REEBOK", logoImage: "LogoReebok", logoHeight: 36,
                  productName: "Club C 85 Vintage", price: "$85"),

            .init(id: 2, imageName: "PileSaucepan",
                  offset: .init(width: 60, height: -40), rotation: 8,
                  size: .init(width: 315, height: 248), zIndex: 2,
                  dominantColor: Color(hex: 0xF0EAD8),
                  merchant: "CARAWAY", logoImage: "LogoCaraway", logoHeight: 36,
                  productName: "Ceramic Saucepan", price: "$125"),

            .init(id: 3, imageName: "PileSlippers",
                  offset: .init(width: -60, height: -60), rotation: -8,
                  size: .init(width: 270, height: 225), zIndex: 3,
                  dominantColor: Color(hex: 0xD4A87A),
                  merchant: "TEKLA", logoImage: "LogoTekla", logoHeight: 108,
                  productName: "Striped Terry Slippers", price: "$80"),

            .init(id: 4, imageName: "PileMatchaTin",
                  offset: .init(width: 80, height: 80), rotation: 5,
                  size: .init(width: 180, height: 203), zIndex: 4,
                  dominantColor: Color(hex: 0x2838A8),
                  merchant: "IPPODO", logoImage: nil, logoHeight: 36,
                  productName: "Ceremonial Shiranami Blend\n20 grams", price: "$38"),

            .init(id: 5, imageName: "PileSunscreen",
                  offset: .init(width: -80, height: 120), rotation: -10,
                  size: .init(width: 158, height: 270), zIndex: 5,
                  dominantColor: Color(hex: 0xF0E8D0),
                  merchant: "VACATION", logoImage: "LogoVacation", logoHeight: 36,
                  productName: "Classic Lotion SPF 50", price: "$22"),

            .init(id: 6, imageName: "PilePerfume",
                  offset: .init(width: 50, height: 160), rotation: 6,
                  size: .init(width: 158, height: 225), zIndex: 6,
                  dominantColor: Color(hex: 0xC85A60),
                  merchant: "CEREMONIA", logoImage: "LogoCeremonia", logoHeight: 36,
                  productName: "Perfume Mist de Guava", price: "$32"),

            .init(id: 7, imageName: "PileWaterBottle",
                  offset: .init(width: -30, height: 180), rotation: -3,
                  size: .init(width: 113, height: 270), zIndex: 7,
                  dominantColor: Color(hex: 0xF0C0C8),
                  merchant: "OWALA", logoImage: "LogoOwala", logoHeight: 36,
                  productName: "FreeSip Water Bottle", price: "$28"),

            .init(id: 8, imageName: "PileSunglasses",
                  offset: .init(width: 20, height: 60), rotation: 10,
                  size: .init(width: 315, height: 158), zIndex: 8,
                  dominantColor: Color(hex: 0xD4A840),
                  merchant: "MOSCOT", logoImage: "LogoMoscot", logoHeight: 36,
                  productName: "Lemtosh Sun\nGrey Brownfade", price: "$350"),

            .init(id: 9, imageName: "PileNike",
                  offset: .init(width: -40, height: -160), rotation: 15,
                  size: .init(width: 315, height: 191), zIndex: 9,
                  dominantColor: Color(hex: 0xE8944C),
                  merchant: "NIKE", logoImage: "LogoNike", logoHeight: 36,
                  productName: "LDWaffle x sacai\nCLOT Orange Blaze", price: "$340"),

            .init(id: 10, imageName: "PileBeanie",
                  offset: .init(width: 70, height: -130), rotation: -6,
                  size: .init(width: 203, height: 180), zIndex: 10,
                  dominantColor: Color(hex: 0x2A2A2A),
                  merchant: "KITH", logoImage: "LogoKith", logoHeight: 36,
                  productName: "Classic Beanie", price: "$50"),

            .init(id: 11, imageName: "PileWolverine",
                  offset: .init(width: -90, height: -10), rotation: -4,
                  size: .init(width: 225, height: 270), zIndex: 11,
                  dominantColor: Color(hex: 0xE8C030),
                  merchant: "HASBRO", logoImage: "LogoHasbro", logoHeight: 36,
                  productName: "Marvel Legends\nWolverine Action Figure", price: "$34"),

            .init(id: 12, imageName: "PileYankeesCap",
                  offset: .init(width: 30, height: -30), rotation: 7,
                  size: .init(width: 225, height: 180), zIndex: 12,
                  dominantColor: Color(hex: 0x1C2244),
                  merchant: "KITH", logoImage: "LogoKith", logoHeight: 36,
                  productName: "Kith & New Era - NY Yankees", price: "$65"),
        ]
    }
}
