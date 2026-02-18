//
//  CategoryExplorerData.swift
//  Shop feed playground
//
//  Data models and defaults for CategoryExplorerCard.
//

import SwiftUI

struct CategoryExplorerItem: Identifiable {
    let id: String
    let title: String
    let color: Color
    let accent: Color
    let productImages: [String]
}

private extension CategoryExplorerItem {
    static func make(
        id: String,
        title: String,
        color: UInt,
        accent: UInt,
        productImages: [String]
    ) -> CategoryExplorerItem {
        .init(
            id: id,
            title: title,
            color: Color(hex: color),
            accent: Color(hex: accent),
            productImages: productImages
        )
    }
}

extension CategoryExplorerItem {
    static let defaults: [CategoryExplorerItem] = [
        .make(id: "men", title: "Men", color: 0x253B52, accent: 0x355F86, productImages: ["BurgundyProductVans", "BurgundyProductHoodie", "BurgundyProductShirt", "BurgundyProductSocks"]),
        .make(id: "women", title: "Women", color: 0x4B2F58, accent: 0x7B4B8D, productImages: ["PileSlippers", "PilePerfume", "PileSunglasses", "BurgundyProductBeanie"]),
        .make(id: "beauty", title: "Beauty", color: 0x5A2F3B, accent: 0x924E64, productImages: ["PilePerfume", "PileSunglasses", "BurgundyProductMug", "PileBeanie"]),
        .make(id: "home", title: "Home", color: 0x2A4A40, accent: 0x3C7A67, productImages: ["BurgundyProductMug", "PileBeanie", "BurgundyProductSocks", "BurgundyProductShirt"]),
        .make(id: "tech", title: "Tech", color: 0x2B2F56, accent: 0x4B57A3, productImages: ["PileNike", "BurgundyProductVans", "PileYankeesCap", "PileSunglasses"]),
        .make(id: "fitness", title: "Fitness", color: 0x3E4130, accent: 0x6C7250, productImages: ["PileNike", "BurgundyProductSocks", "BurgundyProductHoodie", "BurgundyProductVans"]),
        .make(id: "extras", title: "Extras", color: 0x4D3A2C, accent: 0x89664D, productImages: ["PileYankeesCap", "PileSunglasses", "PileBeanie", "PilePerfume"]),
        .make(id: "vintage", title: "Vintage", color: 0x35403D, accent: 0x59706A, productImages: ["PileBeanie", "BurgundyProductShirt", "PileYankeesCap", "PileNike"]),
        .make(id: "shoes", title: "Shoes", color: 0x2C3E67, accent: 0x4468A8, productImages: ["BurgundyProductVans", "PileNike", "BurgundyProductSocks", "PileSlippers"]),
        .make(id: "layers", title: "Layers", color: 0x3F4337, accent: 0x697456, productImages: ["BurgundyProductHoodie", "BurgundyProductShirt", "PileBeanie", "BurgundyProductSocks"]),
        .make(id: "urban", title: "Urban", color: 0x3A2E49, accent: 0x5C4673, productImages: ["BurgundyProductShirt", "BurgundyProductHoodie", "BurgundyProductVans", "PileYankeesCap"]),
        .make(id: "luxury", title: "Luxury", color: 0x3A2C26, accent: 0x705444, productImages: ["PilePerfume", "PileSunglasses", "BurgundyProductMug", "PileBeanie"]),
        .make(id: "gifts", title: "Gifts", color: 0x4E3540, accent: 0x7F5366, productImages: ["BurgundyProductMug", "PilePerfume", "PileBeanie", "BurgundyProductSocks"]),
        .make(id: "collect", title: "Collect", color: 0x31434D, accent: 0x4F6C7A, productImages: ["PileSunglasses", "BurgundyProductMug", "PileYankeesCap", "PilePerfume"]),
        .make(id: "denim", title: "Denim", color: 0x264057, accent: 0x3D678A, productImages: ["BurgundyProductShirt", "BurgundyProductHoodie", "PileNike", "PileYankeesCap"]),
        .make(id: "active", title: "Active", color: 0x2F4736, accent: 0x4A7054, productImages: ["PileNike", "BurgundyProductSocks", "BurgundyProductHoodie", "PileSlippers"]),
        .make(id: "travel", title: "Travel", color: 0x2D3B4E, accent: 0x4B6282, productImages: ["PileSunglasses", "PileYankeesCap", "PilePerfume", "BurgundyProductVans"]),
        .make(id: "gadgets", title: "Gadgets", color: 0x2B2B40, accent: 0x464B77, productImages: ["PileSunglasses", "PileNike", "BurgundyProductMug", "PileYankeesCap"]),
    ]
}
