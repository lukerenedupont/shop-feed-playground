//
//  PriceCheckData.swift
//  Shop feed playground
//
//  Data for the Price Check guessing game card.
//

import SwiftUI

struct PriceCheckProduct: Identifiable {
    let id: Int
    let imageName: String
    let name: String
    let merchant: String
    let actualPrice: Int      // real price in dollars
    let maxPrice: Int         // ruler max range
    let tickInterval: Int     // major label interval (e.g. 50, 100)

    static let defaults: [PriceCheckProduct] = [
        .init(id: 0, imageName: "PriceCaraway", name: "Cookware Set", merchant: "Caraway",
              actualPrice: 395, maxPrice: 600, tickInterval: 100),
        .init(id: 1, imageName: "PriceLamp", name: "Akari 10A Floor Lamp", merchant: "Noguchi",
              actualPrice: 1150, maxPrice: 1500, tickInterval: 250),
        .init(id: 2, imageName: "PriceJordan", name: "Air Jordan 6 x Travis Scott", merchant: "Nike",
              actualPrice: 250, maxPrice: 500, tickInterval: 100),
        .init(id: 3, imageName: "PriceMetsCap", name: "New Era Mets Cap", merchant: "Kith",
              actualPrice: 55, maxPrice: 150, tickInterval: 50),
        .init(id: 4, imageName: "PriceFrostedFlakes", name: "Kith x Frosted Flakes", merchant: "Kith",
              actualPrice: 30, maxPrice: 100, tickInterval: 25),
        .init(id: 5, imageName: "PriceErrorsCap", name: "Errors Snapback", merchant: "House of Errors",
              actualPrice: 48, maxPrice: 150, tickInterval: 50),
        .init(id: 6, imageName: "PriceErrorsFleece", name: "Lily Pad Fleece Jacket", merchant: "House of Errors",
              actualPrice: 185, maxPrice: 400, tickInterval: 100),
    ]
}
