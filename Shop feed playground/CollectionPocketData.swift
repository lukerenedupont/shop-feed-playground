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
    static let defaults: [PocketCollection] = [
        .init(id: "blue", color: Color(hex: 0x3A6FB5), label: "Blue",
              products: zip(
                ["BlueShoe1", "BlueShoe2", "BlueShoe3", "BlueShoe4", "BlueShoe5", "BlueShoe6"],
                ["$129", "$185", "$160", "$175", "$195", "$95"]
              ).enumerated().map { i, pair in
                  PocketProduct(id: "blue-\(i)", image: pair.0, price: pair.1)
              }),

        .init(id: "silver", color: Color(hex: 0xB0B0B0), label: "Silver",
              products: zip(
                ["SilverShoe1", "SilverShoe2", "SilverShoe3", "SilverShoe4", "SilverShoe5", "SilverShoe6"],
                ["$210", "$165", "$180", "$145", "$155", "$190"]
              ).enumerated().map { i, pair in
                  PocketProduct(id: "silver-\(i)", image: pair.0, price: pair.1)
              }),

        .init(id: "green", color: Color(hex: 0x3A7D4A), label: "Green",
              products: zip(
                ["GreenShoe1", "GreenShoe2", "GreenShoe3", "GreenShoe4", "GreenShoe5", "GreenShoe6"],
                ["$175", "$195", "$140", "$210", "$95", "$165"]
              ).enumerated().map { i, pair in
                  PocketProduct(id: "green-\(i)", image: pair.0, price: pair.1)
              }),

        .init(id: "white", color: Color(hex: 0xE8E4DF), label: "White",
              products: zip(
                ["WhiteShoe1", "WhiteShoe2", "WhiteShoe3", "WhiteShoe4", "WhiteShoe5", "WhiteShoe6"],
                ["$135", "$120", "$85", "$175", "$160", "$150"]
              ).enumerated().map { i, pair in
                  PocketProduct(id: "white-\(i)", image: pair.0, price: pair.1)
              }),

        .init(id: "brown", color: Color(hex: 0x8B6F4E), label: "Brown",
              products: zip(
                ["BrownShoe1", "BrownShoe2", "BrownShoe3", "BrownShoe4", "BrownShoe5", "BrownShoe6"],
                ["$155", "$190", "$110", "$145", "$220", "$170"]
              ).enumerated().map { i, pair in
                  PocketProduct(id: "brown-\(i)", image: pair.0, price: pair.1)
              }),

        .init(id: "black", color: Color(hex: 0x2A2A2A), label: "Black",
              products: zip(
                ["BlackShoe1", "BlackShoe2", "BlackShoe3", "BlackShoe4", "BlackShoe5", "BlackShoe6"],
                ["$130", "$210", "$165", "$95", "$185", "$175"]
              ).enumerated().map { i, pair in
                  PocketProduct(id: "black-\(i)", image: pair.0, price: pair.1)
              }),
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
