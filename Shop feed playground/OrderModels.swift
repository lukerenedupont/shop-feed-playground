//
//  OrderModels.swift
//  Shop feed playground
//
//  Data models for the Orders tab.
//

import SwiftUI

// MARK: - Order Stage

struct OrderStage {
    let label: String
    let progress: Double
    var hasPromise: Bool = false
}

// MARK: - Past Order

struct PastOrder: Identifiable {
    let id: Int
    let deliveredText: String
    let merchant: String
    let itemCount: String?
    let total: String?
    let thumbColors: [Color]
    let hasStack: Bool
}

// MARK: - Buy Again Product

struct BuyAgainProduct: Identifiable {
    let id: Int
    let bgColors: [Color]
    let accentStyle: BuyAgainAccentStyle
}

enum BuyAgainAccentStyle {
    case blackShoes
    case whiteTees
    case coffeeProducts
    case blackShoesAlt
    case darkShoes
    case whiteTeesFolded
}
