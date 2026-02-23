//
//  CollectionPocketData.swift
//  Shop feed playground
//
//  Data models and static content for the Collection Pocket card.
//  Each collection groups 6 products by color theme.
//

import SwiftUI

// MARK: - Collection

struct PocketCollection: Identifiable {
    let id: String
    let color: Color
    let label: String
    let backgroundImagePath: String?
    let products: [PocketProduct]
}

// MARK: - Product

struct PocketProduct: Identifiable {
    let id: String
    let image: String
    let price: String
}

// MARK: - Pile Position

struct PocketPileSlot {
    let rotation: Double
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Default Collections

extension PocketCollection {
    private static func makeProducts(
        prefix: String,
        imageNames: [String],
        prices: [String]
    ) -> [PocketProduct] {
        zip(imageNames, prices).enumerated().map { index, pair in
            PocketProduct(id: "\(prefix)-\(index)", image: pair.0, price: pair.1)
        }
    }

    static let defaults: [PocketCollection] = [
        .init(
            id: "blue",
            color: Color(hex: 0x3A6FB5),
            label: "Blue",
            backgroundImagePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-19_at_7.36.58_PM-b58683de-a62c-4f38-a7c9-57ce34350e70.png",
            products: makeProducts(
                prefix: "blue",
                imageNames: ["BlueShoe1", "BlueShoe2", "BlueShoe3", "BlueShoe4", "BlueShoe5", "BlueShoe6"],
                prices: ["$129", "$185", "$160", "$175", "$195", "$95"]
            )
        ),

        .init(
            id: "silver",
            color: Color(hex: 0xB0B0B0),
            label: "Silver",
            backgroundImagePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-19_at_7.33.53_PM-3e28755d-b240-4534-8908-7f0052b82326.png",
            products: makeProducts(
                prefix: "silver",
                imageNames: ["SilverShoe1", "SilverShoe2", "SilverShoe3", "SilverShoe4", "SilverShoe5", "SilverShoe6"],
                prices: ["$210", "$165", "$180", "$145", "$155", "$190"]
            )
        ),

        .init(
            id: "green",
            color: Color(hex: 0x3A7D4A),
            label: "Green",
            backgroundImagePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-19_at_7.32.38_PM-a5c20cdd-d62b-4d32-91e8-3bcb6735ee85.png",
            products: makeProducts(
                prefix: "green",
                imageNames: ["GreenShoe1", "GreenShoe2", "GreenShoe3", "GreenShoe4", "GreenShoe5", "GreenShoe6"],
                prices: ["$175", "$195", "$140", "$210", "$95", "$165"]
            )
        ),

        .init(
            id: "white",
            color: Color(hex: 0xE8E4DF),
            label: "White",
            backgroundImagePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-19_at_7.33.53_PM-3e28755d-b240-4534-8908-7f0052b82326.png",
            products: makeProducts(
                prefix: "white",
                imageNames: ["WhiteShoe1", "WhiteShoe2", "WhiteShoe3", "WhiteShoe4", "WhiteShoe5", "WhiteShoe6"],
                prices: ["$135", "$120", "$85", "$175", "$160", "$150"]
            )
        ),

        .init(
            id: "brown",
            color: Color(hex: 0x8B6F4E),
            label: "Brown",
            backgroundImagePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-19_at_7.34.30_PM-fe2acaf9-57b3-4fc7-ba7d-35c6df202c23.png",
            products: makeProducts(
                prefix: "brown",
                imageNames: ["BrownShoe1", "BrownShoe2", "BrownShoe3", "BrownShoe4", "BrownShoe5", "BrownShoe6"],
                prices: ["$155", "$190", "$110", "$145", "$220", "$170"]
            )
        ),

        .init(
            id: "black",
            color: Color(hex: 0x2A2A2A),
            label: "Black",
            backgroundImagePath: "/Users/lukedupont/.cursor/projects/Users-lukedupont-Desktop-developer-Shop-feed-playground/assets/Screenshot_2026-02-19_at_7.35.03_PM-aefd889e-d6d0-4b46-80ee-ccd2c6d9a5ee.png",
            products: makeProducts(
                prefix: "black",
                imageNames: ["BlackShoe1", "BlackShoe2", "BlackShoe3", "BlackShoe4", "BlackShoe5", "BlackShoe6"],
                prices: ["$130", "$210", "$165", "$95", "$185", "$175"]
            )
        ),
    ]
}

// MARK: - Pile Layouts

extension PocketPileSlot {
    /// One layout per collection — scattered positions behind the glass card.
    static let layouts: [[PocketPileSlot]] = [
        [.init(rotation: -12, x: -40, y: -134), .init(rotation:   8, x:  35, y: -130), .init(rotation:  -4, x:  -8, y: -138),
         .init(rotation:  15, x:  48, y: -132), .init(rotation:  -9, x: -44, y: -136), .init(rotation:   6, x:  20, y: -140)],

        [.init(rotation:  10, x:  42, y: -132), .init(rotation:  -7, x: -36, y: -136), .init(rotation:  14, x:   6, y: -130),
         .init(rotation:  -5, x: -48, y: -134), .init(rotation:  11, x:  38, y: -138), .init(rotation:  -3, x: -16, y: -142)],

        [.init(rotation:  -8, x: -44, y: -136), .init(rotation:  12, x:  40, y: -130), .init(rotation:  -6, x:  -6, y: -134),
         .init(rotation:  10, x:  46, y: -138), .init(rotation: -14, x: -38, y: -132), .init(rotation:   5, x:  22, y: -140)],

        [.init(rotation:   7, x:  36, y: -134), .init(rotation: -11, x: -42, y: -130), .init(rotation:   5, x:  10, y: -138),
         .init(rotation:  -9, x: -46, y: -132), .init(rotation:  13, x:  44, y: -136), .init(rotation:  -6, x: -18, y: -140)],

        [.init(rotation: -13, x: -38, y: -132), .init(rotation:   9, x:  44, y: -136), .init(rotation:  -5, x:   8, y: -130),
         .init(rotation:  11, x:  40, y: -138), .init(rotation:  -8, x: -46, y: -134), .init(rotation:   4, x:  14, y: -142)],

        [.init(rotation:  11, x: -42, y: -130), .init(rotation:  -6, x:  38, y: -136), .init(rotation:   8, x: -10, y: -134),
         .init(rotation: -12, x:  46, y: -138), .init(rotation:   5, x: -44, y: -132), .init(rotation:  -9, x:  18, y: -140)],
    ]
}
