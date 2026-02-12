//
//  ArcCarouselData.swift
//  Shop feed playground
//
//  Data models and defaults for the A24 arc carousel card.
//

import SwiftUI

// MARK: - Product Cutout

struct ProductCutout {
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    let rotation: Double
}

// MARK: - Portrait Data

struct PortraitData {
    let name: String
    let brand: String
    let imageName: String
    let bgColor: Color
    var imageScale: CGFloat = 1.0
    var products: [ProductCutout] = []

    static let defaults: [PortraitData] = [
        .init(name: "Wally", brand: "Tyler Gregory Okonma",
              imageName: "PortraitWally", bgColor: Color(hex: 0xD4A020), imageScale: 1.5, products: [
                .init(imageName: "PileReebok", width: 120, height: 72, rotation: -5),
                .init(imageName: "PileSunglasses", width: 110, height: 55, rotation: 12),
                .init(imageName: "PileBeanie", width: 80, height: 72, rotation: -8),
                .init(imageName: "PileYankeesCap", width: 90, height: 72, rotation: 6),
              ]),

        .init(name: "Ezra", brand: "Abel Ferrara",
              imageName: "PortraitOldGuy", bgColor: Color(hex: 0x5A5A6A), imageScale: 1.5, products: [
                .init(imageName: "PileSlippers", width: 100, height: 84, rotation: 8),
                .init(imageName: "PileMatchaTin", width: 65, height: 73, rotation: -10),
                .init(imageName: "PileSaucepan", width: 110, height: 86, rotation: 5),
                .init(imageName: "PileLantern", width: 90, height: 90, rotation: -4),
              ]),

        .init(name: "Dion", brand: "Luke Manley",
              imageName: "PortraitDion", bgColor: Color(hex: 0x2E3023), imageScale: 1.5, products: [
                .init(imageName: "PileNike", width: 120, height: 73, rotation: 10),
                .init(imageName: "PileWaterBottle", width: 42, height: 100, rotation: -6),
                .init(imageName: "PileSunscreen", width: 55, height: 95, rotation: 15),
                .init(imageName: "PileWolverine", width: 80, height: 96, rotation: -3),
              ]),

        .init(name: "Marty", brand: "Timothee Chalamet",
              imageName: "PortraitMarty", bgColor: Color(hex: 0x7D2E34), imageScale: 1.5, products: [
                .init(imageName: "MartyGloves", width: 88, height: 97, rotation: 0),
                .init(imageName: "MartyGlasses", width: 133, height: 98, rotation: 20),
                .init(imageName: "MartyTie", width: 66, height: 121, rotation: 25),
                .init(imageName: "MartyCoat", width: 87, height: 105, rotation: -6),
              ]),

        .init(name: "Claire", brand: "Greyson Clothiers",
              imageName: "PortraitLady", bgColor: Color(hex: 0x6A8A5A), imageScale: 1.5, products: [
                .init(imageName: "PilePerfume", width: 60, height: 85, rotation: -8),
                .init(imageName: "PileSunscreen", width: 55, height: 95, rotation: 12),
                .init(imageName: "PileSlippers", width: 100, height: 84, rotation: -5),
                .init(imageName: "PileSunglasses", width: 110, height: 55, rotation: 7),
              ]),
    ]
}
