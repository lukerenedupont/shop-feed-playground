//
//  ShopTheLookData.swift
//  Shop feed playground
//
//  Data for the "Shop the Look" celebrity card.
//

import SwiftUI

// MARK: - Floating Product

struct FloatingProduct: Identifiable {
    let id: Int
    let imageName: String
    let name: String
    let merchant: String
    let price: String
    /// Position relative to card center (fraction of card size, -0.5 to 0.5)
    let xFrac: CGFloat
    let yFrac: CGFloat
}

// MARK: - Celebrity Look

struct CelebrityLook: Identifiable {
    let id: Int
    let name: String
    let caption: String
    let imageName: String
    let products: [FloatingProduct]

    static let defaults: [CelebrityLook] = [
        .init(id: 0, name: "Jacob Elordi", caption: "Valentino SS25", imageName: "CelebJacob", products: [
            .init(id: 0, imageName: "PileSunglasses", name: "Square Sunglasses", merchant: "Valentino", price: "$420",
                  xFrac: 0.32, yFrac: -0.28),
            .init(id: 1, imageName: "MartyCoat", name: "Leather Blazer", merchant: "Valentino", price: "$4,900",
                  xFrac: -0.30, yFrac: -0.02),
            .init(id: 2, imageName: "MartyTie", name: "Silk Skinny Tie", merchant: "Valentino", price: "$230",
                  xFrac: 0.28, yFrac: 0.05),
            .init(id: 3, imageName: "PileReebok", name: "Chelsea Boots", merchant: "Valentino", price: "$1,290",
                  xFrac: 0.0, yFrac: 0.32),
        ]),

        .init(id: 1, name: "Bad Bunny", caption: "Coachella 2025", imageName: "CelebBadBunny", products: [
            .init(id: 0, imageName: "PileBeanie", name: "64 Logo Hoodie", merchant: "adidas x BB", price: "$120",
                  xFrac: -0.30, yFrac: -0.12),
            .init(id: 1, imageName: "PileNike", name: "Forum Low", merchant: "adidas", price: "$110",
                  xFrac: 0.30, yFrac: 0.28),
            .init(id: 2, imageName: "MartyGloves", name: "Leather Gloves", merchant: "adidas x BB", price: "$65",
                  xFrac: 0.32, yFrac: -0.08),
        ]),

        .init(id: 2, name: "Jonah Hill", caption: "NYC Street Style", imageName: "CelebJonah", products: [
            .init(id: 0, imageName: "PileSlippers", name: "Lithuania Tie-Dye Tee", merchant: "Grateful Dead", price: "$85",
                  xFrac: -0.28, yFrac: -0.10),
            .init(id: 1, imageName: "PileNike", name: "Samba OG", merchant: "adidas", price: "$100",
                  xFrac: 0.30, yFrac: 0.30),
            .init(id: 2, imageName: "PileWaterBottle", name: "Half Gallon Jug", merchant: "Hydro Flask", price: "$45",
                  xFrac: -0.32, yFrac: 0.20),
        ]),
    ]
}
