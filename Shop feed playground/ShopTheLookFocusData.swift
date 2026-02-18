//
//  ShopTheLookFocusData.swift
//  Shop feed playground
//
//  Data models for the "Shop the look" card.
//

import Foundation

// MARK: - Product

struct LookHotspotProduct: Identifiable, Equatable {
    let id: Int
    let imageName: String
    let name: String
    let merchant: String
    let price: String
}

// MARK: - Outfit

struct LookOutfit: Identifiable {
    let id: Int
    let imageName: String
    let products: [LookHotspotProduct]
}

// MARK: - Default Data

extension LookOutfit {
    private static let baseProducts: [LookHotspotProduct] = [
        .init(id: 0, imageName: "MartyCoat",  name: "Leather blazer",  merchant: "Valentino",    price: "$4,900"),
        .init(id: 1, imageName: "PileReebok", name: "Cargo trousers",  merchant: "Acne Studios", price: "$520"),
    ]

    static let defaults: [LookOutfit] = (0..<9).map { i in
        .init(
            id: i,
            imageName: String(format: "ShopLookAvatar%02d", i + 1),
            products: baseProducts
        )
    }
}
