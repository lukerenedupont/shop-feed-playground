//
//  F1DriverCarouselData.swift
//  Shop feed playground
//
//  Mock data for the F1 Driver Carousel card.
//  6 drivers with cutout photos, team colors, and merch products.
//

import SwiftUI

// MARK: - F1 Merch Product

struct F1MerchProduct: Identifiable {
    let id: Int
    let name: String
    let price: String
    let thumbnailColor: Color
    let xFrac: CGFloat
    let yFrac: CGFloat
}

// MARK: - F1 Driver

struct F1Driver: Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let team: String
    let country: String
    let countryFlag: String
    let number: Int
    let teamColor: Color
    let teamColorDark: Color
    let imageName: String
    let products: [F1MerchProduct]

    static let defaults: [F1Driver] = [
        .init(id: 1, firstName: "Lewis", lastName: "Hamilton",
              team: "Ferrari", country: "United Kingdom", countryFlag: "🇬🇧", number: 44,
              teamColor: Color(hex: 0xE8002D), teamColorDark: Color(hex: 0x8B0019), imageName: "F1Hamilton",
              products: [
                  .init(id: 0, name: "Driver Tee #44", price: "$68", thumbnailColor: Color(hex: 0xE8002D), xFrac: -0.30, yFrac: -0.05),
                  .init(id: 1, name: "Team Hoodie", price: "$150", thumbnailColor: Color(hex: 0x1A1A1A), xFrac: -0.28, yFrac: 0.18),
                  .init(id: 2, name: "Scuderia Cap", price: "$50", thumbnailColor: Color(hex: 0xE8002D).opacity(0.8), xFrac: -0.15, yFrac: 0.35),
              ]),

        .init(id: 2, firstName: "Max", lastName: "Verstappen",
              team: "Red Bull Racing", country: "Netherlands", countryFlag: "🇳🇱", number: 1,
              teamColor: Color(hex: 0x1E2B5E), teamColorDark: Color(hex: 0x0A1230), imageName: "F1Verstappen",
              products: [
                  .init(id: 0, name: "Team Polo", price: "$85", thumbnailColor: Color(hex: 0x1E41FF), xFrac: -0.30, yFrac: -0.05),
                  .init(id: 1, name: "Team Cap", price: "$45", thumbnailColor: Color(hex: 0x1E41FF).opacity(0.8), xFrac: -0.28, yFrac: 0.18),
                  .init(id: 2, name: "Race Jacket", price: "$220", thumbnailColor: Color(hex: 0xFCD700), xFrac: -0.15, yFrac: 0.35),
              ]),

        .init(id: 3, firstName: "Lando", lastName: "Norris",
              team: "McLaren", country: "United Kingdom", countryFlag: "🇬🇧", number: 4,
              teamColor: Color(hex: 0xFF8000), teamColorDark: Color(hex: 0xA85200), imageName: "F1Norris",
              products: [
                  .init(id: 0, name: "Papaya Polo", price: "$80", thumbnailColor: Color(hex: 0xFF8000), xFrac: -0.30, yFrac: -0.05),
                  .init(id: 1, name: "Team Snapback", price: "$42", thumbnailColor: Color(hex: 0xFF8000).opacity(0.8), xFrac: -0.28, yFrac: 0.18),
                  .init(id: 2, name: "Pit Crew Jacket", price: "$195", thumbnailColor: Color(hex: 0x2A2A2A), xFrac: -0.15, yFrac: 0.35),
              ]),

        .init(id: 4, firstName: "Fernando", lastName: "Alonso",
              team: "Aston Martin", country: "Spain", countryFlag: "🇪🇸", number: 14,
              teamColor: Color(hex: 0x006F62), teamColorDark: Color(hex: 0x003D35), imageName: "F1Alonso",
              products: [
                  .init(id: 0, name: "Team Polo", price: "$78", thumbnailColor: Color(hex: 0x006F62), xFrac: -0.30, yFrac: -0.05),
                  .init(id: 1, name: "Aramco Cap", price: "$48", thumbnailColor: Color(hex: 0x006F62).opacity(0.8), xFrac: -0.28, yFrac: 0.18),
                  .init(id: 2, name: "Race Hoodie", price: "$140", thumbnailColor: Color(hex: 0xCEDC00), xFrac: -0.15, yFrac: 0.35),
              ]),

        .init(id: 5, firstName: "Pierre", lastName: "Gasly",
              team: "Alpine", country: "France", countryFlag: "🇫🇷", number: 10,
              teamColor: Color(hex: 0xF596C8), teamColorDark: Color(hex: 0x2A2A2A), imageName: "F1Gasly",
              products: [
                  .init(id: 0, name: "BWT Team Tee", price: "$65", thumbnailColor: Color(hex: 0xF596C8), xFrac: -0.30, yFrac: -0.05),
                  .init(id: 1, name: "Alpine Cap", price: "$40", thumbnailColor: Color(hex: 0x2A2A2A), xFrac: -0.28, yFrac: 0.18),
                  .init(id: 2, name: "Team Jacket", price: "$160", thumbnailColor: Color(hex: 0x0090FF), xFrac: -0.15, yFrac: 0.35),
              ]),

        .init(id: 6, firstName: "Alexander", lastName: "Albon",
              team: "Williams", country: "Thailand", countryFlag: "🇹🇭", number: 23,
              teamColor: Color(hex: 0x00A3E0), teamColorDark: Color(hex: 0x002B5C), imageName: "F1Albon",
              products: [
                  .init(id: 0, name: "Team Polo", price: "$72", thumbnailColor: Color(hex: 0x00A3E0), xFrac: -0.30, yFrac: -0.05),
                  .init(id: 1, name: "Williams Cap", price: "$38", thumbnailColor: Color(hex: 0x002B5C), xFrac: -0.28, yFrac: 0.18),
                  .init(id: 2, name: "Race Jacket", price: "$175", thumbnailColor: .white, xFrac: -0.15, yFrac: 0.35),
              ]),
    ]
}
