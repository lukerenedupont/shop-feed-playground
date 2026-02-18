//
//  TopicMerchDigestData.swift
//  Shop feed playground
//
//  Data models + seed content for TopicMerchDigestCard.
//

import SwiftUI

struct TopicCardProduct: Identifiable, Hashable {
    let id: String
    let imageName: String
    let price: String

    static func make(id: String? = nil, imageName: String, price: String) -> TopicCardProduct {
        .init(id: id ?? imageName, imageName: imageName, price: price)
    }
}

struct TopicExplorerItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let povText: String
    let backgroundImageName: String
    let color: Color
    let accent: Color
    let sourceChips: [String]
    let interestPills: [String]
    let trendingMerchants: [String]
    let products: [TopicCardProduct]
}

private extension TopicCardProduct {
    static func priced(_ imageName: String, _ price: String) -> TopicCardProduct {
        .make(imageName: imageName, price: price)
    }
}

extension TopicExplorerItem {
    static func make(
        id: String,
        title: String,
        subtitle: String,
        povText: String,
        backgroundImageName: String,
        color: UInt,
        accent: UInt,
        sourceChips: [String],
        interestPills: [String],
        trendingMerchants: [String],
        products: [TopicCardProduct]
    ) -> TopicExplorerItem {
        .init(
            id: id,
            title: title,
            subtitle: subtitle,
            povText: povText,
            backgroundImageName: backgroundImageName,
            color: Color(hex: color),
            accent: Color(hex: accent),
            sourceChips: sourceChips,
            interestPills: interestPills,
            trendingMerchants: trendingMerchants,
            products: products
        )
    }
}

extension TopicExplorerItem {
    static let defaults: [TopicExplorerItem] = [
        .make(
            id: "akari-paper-lighting",
            title: "Akari lamps",
            subtitle: "Soft paper lantern silhouettes that warm small rooms, reduce glare, and make evenings feel calm and intentional.",
            povText: "You gravitate to soft paper lanterns for a calm evening glow.",
            backgroundImageName: "TopicBgAkariLamps",
            color: 0x6B655C,
            accent: 0x958A78,
            sourceChips: ["Interior reels", "Editorial", "YouTube"],
            interestPills: ["Isamu Noguchi", "Warm ambient light", "Small apartment setups"],
            trendingMerchants: ["The Noguchi Museum Shop", "Gantri", "Audo Copenhagen"],
            products: [
                .priced("TopicAkariProductStackedPaper", "$1,020"),
                .priced("TopicAkariProductRoundPaper", "$690"),
                .priced("TopicAkariProductCylinderPaper", "$820"),
                .priced("TopicAkariProductRedPaper", "$760"),
            ]
        ),
        .make(
            id: "gallery-wall-prints",
            title: "Wall art",
            subtitle: "Bold framed prints with hand-drawn energy, layered color, and graphic type that give your gallery wall personality.",
            povText: "You save gallery walls with bold color accents and playful framing.",
            backgroundImageName: "TopicBgWallArt",
            color: 0x2D8886,
            accent: 0xA57358,
            sourceChips: ["Pinterest", "Design blogs", "Instagram"],
            interestPills: ["Surreal prints", "Muted palettes", "Gallery walls"],
            trendingMerchants: ["Poster Club", "Tappan", "The Poster List"],
            products: [
                .priced("TopicWallArtProductBrooklyn", "$140"),
                .priced("TopicWallArtProductLunaLuna", "$95"),
                .priced("TopicWallArtProductWoodRelief", "$290"),
                .priced("TopicWallArtProductStreetScene", "$210"),
            ]
        ),
        .make(
            id: "statement-headwear",
            title: "Caps & beanies",
            subtitle: "Sporty caps and textured beanies with heritage logos, washed fabrics, and vintage proportions that still read clean.",
            povText: "You keep clicking minimal caps and textured beanies with heritage logos.",
            backgroundImageName: "TopicBgHats",
            color: 0x262427,
            accent: 0x434045,
            sourceChips: ["Streetwear blogs", "TikTok", "Reddit"],
            interestPills: ["Runner caps", "Ebbets", "ALD vibes"],
            trendingMerchants: ["Ebbets Field", "Aimé Leon Dore", "Noah"],
            products: [
                .priced("TopicHatProductBeanie", "$38"),
                .priced("TopicHatProductParra", "$72"),
                .priced("TopicHatProductRhude", "$95"),
                .priced("TopicHatProductYankees", "$58"),
            ]
        ),
        .make(
            id: "running-rotation",
            title: "Running shoes",
            subtitle: "Neutral daily trainers with cushioned comfort, breathable uppers, and retro lines built for everyday city miles.",
            povText: "You favor clean New Balance and Asics pairs for everyday miles.",
            backgroundImageName: "TopicBgRunningTrail",
            color: 0x6A5A45,
            accent: 0x768265,
            sourceChips: ["Runner forums", "YouTube", "Editorial"],
            interestPills: ["New Balance 990v6", "Asics Gel-Kayano", "Daily miles"],
            trendingMerchants: ["New Balance", "Asics", "Hoka"],
            products: [
                .priced("TopicRunningProductNB", "$200"),
                .priced("TopicRunningProductSalomon", "$190"),
                .priced("TopicRunningProductAdidas", "$150"),
                .priced("TopicRunningProductOn", "$180"),
            ]
        ),
        .make(
            id: "countertop-coffee",
            title: "Coffee setup",
            subtitle: "Compact brewer tools and matching accessories that keep your counter minimal while still covering your full morning routine.",
            povText: "You prefer tidy Fellow-style coffee tools that fit small counters.",
            backgroundImageName: "TopicBgCoffeeBeans",
            color: 0x5A3A2D,
            accent: 0x7A4D36,
            sourceChips: ["Coffee TikTok", "YouTube", "Blogs"],
            interestPills: ["Fellow", "AeroPress", "Countertop minimalism"],
            trendingMerchants: ["Fellow", "Ratio", "Blue Bottle"],
            products: [
                .priced("TopicCoffeeProductKettle", "$195"),
                .priced("TopicCoffeeProductCanister", "$42"),
                .priced("TopicCoffeeProductGrinder", "$249"),
                .priced("TopicCoffeeProductMachine", "$365"),
            ]
        ),
        .make(
            id: "swedish-candy-finds",
            title: "Sweet gifts",
            subtitle: "Colorful imported candies, gift-ready packs, and nostalgic sour mixes that feel playful, collectible, and easy to share.",
            povText: "You keep exploring imported sweets and easy giftable pantry finds.",
            backgroundImageName: "TopicBgSweets",
            color: 0x17A9D7,
            accent: 0x2FC0E8,
            sourceChips: ["Food blogs", "Reddit", "YouTube"],
            interestPills: ["Swedish candy", "Gift bundles", "Pantry drops"],
            trendingMerchants: ["BonBon NYC", "Mouth", "Trade Coffee"],
            products: [
                .priced("TopicCandyProductGiftBox", "$34"),
                .priced("TopicCandyProductBerrySherbet", "$12"),
                .priced("TopicCandyProductBlueRaspberry", "$10"),
                .priced("TopicCandyProductBubsDuals", "$9"),
            ]
        ),
    ]
}
