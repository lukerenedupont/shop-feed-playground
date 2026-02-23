import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "APCPhoto" asset catalog image resource.
    static let apcPhoto = DeveloperToolsSupport.ImageResource(name: "APCPhoto", bundle: resourceBundle)

    /// The "Avatar" asset catalog image resource.
    static let avatar = DeveloperToolsSupport.ImageResource(name: "Avatar", bundle: resourceBundle)

    /// The "BellIcon" asset catalog image resource.
    static let bellIcon = DeveloperToolsSupport.ImageResource(name: "BellIcon", bundle: resourceBundle)

    /// The "BlackShoe1" asset catalog image resource.
    static let blackShoe1 = DeveloperToolsSupport.ImageResource(name: "BlackShoe1", bundle: resourceBundle)

    /// The "BlackShoe2" asset catalog image resource.
    static let blackShoe2 = DeveloperToolsSupport.ImageResource(name: "BlackShoe2", bundle: resourceBundle)

    /// The "BlackShoe3" asset catalog image resource.
    static let blackShoe3 = DeveloperToolsSupport.ImageResource(name: "BlackShoe3", bundle: resourceBundle)

    /// The "BlackShoe4" asset catalog image resource.
    static let blackShoe4 = DeveloperToolsSupport.ImageResource(name: "BlackShoe4", bundle: resourceBundle)

    /// The "BlackShoe5" asset catalog image resource.
    static let blackShoe5 = DeveloperToolsSupport.ImageResource(name: "BlackShoe5", bundle: resourceBundle)

    /// The "BlackShoe6" asset catalog image resource.
    static let blackShoe6 = DeveloperToolsSupport.ImageResource(name: "BlackShoe6", bundle: resourceBundle)

    /// The "BlueShoe1" asset catalog image resource.
    static let blueShoe1 = DeveloperToolsSupport.ImageResource(name: "BlueShoe1", bundle: resourceBundle)

    /// The "BlueShoe2" asset catalog image resource.
    static let blueShoe2 = DeveloperToolsSupport.ImageResource(name: "BlueShoe2", bundle: resourceBundle)

    /// The "BlueShoe3" asset catalog image resource.
    static let blueShoe3 = DeveloperToolsSupport.ImageResource(name: "BlueShoe3", bundle: resourceBundle)

    /// The "BlueShoe4" asset catalog image resource.
    static let blueShoe4 = DeveloperToolsSupport.ImageResource(name: "BlueShoe4", bundle: resourceBundle)

    /// The "BlueShoe5" asset catalog image resource.
    static let blueShoe5 = DeveloperToolsSupport.ImageResource(name: "BlueShoe5", bundle: resourceBundle)

    /// The "BlueShoe6" asset catalog image resource.
    static let blueShoe6 = DeveloperToolsSupport.ImageResource(name: "BlueShoe6", bundle: resourceBundle)

    /// The "BrownShoe1" asset catalog image resource.
    static let brownShoe1 = DeveloperToolsSupport.ImageResource(name: "BrownShoe1", bundle: resourceBundle)

    /// The "BrownShoe2" asset catalog image resource.
    static let brownShoe2 = DeveloperToolsSupport.ImageResource(name: "BrownShoe2", bundle: resourceBundle)

    /// The "BrownShoe3" asset catalog image resource.
    static let brownShoe3 = DeveloperToolsSupport.ImageResource(name: "BrownShoe3", bundle: resourceBundle)

    /// The "BrownShoe4" asset catalog image resource.
    static let brownShoe4 = DeveloperToolsSupport.ImageResource(name: "BrownShoe4", bundle: resourceBundle)

    /// The "BrownShoe5" asset catalog image resource.
    static let brownShoe5 = DeveloperToolsSupport.ImageResource(name: "BrownShoe5", bundle: resourceBundle)

    /// The "BrownShoe6" asset catalog image resource.
    static let brownShoe6 = DeveloperToolsSupport.ImageResource(name: "BrownShoe6", bundle: resourceBundle)

    /// The "BurgundyProductBeanie" asset catalog image resource.
    static let burgundyProductBeanie = DeveloperToolsSupport.ImageResource(name: "BurgundyProductBeanie", bundle: resourceBundle)

    /// The "BurgundyProductHoodie" asset catalog image resource.
    static let burgundyProductHoodie = DeveloperToolsSupport.ImageResource(name: "BurgundyProductHoodie", bundle: resourceBundle)

    /// The "BurgundyProductMug" asset catalog image resource.
    static let burgundyProductMug = DeveloperToolsSupport.ImageResource(name: "BurgundyProductMug", bundle: resourceBundle)

    /// The "BurgundyProductShirt" asset catalog image resource.
    static let burgundyProductShirt = DeveloperToolsSupport.ImageResource(name: "BurgundyProductShirt", bundle: resourceBundle)

    /// The "BurgundyProductSocks" asset catalog image resource.
    static let burgundyProductSocks = DeveloperToolsSupport.ImageResource(name: "BurgundyProductSocks", bundle: resourceBundle)

    /// The "BurgundyProductVans" asset catalog image resource.
    static let burgundyProductVans = DeveloperToolsSupport.ImageResource(name: "BurgundyProductVans", bundle: resourceBundle)

    /// The "BuyAgainIcon" asset catalog image resource.
    static let buyAgainIcon = DeveloperToolsSupport.ImageResource(name: "BuyAgainIcon", bundle: resourceBundle)

    /// The "CelebBadBunny" asset catalog image resource.
    static let celebBadBunny = DeveloperToolsSupport.ImageResource(name: "CelebBadBunny", bundle: resourceBundle)

    /// The "CelebJacob" asset catalog image resource.
    static let celebJacob = DeveloperToolsSupport.ImageResource(name: "CelebJacob", bundle: resourceBundle)

    /// The "CelebJonah" asset catalog image resource.
    static let celebJonah = DeveloperToolsSupport.ImageResource(name: "CelebJonah", bundle: resourceBundle)

    /// The "F1Albon" asset catalog image resource.
    static let f1Albon = DeveloperToolsSupport.ImageResource(name: "F1Albon", bundle: resourceBundle)

    /// The "F1Alonso" asset catalog image resource.
    static let f1Alonso = DeveloperToolsSupport.ImageResource(name: "F1Alonso", bundle: resourceBundle)

    /// The "F1Gasly" asset catalog image resource.
    static let f1Gasly = DeveloperToolsSupport.ImageResource(name: "F1Gasly", bundle: resourceBundle)

    /// The "F1Hamilton" asset catalog image resource.
    static let f1Hamilton = DeveloperToolsSupport.ImageResource(name: "F1Hamilton", bundle: resourceBundle)

    /// The "F1Leclerc" asset catalog image resource.
    static let f1Leclerc = DeveloperToolsSupport.ImageResource(name: "F1Leclerc", bundle: resourceBundle)

    /// The "F1LeclercBanner" asset catalog image resource.
    static let f1LeclercBanner = DeveloperToolsSupport.ImageResource(name: "F1LeclercBanner", bundle: resourceBundle)

    /// The "F1Norris" asset catalog image resource.
    static let f1Norris = DeveloperToolsSupport.ImageResource(name: "F1Norris", bundle: resourceBundle)

    /// The "F1Verstappen" asset catalog image resource.
    static let f1Verstappen = DeveloperToolsSupport.ImageResource(name: "F1Verstappen", bundle: resourceBundle)

    /// The "GreenShoe1" asset catalog image resource.
    static let greenShoe1 = DeveloperToolsSupport.ImageResource(name: "GreenShoe1", bundle: resourceBundle)

    /// The "GreenShoe2" asset catalog image resource.
    static let greenShoe2 = DeveloperToolsSupport.ImageResource(name: "GreenShoe2", bundle: resourceBundle)

    /// The "GreenShoe3" asset catalog image resource.
    static let greenShoe3 = DeveloperToolsSupport.ImageResource(name: "GreenShoe3", bundle: resourceBundle)

    /// The "GreenShoe4" asset catalog image resource.
    static let greenShoe4 = DeveloperToolsSupport.ImageResource(name: "GreenShoe4", bundle: resourceBundle)

    /// The "GreenShoe5" asset catalog image resource.
    static let greenShoe5 = DeveloperToolsSupport.ImageResource(name: "GreenShoe5", bundle: resourceBundle)

    /// The "GreenShoe6" asset catalog image resource.
    static let greenShoe6 = DeveloperToolsSupport.ImageResource(name: "GreenShoe6", bundle: resourceBundle)

    /// The "HeartFilled" asset catalog image resource.
    static let heartFilled = DeveloperToolsSupport.ImageResource(name: "HeartFilled", bundle: resourceBundle)

    /// The "HeartIcon" asset catalog image resource.
    static let heartIcon = DeveloperToolsSupport.ImageResource(name: "HeartIcon", bundle: resourceBundle)

    /// The "HeartOutlineIcon" asset catalog image resource.
    static let heartOutlineIcon = DeveloperToolsSupport.ImageResource(name: "HeartOutlineIcon", bundle: resourceBundle)

    /// The "HomeIcon" asset catalog image resource.
    static let homeIcon = DeveloperToolsSupport.ImageResource(name: "HomeIcon", bundle: resourceBundle)

    /// The "LogoCaraway" asset catalog image resource.
    static let logoCaraway = DeveloperToolsSupport.ImageResource(name: "LogoCaraway", bundle: resourceBundle)

    /// The "LogoCeremonia" asset catalog image resource.
    static let logoCeremonia = DeveloperToolsSupport.ImageResource(name: "LogoCeremonia", bundle: resourceBundle)

    /// The "LogoHasbro" asset catalog image resource.
    static let logoHasbro = DeveloperToolsSupport.ImageResource(name: "LogoHasbro", bundle: resourceBundle)

    /// The "LogoKith" asset catalog image resource.
    static let logoKith = DeveloperToolsSupport.ImageResource(name: "LogoKith", bundle: resourceBundle)

    /// The "LogoMoscot" asset catalog image resource.
    static let logoMoscot = DeveloperToolsSupport.ImageResource(name: "LogoMoscot", bundle: resourceBundle)

    /// The "LogoNike" asset catalog image resource.
    static let logoNike = DeveloperToolsSupport.ImageResource(name: "LogoNike", bundle: resourceBundle)

    /// The "LogoNoguchi" asset catalog image resource.
    static let logoNoguchi = DeveloperToolsSupport.ImageResource(name: "LogoNoguchi", bundle: resourceBundle)

    /// The "LogoOwala" asset catalog image resource.
    static let logoOwala = DeveloperToolsSupport.ImageResource(name: "LogoOwala", bundle: resourceBundle)

    /// The "LogoReebok" asset catalog image resource.
    static let logoReebok = DeveloperToolsSupport.ImageResource(name: "LogoReebok", bundle: resourceBundle)

    /// The "LogoTekla" asset catalog image resource.
    static let logoTekla = DeveloperToolsSupport.ImageResource(name: "LogoTekla", bundle: resourceBundle)

    /// The "LogoVacation" asset catalog image resource.
    static let logoVacation = DeveloperToolsSupport.ImageResource(name: "LogoVacation", bundle: resourceBundle)

    /// The "MartyCoat" asset catalog image resource.
    static let martyCoat = DeveloperToolsSupport.ImageResource(name: "MartyCoat", bundle: resourceBundle)

    /// The "MartyGlasses" asset catalog image resource.
    static let martyGlasses = DeveloperToolsSupport.ImageResource(name: "MartyGlasses", bundle: resourceBundle)

    /// The "MartyGloves" asset catalog image resource.
    static let martyGloves = DeveloperToolsSupport.ImageResource(name: "MartyGloves", bundle: resourceBundle)

    /// The "MartySupreme" asset catalog image resource.
    static let martySupreme = DeveloperToolsSupport.ImageResource(name: "MartySupreme", bundle: resourceBundle)

    /// The "MartyTie" asset catalog image resource.
    static let martyTie = DeveloperToolsSupport.ImageResource(name: "MartyTie", bundle: resourceBundle)

    /// The "OrdersIcon" asset catalog image resource.
    static let ordersIcon = DeveloperToolsSupport.ImageResource(name: "OrdersIcon", bundle: resourceBundle)

    /// The "PileBeanie" asset catalog image resource.
    static let pileBeanie = DeveloperToolsSupport.ImageResource(name: "PileBeanie", bundle: resourceBundle)

    /// The "PileLantern" asset catalog image resource.
    static let pileLantern = DeveloperToolsSupport.ImageResource(name: "PileLantern", bundle: resourceBundle)

    /// The "PileMatchaTin" asset catalog image resource.
    static let pileMatchaTin = DeveloperToolsSupport.ImageResource(name: "PileMatchaTin", bundle: resourceBundle)

    /// The "PileNike" asset catalog image resource.
    static let pileNike = DeveloperToolsSupport.ImageResource(name: "PileNike", bundle: resourceBundle)

    /// The "PilePerfume" asset catalog image resource.
    static let pilePerfume = DeveloperToolsSupport.ImageResource(name: "PilePerfume", bundle: resourceBundle)

    /// The "PileReebok" asset catalog image resource.
    static let pileReebok = DeveloperToolsSupport.ImageResource(name: "PileReebok", bundle: resourceBundle)

    /// The "PileSaucepan" asset catalog image resource.
    static let pileSaucepan = DeveloperToolsSupport.ImageResource(name: "PileSaucepan", bundle: resourceBundle)

    /// The "PileSlippers" asset catalog image resource.
    static let pileSlippers = DeveloperToolsSupport.ImageResource(name: "PileSlippers", bundle: resourceBundle)

    /// The "PileSunglasses" asset catalog image resource.
    static let pileSunglasses = DeveloperToolsSupport.ImageResource(name: "PileSunglasses", bundle: resourceBundle)

    /// The "PileSunscreen" asset catalog image resource.
    static let pileSunscreen = DeveloperToolsSupport.ImageResource(name: "PileSunscreen", bundle: resourceBundle)

    /// The "PileTray" asset catalog image resource.
    static let pileTray = DeveloperToolsSupport.ImageResource(name: "PileTray", bundle: resourceBundle)

    /// The "PileWaterBottle" asset catalog image resource.
    static let pileWaterBottle = DeveloperToolsSupport.ImageResource(name: "PileWaterBottle", bundle: resourceBundle)

    /// The "PileWolverine" asset catalog image resource.
    static let pileWolverine = DeveloperToolsSupport.ImageResource(name: "PileWolverine", bundle: resourceBundle)

    /// The "PileYankeesCap" asset catalog image resource.
    static let pileYankeesCap = DeveloperToolsSupport.ImageResource(name: "PileYankeesCap", bundle: resourceBundle)

    /// The "PlusIcon" asset catalog image resource.
    static let plusIcon = DeveloperToolsSupport.ImageResource(name: "PlusIcon", bundle: resourceBundle)

    /// The "PocketShoe1" asset catalog image resource.
    static let pocketShoe1 = DeveloperToolsSupport.ImageResource(name: "PocketShoe1", bundle: resourceBundle)

    /// The "PocketShoe2" asset catalog image resource.
    static let pocketShoe2 = DeveloperToolsSupport.ImageResource(name: "PocketShoe2", bundle: resourceBundle)

    /// The "PocketShoe3" asset catalog image resource.
    static let pocketShoe3 = DeveloperToolsSupport.ImageResource(name: "PocketShoe3", bundle: resourceBundle)

    /// The "PocketShoe4" asset catalog image resource.
    static let pocketShoe4 = DeveloperToolsSupport.ImageResource(name: "PocketShoe4", bundle: resourceBundle)

    /// The "PocketShoe5" asset catalog image resource.
    static let pocketShoe5 = DeveloperToolsSupport.ImageResource(name: "PocketShoe5", bundle: resourceBundle)

    /// The "PortraitDion" asset catalog image resource.
    static let portraitDion = DeveloperToolsSupport.ImageResource(name: "PortraitDion", bundle: resourceBundle)

    /// The "PortraitLady" asset catalog image resource.
    static let portraitLady = DeveloperToolsSupport.ImageResource(name: "PortraitLady", bundle: resourceBundle)

    /// The "PortraitMarty" asset catalog image resource.
    static let portraitMarty = DeveloperToolsSupport.ImageResource(name: "PortraitMarty", bundle: resourceBundle)

    /// The "PortraitOldGuy" asset catalog image resource.
    static let portraitOldGuy = DeveloperToolsSupport.ImageResource(name: "PortraitOldGuy", bundle: resourceBundle)

    /// The "PortraitWally" asset catalog image resource.
    static let portraitWally = DeveloperToolsSupport.ImageResource(name: "PortraitWally", bundle: resourceBundle)

    /// The "PriceCaraway" asset catalog image resource.
    static let priceCaraway = DeveloperToolsSupport.ImageResource(name: "PriceCaraway", bundle: resourceBundle)

    /// The "PriceCheckLogo" asset catalog image resource.
    static let priceCheckLogo = DeveloperToolsSupport.ImageResource(name: "PriceCheckLogo", bundle: resourceBundle)

    /// The "PriceErrorsCap" asset catalog image resource.
    static let priceErrorsCap = DeveloperToolsSupport.ImageResource(name: "PriceErrorsCap", bundle: resourceBundle)

    /// The "PriceErrorsFleece" asset catalog image resource.
    static let priceErrorsFleece = DeveloperToolsSupport.ImageResource(name: "PriceErrorsFleece", bundle: resourceBundle)

    /// The "PriceFrostedFlakes" asset catalog image resource.
    static let priceFrostedFlakes = DeveloperToolsSupport.ImageResource(name: "PriceFrostedFlakes", bundle: resourceBundle)

    /// The "PriceJordan" asset catalog image resource.
    static let priceJordan = DeveloperToolsSupport.ImageResource(name: "PriceJordan", bundle: resourceBundle)

    /// The "PriceLamp" asset catalog image resource.
    static let priceLamp = DeveloperToolsSupport.ImageResource(name: "PriceLamp", bundle: resourceBundle)

    /// The "PriceMetsCap" asset catalog image resource.
    static let priceMetsCap = DeveloperToolsSupport.ImageResource(name: "PriceMetsCap", bundle: resourceBundle)

    /// The "ScratchAPCHero" asset catalog image resource.
    static let scratchAPCHero = DeveloperToolsSupport.ImageResource(name: "ScratchAPCHero", bundle: resourceBundle)

    /// The "ScratchAPCLogo" asset catalog image resource.
    static let scratchAPCLogo = DeveloperToolsSupport.ImageResource(name: "ScratchAPCLogo", bundle: resourceBundle)

    /// The "ScratchAPCProduct1" asset catalog image resource.
    static let scratchAPCProduct1 = DeveloperToolsSupport.ImageResource(name: "ScratchAPCProduct1", bundle: resourceBundle)

    /// The "ScratchAPCProduct2" asset catalog image resource.
    static let scratchAPCProduct2 = DeveloperToolsSupport.ImageResource(name: "ScratchAPCProduct2", bundle: resourceBundle)

    /// The "ScratchAPCProduct3" asset catalog image resource.
    static let scratchAPCProduct3 = DeveloperToolsSupport.ImageResource(name: "ScratchAPCProduct3", bundle: resourceBundle)

    /// The "ScratchAPCProduct4" asset catalog image resource.
    static let scratchAPCProduct4 = DeveloperToolsSupport.ImageResource(name: "ScratchAPCProduct4", bundle: resourceBundle)

    /// The "SearchIcon" asset catalog image resource.
    static let searchIcon = DeveloperToolsSupport.ImageResource(name: "SearchIcon", bundle: resourceBundle)

    /// The "ShoeSwipeBlack" asset catalog image resource.
    static let shoeSwipeBlack = DeveloperToolsSupport.ImageResource(name: "ShoeSwipeBlack", bundle: resourceBundle)

    /// The "ShoeSwipeGreen" asset catalog image resource.
    static let shoeSwipeGreen = DeveloperToolsSupport.ImageResource(name: "ShoeSwipeGreen", bundle: resourceBundle)

    /// The "ShoeSwipeKithLogo" asset catalog image resource.
    static let shoeSwipeKithLogo = DeveloperToolsSupport.ImageResource(name: "ShoeSwipeKithLogo", bundle: resourceBundle)

    /// The "ShoeSwipeWhiteRed" asset catalog image resource.
    static let shoeSwipeWhiteRed = DeveloperToolsSupport.ImageResource(name: "ShoeSwipeWhiteRed", bundle: resourceBundle)

    /// The "ShopLookAvatar01" asset catalog image resource.
    static let shopLookAvatar01 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar01", bundle: resourceBundle)

    /// The "ShopLookAvatar02" asset catalog image resource.
    static let shopLookAvatar02 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar02", bundle: resourceBundle)

    /// The "ShopLookAvatar03" asset catalog image resource.
    static let shopLookAvatar03 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar03", bundle: resourceBundle)

    /// The "ShopLookAvatar04" asset catalog image resource.
    static let shopLookAvatar04 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar04", bundle: resourceBundle)

    /// The "ShopLookAvatar05" asset catalog image resource.
    static let shopLookAvatar05 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar05", bundle: resourceBundle)

    /// The "ShopLookAvatar06" asset catalog image resource.
    static let shopLookAvatar06 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar06", bundle: resourceBundle)

    /// The "ShopLookAvatar07" asset catalog image resource.
    static let shopLookAvatar07 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar07", bundle: resourceBundle)

    /// The "ShopLookAvatar08" asset catalog image resource.
    static let shopLookAvatar08 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar08", bundle: resourceBundle)

    /// The "ShopLookAvatar09" asset catalog image resource.
    static let shopLookAvatar09 = DeveloperToolsSupport.ImageResource(name: "ShopLookAvatar09", bundle: resourceBundle)

    /// The "ShopPromise" asset catalog image resource.
    static let shopPromise = DeveloperToolsSupport.ImageResource(name: "ShopPromise", bundle: resourceBundle)

    /// The "ShopTheLookPerson" asset catalog image resource.
    static let shopTheLookPerson = DeveloperToolsSupport.ImageResource(name: "ShopTheLookPerson", bundle: resourceBundle)

    /// The "SilverShoe1" asset catalog image resource.
    static let silverShoe1 = DeveloperToolsSupport.ImageResource(name: "SilverShoe1", bundle: resourceBundle)

    /// The "SilverShoe2" asset catalog image resource.
    static let silverShoe2 = DeveloperToolsSupport.ImageResource(name: "SilverShoe2", bundle: resourceBundle)

    /// The "SilverShoe3" asset catalog image resource.
    static let silverShoe3 = DeveloperToolsSupport.ImageResource(name: "SilverShoe3", bundle: resourceBundle)

    /// The "SilverShoe4" asset catalog image resource.
    static let silverShoe4 = DeveloperToolsSupport.ImageResource(name: "SilverShoe4", bundle: resourceBundle)

    /// The "SilverShoe5" asset catalog image resource.
    static let silverShoe5 = DeveloperToolsSupport.ImageResource(name: "SilverShoe5", bundle: resourceBundle)

    /// The "SilverShoe6" asset catalog image resource.
    static let silverShoe6 = DeveloperToolsSupport.ImageResource(name: "SilverShoe6", bundle: resourceBundle)

    /// The "SimilarShoe1" asset catalog image resource.
    static let similarShoe1 = DeveloperToolsSupport.ImageResource(name: "SimilarShoe1", bundle: resourceBundle)

    /// The "SimilarShoe2" asset catalog image resource.
    static let similarShoe2 = DeveloperToolsSupport.ImageResource(name: "SimilarShoe2", bundle: resourceBundle)

    /// The "SimilarShoe3" asset catalog image resource.
    static let similarShoe3 = DeveloperToolsSupport.ImageResource(name: "SimilarShoe3", bundle: resourceBundle)

    /// The "SimilarShoe4" asset catalog image resource.
    static let similarShoe4 = DeveloperToolsSupport.ImageResource(name: "SimilarShoe4", bundle: resourceBundle)

    /// The "SimilarShoe5" asset catalog image resource.
    static let similarShoe5 = DeveloperToolsSupport.ImageResource(name: "SimilarShoe5", bundle: resourceBundle)

    /// The "SimilarShoe6" asset catalog image resource.
    static let similarShoe6 = DeveloperToolsSupport.ImageResource(name: "SimilarShoe6", bundle: resourceBundle)

    /// The "SimilarShoe7" asset catalog image resource.
    static let similarShoe7 = DeveloperToolsSupport.ImageResource(name: "SimilarShoe7", bundle: resourceBundle)

    /// The "SimilarShoe8" asset catalog image resource.
    static let similarShoe8 = DeveloperToolsSupport.ImageResource(name: "SimilarShoe8", bundle: resourceBundle)

    /// The "StarIcon" asset catalog image resource.
    static let starIcon = DeveloperToolsSupport.ImageResource(name: "StarIcon", bundle: resourceBundle)

    /// The "TagIcon" asset catalog image resource.
    static let tagIcon = DeveloperToolsSupport.ImageResource(name: "TagIcon", bundle: resourceBundle)

    /// The "VerifyIcon" asset catalog image resource.
    static let verifyIcon = DeveloperToolsSupport.ImageResource(name: "VerifyIcon", bundle: resourceBundle)

    /// The "VoiceIcon" asset catalog image resource.
    static let voiceIcon = DeveloperToolsSupport.ImageResource(name: "VoiceIcon", bundle: resourceBundle)

    /// The "WhiteShoe1" asset catalog image resource.
    static let whiteShoe1 = DeveloperToolsSupport.ImageResource(name: "WhiteShoe1", bundle: resourceBundle)

    /// The "WhiteShoe2" asset catalog image resource.
    static let whiteShoe2 = DeveloperToolsSupport.ImageResource(name: "WhiteShoe2", bundle: resourceBundle)

    /// The "WhiteShoe3" asset catalog image resource.
    static let whiteShoe3 = DeveloperToolsSupport.ImageResource(name: "WhiteShoe3", bundle: resourceBundle)

    /// The "WhiteShoe4" asset catalog image resource.
    static let whiteShoe4 = DeveloperToolsSupport.ImageResource(name: "WhiteShoe4", bundle: resourceBundle)

    /// The "WhiteShoe5" asset catalog image resource.
    static let whiteShoe5 = DeveloperToolsSupport.ImageResource(name: "WhiteShoe5", bundle: resourceBundle)

    /// The "WhiteShoe6" asset catalog image resource.
    static let whiteShoe6 = DeveloperToolsSupport.ImageResource(name: "WhiteShoe6", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "APCPhoto" asset catalog image.
    static var apcPhoto: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .apcPhoto)
#else
        .init()
#endif
    }

    /// The "Avatar" asset catalog image.
    static var avatar: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .avatar)
#else
        .init()
#endif
    }

    /// The "BellIcon" asset catalog image.
    static var bellIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .bellIcon)
#else
        .init()
#endif
    }

    /// The "BlackShoe1" asset catalog image.
    static var blackShoe1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blackShoe1)
#else
        .init()
#endif
    }

    /// The "BlackShoe2" asset catalog image.
    static var blackShoe2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blackShoe2)
#else
        .init()
#endif
    }

    /// The "BlackShoe3" asset catalog image.
    static var blackShoe3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blackShoe3)
#else
        .init()
#endif
    }

    /// The "BlackShoe4" asset catalog image.
    static var blackShoe4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blackShoe4)
#else
        .init()
#endif
    }

    /// The "BlackShoe5" asset catalog image.
    static var blackShoe5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blackShoe5)
#else
        .init()
#endif
    }

    /// The "BlackShoe6" asset catalog image.
    static var blackShoe6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blackShoe6)
#else
        .init()
#endif
    }

    /// The "BlueShoe1" asset catalog image.
    static var blueShoe1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blueShoe1)
#else
        .init()
#endif
    }

    /// The "BlueShoe2" asset catalog image.
    static var blueShoe2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blueShoe2)
#else
        .init()
#endif
    }

    /// The "BlueShoe3" asset catalog image.
    static var blueShoe3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blueShoe3)
#else
        .init()
#endif
    }

    /// The "BlueShoe4" asset catalog image.
    static var blueShoe4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blueShoe4)
#else
        .init()
#endif
    }

    /// The "BlueShoe5" asset catalog image.
    static var blueShoe5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blueShoe5)
#else
        .init()
#endif
    }

    /// The "BlueShoe6" asset catalog image.
    static var blueShoe6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .blueShoe6)
#else
        .init()
#endif
    }

    /// The "BrownShoe1" asset catalog image.
    static var brownShoe1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brownShoe1)
#else
        .init()
#endif
    }

    /// The "BrownShoe2" asset catalog image.
    static var brownShoe2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brownShoe2)
#else
        .init()
#endif
    }

    /// The "BrownShoe3" asset catalog image.
    static var brownShoe3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brownShoe3)
#else
        .init()
#endif
    }

    /// The "BrownShoe4" asset catalog image.
    static var brownShoe4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brownShoe4)
#else
        .init()
#endif
    }

    /// The "BrownShoe5" asset catalog image.
    static var brownShoe5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brownShoe5)
#else
        .init()
#endif
    }

    /// The "BrownShoe6" asset catalog image.
    static var brownShoe6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .brownShoe6)
#else
        .init()
#endif
    }

    /// The "BurgundyProductBeanie" asset catalog image.
    static var burgundyProductBeanie: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .burgundyProductBeanie)
#else
        .init()
#endif
    }

    /// The "BurgundyProductHoodie" asset catalog image.
    static var burgundyProductHoodie: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .burgundyProductHoodie)
#else
        .init()
#endif
    }

    /// The "BurgundyProductMug" asset catalog image.
    static var burgundyProductMug: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .burgundyProductMug)
#else
        .init()
#endif
    }

    /// The "BurgundyProductShirt" asset catalog image.
    static var burgundyProductShirt: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .burgundyProductShirt)
#else
        .init()
#endif
    }

    /// The "BurgundyProductSocks" asset catalog image.
    static var burgundyProductSocks: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .burgundyProductSocks)
#else
        .init()
#endif
    }

    /// The "BurgundyProductVans" asset catalog image.
    static var burgundyProductVans: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .burgundyProductVans)
#else
        .init()
#endif
    }

    /// The "BuyAgainIcon" asset catalog image.
    static var buyAgainIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .buyAgainIcon)
#else
        .init()
#endif
    }

    /// The "CelebBadBunny" asset catalog image.
    static var celebBadBunny: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .celebBadBunny)
#else
        .init()
#endif
    }

    /// The "CelebJacob" asset catalog image.
    static var celebJacob: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .celebJacob)
#else
        .init()
#endif
    }

    /// The "CelebJonah" asset catalog image.
    static var celebJonah: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .celebJonah)
#else
        .init()
#endif
    }

    /// The "F1Albon" asset catalog image.
    static var f1Albon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .f1Albon)
#else
        .init()
#endif
    }

    /// The "F1Alonso" asset catalog image.
    static var f1Alonso: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .f1Alonso)
#else
        .init()
#endif
    }

    /// The "F1Gasly" asset catalog image.
    static var f1Gasly: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .f1Gasly)
#else
        .init()
#endif
    }

    /// The "F1Hamilton" asset catalog image.
    static var f1Hamilton: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .f1Hamilton)
#else
        .init()
#endif
    }

    /// The "F1Leclerc" asset catalog image.
    static var f1Leclerc: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .f1Leclerc)
#else
        .init()
#endif
    }

    /// The "F1LeclercBanner" asset catalog image.
    static var f1LeclercBanner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .f1LeclercBanner)
#else
        .init()
#endif
    }

    /// The "F1Norris" asset catalog image.
    static var f1Norris: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .f1Norris)
#else
        .init()
#endif
    }

    /// The "F1Verstappen" asset catalog image.
    static var f1Verstappen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .f1Verstappen)
#else
        .init()
#endif
    }

    /// The "GreenShoe1" asset catalog image.
    static var greenShoe1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .greenShoe1)
#else
        .init()
#endif
    }

    /// The "GreenShoe2" asset catalog image.
    static var greenShoe2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .greenShoe2)
#else
        .init()
#endif
    }

    /// The "GreenShoe3" asset catalog image.
    static var greenShoe3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .greenShoe3)
#else
        .init()
#endif
    }

    /// The "GreenShoe4" asset catalog image.
    static var greenShoe4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .greenShoe4)
#else
        .init()
#endif
    }

    /// The "GreenShoe5" asset catalog image.
    static var greenShoe5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .greenShoe5)
#else
        .init()
#endif
    }

    /// The "GreenShoe6" asset catalog image.
    static var greenShoe6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .greenShoe6)
#else
        .init()
#endif
    }

    /// The "HeartFilled" asset catalog image.
    static var heartFilled: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .heartFilled)
#else
        .init()
#endif
    }

    /// The "HeartIcon" asset catalog image.
    static var heartIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .heartIcon)
#else
        .init()
#endif
    }

    /// The "HeartOutlineIcon" asset catalog image.
    static var heartOutlineIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .heartOutlineIcon)
#else
        .init()
#endif
    }

    /// The "HomeIcon" asset catalog image.
    static var homeIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .homeIcon)
#else
        .init()
#endif
    }

    /// The "LogoCaraway" asset catalog image.
    static var logoCaraway: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoCaraway)
#else
        .init()
#endif
    }

    /// The "LogoCeremonia" asset catalog image.
    static var logoCeremonia: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoCeremonia)
#else
        .init()
#endif
    }

    /// The "LogoHasbro" asset catalog image.
    static var logoHasbro: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoHasbro)
#else
        .init()
#endif
    }

    /// The "LogoKith" asset catalog image.
    static var logoKith: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoKith)
#else
        .init()
#endif
    }

    /// The "LogoMoscot" asset catalog image.
    static var logoMoscot: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoMoscot)
#else
        .init()
#endif
    }

    /// The "LogoNike" asset catalog image.
    static var logoNike: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoNike)
#else
        .init()
#endif
    }

    /// The "LogoNoguchi" asset catalog image.
    static var logoNoguchi: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoNoguchi)
#else
        .init()
#endif
    }

    /// The "LogoOwala" asset catalog image.
    static var logoOwala: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoOwala)
#else
        .init()
#endif
    }

    /// The "LogoReebok" asset catalog image.
    static var logoReebok: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoReebok)
#else
        .init()
#endif
    }

    /// The "LogoTekla" asset catalog image.
    static var logoTekla: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoTekla)
#else
        .init()
#endif
    }

    /// The "LogoVacation" asset catalog image.
    static var logoVacation: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .logoVacation)
#else
        .init()
#endif
    }

    /// The "MartyCoat" asset catalog image.
    static var martyCoat: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .martyCoat)
#else
        .init()
#endif
    }

    /// The "MartyGlasses" asset catalog image.
    static var martyGlasses: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .martyGlasses)
#else
        .init()
#endif
    }

    /// The "MartyGloves" asset catalog image.
    static var martyGloves: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .martyGloves)
#else
        .init()
#endif
    }

    /// The "MartySupreme" asset catalog image.
    static var martySupreme: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .martySupreme)
#else
        .init()
#endif
    }

    /// The "MartyTie" asset catalog image.
    static var martyTie: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .martyTie)
#else
        .init()
#endif
    }

    /// The "OrdersIcon" asset catalog image.
    static var ordersIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .ordersIcon)
#else
        .init()
#endif
    }

    /// The "PileBeanie" asset catalog image.
    static var pileBeanie: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileBeanie)
#else
        .init()
#endif
    }

    /// The "PileLantern" asset catalog image.
    static var pileLantern: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileLantern)
#else
        .init()
#endif
    }

    /// The "PileMatchaTin" asset catalog image.
    static var pileMatchaTin: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileMatchaTin)
#else
        .init()
#endif
    }

    /// The "PileNike" asset catalog image.
    static var pileNike: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileNike)
#else
        .init()
#endif
    }

    /// The "PilePerfume" asset catalog image.
    static var pilePerfume: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pilePerfume)
#else
        .init()
#endif
    }

    /// The "PileReebok" asset catalog image.
    static var pileReebok: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileReebok)
#else
        .init()
#endif
    }

    /// The "PileSaucepan" asset catalog image.
    static var pileSaucepan: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileSaucepan)
#else
        .init()
#endif
    }

    /// The "PileSlippers" asset catalog image.
    static var pileSlippers: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileSlippers)
#else
        .init()
#endif
    }

    /// The "PileSunglasses" asset catalog image.
    static var pileSunglasses: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileSunglasses)
#else
        .init()
#endif
    }

    /// The "PileSunscreen" asset catalog image.
    static var pileSunscreen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileSunscreen)
#else
        .init()
#endif
    }

    /// The "PileTray" asset catalog image.
    static var pileTray: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileTray)
#else
        .init()
#endif
    }

    /// The "PileWaterBottle" asset catalog image.
    static var pileWaterBottle: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileWaterBottle)
#else
        .init()
#endif
    }

    /// The "PileWolverine" asset catalog image.
    static var pileWolverine: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileWolverine)
#else
        .init()
#endif
    }

    /// The "PileYankeesCap" asset catalog image.
    static var pileYankeesCap: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pileYankeesCap)
#else
        .init()
#endif
    }

    /// The "PlusIcon" asset catalog image.
    static var plusIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .plusIcon)
#else
        .init()
#endif
    }

    /// The "PocketShoe1" asset catalog image.
    static var pocketShoe1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pocketShoe1)
#else
        .init()
#endif
    }

    /// The "PocketShoe2" asset catalog image.
    static var pocketShoe2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pocketShoe2)
#else
        .init()
#endif
    }

    /// The "PocketShoe3" asset catalog image.
    static var pocketShoe3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pocketShoe3)
#else
        .init()
#endif
    }

    /// The "PocketShoe4" asset catalog image.
    static var pocketShoe4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pocketShoe4)
#else
        .init()
#endif
    }

    /// The "PocketShoe5" asset catalog image.
    static var pocketShoe5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pocketShoe5)
#else
        .init()
#endif
    }

    /// The "PortraitDion" asset catalog image.
    static var portraitDion: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .portraitDion)
#else
        .init()
#endif
    }

    /// The "PortraitLady" asset catalog image.
    static var portraitLady: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .portraitLady)
#else
        .init()
#endif
    }

    /// The "PortraitMarty" asset catalog image.
    static var portraitMarty: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .portraitMarty)
#else
        .init()
#endif
    }

    /// The "PortraitOldGuy" asset catalog image.
    static var portraitOldGuy: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .portraitOldGuy)
#else
        .init()
#endif
    }

    /// The "PortraitWally" asset catalog image.
    static var portraitWally: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .portraitWally)
#else
        .init()
#endif
    }

    /// The "PriceCaraway" asset catalog image.
    static var priceCaraway: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priceCaraway)
#else
        .init()
#endif
    }

    /// The "PriceCheckLogo" asset catalog image.
    static var priceCheckLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priceCheckLogo)
#else
        .init()
#endif
    }

    /// The "PriceErrorsCap" asset catalog image.
    static var priceErrorsCap: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priceErrorsCap)
#else
        .init()
#endif
    }

    /// The "PriceErrorsFleece" asset catalog image.
    static var priceErrorsFleece: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priceErrorsFleece)
#else
        .init()
#endif
    }

    /// The "PriceFrostedFlakes" asset catalog image.
    static var priceFrostedFlakes: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priceFrostedFlakes)
#else
        .init()
#endif
    }

    /// The "PriceJordan" asset catalog image.
    static var priceJordan: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priceJordan)
#else
        .init()
#endif
    }

    /// The "PriceLamp" asset catalog image.
    static var priceLamp: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priceLamp)
#else
        .init()
#endif
    }

    /// The "PriceMetsCap" asset catalog image.
    static var priceMetsCap: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .priceMetsCap)
#else
        .init()
#endif
    }

    /// The "ScratchAPCHero" asset catalog image.
    static var scratchAPCHero: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .scratchAPCHero)
#else
        .init()
#endif
    }

    /// The "ScratchAPCLogo" asset catalog image.
    static var scratchAPCLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .scratchAPCLogo)
#else
        .init()
#endif
    }

    /// The "ScratchAPCProduct1" asset catalog image.
    static var scratchAPCProduct1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .scratchAPCProduct1)
#else
        .init()
#endif
    }

    /// The "ScratchAPCProduct2" asset catalog image.
    static var scratchAPCProduct2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .scratchAPCProduct2)
#else
        .init()
#endif
    }

    /// The "ScratchAPCProduct3" asset catalog image.
    static var scratchAPCProduct3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .scratchAPCProduct3)
#else
        .init()
#endif
    }

    /// The "ScratchAPCProduct4" asset catalog image.
    static var scratchAPCProduct4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .scratchAPCProduct4)
#else
        .init()
#endif
    }

    /// The "SearchIcon" asset catalog image.
    static var searchIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .searchIcon)
#else
        .init()
#endif
    }

    /// The "ShoeSwipeBlack" asset catalog image.
    static var shoeSwipeBlack: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shoeSwipeBlack)
#else
        .init()
#endif
    }

    /// The "ShoeSwipeGreen" asset catalog image.
    static var shoeSwipeGreen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shoeSwipeGreen)
#else
        .init()
#endif
    }

    /// The "ShoeSwipeKithLogo" asset catalog image.
    static var shoeSwipeKithLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shoeSwipeKithLogo)
#else
        .init()
#endif
    }

    /// The "ShoeSwipeWhiteRed" asset catalog image.
    static var shoeSwipeWhiteRed: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shoeSwipeWhiteRed)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar01" asset catalog image.
    static var shopLookAvatar01: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar01)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar02" asset catalog image.
    static var shopLookAvatar02: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar02)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar03" asset catalog image.
    static var shopLookAvatar03: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar03)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar04" asset catalog image.
    static var shopLookAvatar04: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar04)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar05" asset catalog image.
    static var shopLookAvatar05: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar05)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar06" asset catalog image.
    static var shopLookAvatar06: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar06)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar07" asset catalog image.
    static var shopLookAvatar07: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar07)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar08" asset catalog image.
    static var shopLookAvatar08: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar08)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar09" asset catalog image.
    static var shopLookAvatar09: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopLookAvatar09)
#else
        .init()
#endif
    }

    /// The "ShopPromise" asset catalog image.
    static var shopPromise: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopPromise)
#else
        .init()
#endif
    }

    /// The "ShopTheLookPerson" asset catalog image.
    static var shopTheLookPerson: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .shopTheLookPerson)
#else
        .init()
#endif
    }

    /// The "SilverShoe1" asset catalog image.
    static var silverShoe1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .silverShoe1)
#else
        .init()
#endif
    }

    /// The "SilverShoe2" asset catalog image.
    static var silverShoe2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .silverShoe2)
#else
        .init()
#endif
    }

    /// The "SilverShoe3" asset catalog image.
    static var silverShoe3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .silverShoe3)
#else
        .init()
#endif
    }

    /// The "SilverShoe4" asset catalog image.
    static var silverShoe4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .silverShoe4)
#else
        .init()
#endif
    }

    /// The "SilverShoe5" asset catalog image.
    static var silverShoe5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .silverShoe5)
#else
        .init()
#endif
    }

    /// The "SilverShoe6" asset catalog image.
    static var silverShoe6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .silverShoe6)
#else
        .init()
#endif
    }

    /// The "SimilarShoe1" asset catalog image.
    static var similarShoe1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .similarShoe1)
#else
        .init()
#endif
    }

    /// The "SimilarShoe2" asset catalog image.
    static var similarShoe2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .similarShoe2)
#else
        .init()
#endif
    }

    /// The "SimilarShoe3" asset catalog image.
    static var similarShoe3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .similarShoe3)
#else
        .init()
#endif
    }

    /// The "SimilarShoe4" asset catalog image.
    static var similarShoe4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .similarShoe4)
#else
        .init()
#endif
    }

    /// The "SimilarShoe5" asset catalog image.
    static var similarShoe5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .similarShoe5)
#else
        .init()
#endif
    }

    /// The "SimilarShoe6" asset catalog image.
    static var similarShoe6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .similarShoe6)
#else
        .init()
#endif
    }

    /// The "SimilarShoe7" asset catalog image.
    static var similarShoe7: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .similarShoe7)
#else
        .init()
#endif
    }

    /// The "SimilarShoe8" asset catalog image.
    static var similarShoe8: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .similarShoe8)
#else
        .init()
#endif
    }

    /// The "StarIcon" asset catalog image.
    static var starIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .starIcon)
#else
        .init()
#endif
    }

    /// The "TagIcon" asset catalog image.
    static var tagIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .tagIcon)
#else
        .init()
#endif
    }

    /// The "VerifyIcon" asset catalog image.
    static var verifyIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .verifyIcon)
#else
        .init()
#endif
    }

    /// The "VoiceIcon" asset catalog image.
    static var voiceIcon: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .voiceIcon)
#else
        .init()
#endif
    }

    /// The "WhiteShoe1" asset catalog image.
    static var whiteShoe1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .whiteShoe1)
#else
        .init()
#endif
    }

    /// The "WhiteShoe2" asset catalog image.
    static var whiteShoe2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .whiteShoe2)
#else
        .init()
#endif
    }

    /// The "WhiteShoe3" asset catalog image.
    static var whiteShoe3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .whiteShoe3)
#else
        .init()
#endif
    }

    /// The "WhiteShoe4" asset catalog image.
    static var whiteShoe4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .whiteShoe4)
#else
        .init()
#endif
    }

    /// The "WhiteShoe5" asset catalog image.
    static var whiteShoe5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .whiteShoe5)
#else
        .init()
#endif
    }

    /// The "WhiteShoe6" asset catalog image.
    static var whiteShoe6: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .whiteShoe6)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "APCPhoto" asset catalog image.
    static var apcPhoto: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .apcPhoto)
#else
        .init()
#endif
    }

    /// The "Avatar" asset catalog image.
    static var avatar: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .avatar)
#else
        .init()
#endif
    }

    /// The "BellIcon" asset catalog image.
    static var bellIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .bellIcon)
#else
        .init()
#endif
    }

    /// The "BlackShoe1" asset catalog image.
    static var blackShoe1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blackShoe1)
#else
        .init()
#endif
    }

    /// The "BlackShoe2" asset catalog image.
    static var blackShoe2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blackShoe2)
#else
        .init()
#endif
    }

    /// The "BlackShoe3" asset catalog image.
    static var blackShoe3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blackShoe3)
#else
        .init()
#endif
    }

    /// The "BlackShoe4" asset catalog image.
    static var blackShoe4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blackShoe4)
#else
        .init()
#endif
    }

    /// The "BlackShoe5" asset catalog image.
    static var blackShoe5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blackShoe5)
#else
        .init()
#endif
    }

    /// The "BlackShoe6" asset catalog image.
    static var blackShoe6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blackShoe6)
#else
        .init()
#endif
    }

    /// The "BlueShoe1" asset catalog image.
    static var blueShoe1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blueShoe1)
#else
        .init()
#endif
    }

    /// The "BlueShoe2" asset catalog image.
    static var blueShoe2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blueShoe2)
#else
        .init()
#endif
    }

    /// The "BlueShoe3" asset catalog image.
    static var blueShoe3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blueShoe3)
#else
        .init()
#endif
    }

    /// The "BlueShoe4" asset catalog image.
    static var blueShoe4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blueShoe4)
#else
        .init()
#endif
    }

    /// The "BlueShoe5" asset catalog image.
    static var blueShoe5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blueShoe5)
#else
        .init()
#endif
    }

    /// The "BlueShoe6" asset catalog image.
    static var blueShoe6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .blueShoe6)
#else
        .init()
#endif
    }

    /// The "BrownShoe1" asset catalog image.
    static var brownShoe1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brownShoe1)
#else
        .init()
#endif
    }

    /// The "BrownShoe2" asset catalog image.
    static var brownShoe2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brownShoe2)
#else
        .init()
#endif
    }

    /// The "BrownShoe3" asset catalog image.
    static var brownShoe3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brownShoe3)
#else
        .init()
#endif
    }

    /// The "BrownShoe4" asset catalog image.
    static var brownShoe4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brownShoe4)
#else
        .init()
#endif
    }

    /// The "BrownShoe5" asset catalog image.
    static var brownShoe5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brownShoe5)
#else
        .init()
#endif
    }

    /// The "BrownShoe6" asset catalog image.
    static var brownShoe6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .brownShoe6)
#else
        .init()
#endif
    }

    /// The "BurgundyProductBeanie" asset catalog image.
    static var burgundyProductBeanie: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .burgundyProductBeanie)
#else
        .init()
#endif
    }

    /// The "BurgundyProductHoodie" asset catalog image.
    static var burgundyProductHoodie: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .burgundyProductHoodie)
#else
        .init()
#endif
    }

    /// The "BurgundyProductMug" asset catalog image.
    static var burgundyProductMug: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .burgundyProductMug)
#else
        .init()
#endif
    }

    /// The "BurgundyProductShirt" asset catalog image.
    static var burgundyProductShirt: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .burgundyProductShirt)
#else
        .init()
#endif
    }

    /// The "BurgundyProductSocks" asset catalog image.
    static var burgundyProductSocks: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .burgundyProductSocks)
#else
        .init()
#endif
    }

    /// The "BurgundyProductVans" asset catalog image.
    static var burgundyProductVans: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .burgundyProductVans)
#else
        .init()
#endif
    }

    /// The "BuyAgainIcon" asset catalog image.
    static var buyAgainIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .buyAgainIcon)
#else
        .init()
#endif
    }

    /// The "CelebBadBunny" asset catalog image.
    static var celebBadBunny: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .celebBadBunny)
#else
        .init()
#endif
    }

    /// The "CelebJacob" asset catalog image.
    static var celebJacob: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .celebJacob)
#else
        .init()
#endif
    }

    /// The "CelebJonah" asset catalog image.
    static var celebJonah: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .celebJonah)
#else
        .init()
#endif
    }

    /// The "F1Albon" asset catalog image.
    static var f1Albon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .f1Albon)
#else
        .init()
#endif
    }

    /// The "F1Alonso" asset catalog image.
    static var f1Alonso: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .f1Alonso)
#else
        .init()
#endif
    }

    /// The "F1Gasly" asset catalog image.
    static var f1Gasly: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .f1Gasly)
#else
        .init()
#endif
    }

    /// The "F1Hamilton" asset catalog image.
    static var f1Hamilton: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .f1Hamilton)
#else
        .init()
#endif
    }

    /// The "F1Leclerc" asset catalog image.
    static var f1Leclerc: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .f1Leclerc)
#else
        .init()
#endif
    }

    /// The "F1LeclercBanner" asset catalog image.
    static var f1LeclercBanner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .f1LeclercBanner)
#else
        .init()
#endif
    }

    /// The "F1Norris" asset catalog image.
    static var f1Norris: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .f1Norris)
#else
        .init()
#endif
    }

    /// The "F1Verstappen" asset catalog image.
    static var f1Verstappen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .f1Verstappen)
#else
        .init()
#endif
    }

    /// The "GreenShoe1" asset catalog image.
    static var greenShoe1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .greenShoe1)
#else
        .init()
#endif
    }

    /// The "GreenShoe2" asset catalog image.
    static var greenShoe2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .greenShoe2)
#else
        .init()
#endif
    }

    /// The "GreenShoe3" asset catalog image.
    static var greenShoe3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .greenShoe3)
#else
        .init()
#endif
    }

    /// The "GreenShoe4" asset catalog image.
    static var greenShoe4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .greenShoe4)
#else
        .init()
#endif
    }

    /// The "GreenShoe5" asset catalog image.
    static var greenShoe5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .greenShoe5)
#else
        .init()
#endif
    }

    /// The "GreenShoe6" asset catalog image.
    static var greenShoe6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .greenShoe6)
#else
        .init()
#endif
    }

    /// The "HeartFilled" asset catalog image.
    static var heartFilled: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .heartFilled)
#else
        .init()
#endif
    }

    /// The "HeartIcon" asset catalog image.
    static var heartIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .heartIcon)
#else
        .init()
#endif
    }

    /// The "HeartOutlineIcon" asset catalog image.
    static var heartOutlineIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .heartOutlineIcon)
#else
        .init()
#endif
    }

    /// The "HomeIcon" asset catalog image.
    static var homeIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .homeIcon)
#else
        .init()
#endif
    }

    /// The "LogoCaraway" asset catalog image.
    static var logoCaraway: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoCaraway)
#else
        .init()
#endif
    }

    /// The "LogoCeremonia" asset catalog image.
    static var logoCeremonia: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoCeremonia)
#else
        .init()
#endif
    }

    /// The "LogoHasbro" asset catalog image.
    static var logoHasbro: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoHasbro)
#else
        .init()
#endif
    }

    /// The "LogoKith" asset catalog image.
    static var logoKith: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoKith)
#else
        .init()
#endif
    }

    /// The "LogoMoscot" asset catalog image.
    static var logoMoscot: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoMoscot)
#else
        .init()
#endif
    }

    /// The "LogoNike" asset catalog image.
    static var logoNike: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoNike)
#else
        .init()
#endif
    }

    /// The "LogoNoguchi" asset catalog image.
    static var logoNoguchi: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoNoguchi)
#else
        .init()
#endif
    }

    /// The "LogoOwala" asset catalog image.
    static var logoOwala: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoOwala)
#else
        .init()
#endif
    }

    /// The "LogoReebok" asset catalog image.
    static var logoReebok: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoReebok)
#else
        .init()
#endif
    }

    /// The "LogoTekla" asset catalog image.
    static var logoTekla: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoTekla)
#else
        .init()
#endif
    }

    /// The "LogoVacation" asset catalog image.
    static var logoVacation: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .logoVacation)
#else
        .init()
#endif
    }

    /// The "MartyCoat" asset catalog image.
    static var martyCoat: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .martyCoat)
#else
        .init()
#endif
    }

    /// The "MartyGlasses" asset catalog image.
    static var martyGlasses: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .martyGlasses)
#else
        .init()
#endif
    }

    /// The "MartyGloves" asset catalog image.
    static var martyGloves: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .martyGloves)
#else
        .init()
#endif
    }

    /// The "MartySupreme" asset catalog image.
    static var martySupreme: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .martySupreme)
#else
        .init()
#endif
    }

    /// The "MartyTie" asset catalog image.
    static var martyTie: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .martyTie)
#else
        .init()
#endif
    }

    /// The "OrdersIcon" asset catalog image.
    static var ordersIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .ordersIcon)
#else
        .init()
#endif
    }

    /// The "PileBeanie" asset catalog image.
    static var pileBeanie: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileBeanie)
#else
        .init()
#endif
    }

    /// The "PileLantern" asset catalog image.
    static var pileLantern: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileLantern)
#else
        .init()
#endif
    }

    /// The "PileMatchaTin" asset catalog image.
    static var pileMatchaTin: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileMatchaTin)
#else
        .init()
#endif
    }

    /// The "PileNike" asset catalog image.
    static var pileNike: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileNike)
#else
        .init()
#endif
    }

    /// The "PilePerfume" asset catalog image.
    static var pilePerfume: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pilePerfume)
#else
        .init()
#endif
    }

    /// The "PileReebok" asset catalog image.
    static var pileReebok: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileReebok)
#else
        .init()
#endif
    }

    /// The "PileSaucepan" asset catalog image.
    static var pileSaucepan: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileSaucepan)
#else
        .init()
#endif
    }

    /// The "PileSlippers" asset catalog image.
    static var pileSlippers: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileSlippers)
#else
        .init()
#endif
    }

    /// The "PileSunglasses" asset catalog image.
    static var pileSunglasses: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileSunglasses)
#else
        .init()
#endif
    }

    /// The "PileSunscreen" asset catalog image.
    static var pileSunscreen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileSunscreen)
#else
        .init()
#endif
    }

    /// The "PileTray" asset catalog image.
    static var pileTray: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileTray)
#else
        .init()
#endif
    }

    /// The "PileWaterBottle" asset catalog image.
    static var pileWaterBottle: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileWaterBottle)
#else
        .init()
#endif
    }

    /// The "PileWolverine" asset catalog image.
    static var pileWolverine: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileWolverine)
#else
        .init()
#endif
    }

    /// The "PileYankeesCap" asset catalog image.
    static var pileYankeesCap: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pileYankeesCap)
#else
        .init()
#endif
    }

    /// The "PlusIcon" asset catalog image.
    static var plusIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .plusIcon)
#else
        .init()
#endif
    }

    /// The "PocketShoe1" asset catalog image.
    static var pocketShoe1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pocketShoe1)
#else
        .init()
#endif
    }

    /// The "PocketShoe2" asset catalog image.
    static var pocketShoe2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pocketShoe2)
#else
        .init()
#endif
    }

    /// The "PocketShoe3" asset catalog image.
    static var pocketShoe3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pocketShoe3)
#else
        .init()
#endif
    }

    /// The "PocketShoe4" asset catalog image.
    static var pocketShoe4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pocketShoe4)
#else
        .init()
#endif
    }

    /// The "PocketShoe5" asset catalog image.
    static var pocketShoe5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pocketShoe5)
#else
        .init()
#endif
    }

    /// The "PortraitDion" asset catalog image.
    static var portraitDion: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .portraitDion)
#else
        .init()
#endif
    }

    /// The "PortraitLady" asset catalog image.
    static var portraitLady: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .portraitLady)
#else
        .init()
#endif
    }

    /// The "PortraitMarty" asset catalog image.
    static var portraitMarty: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .portraitMarty)
#else
        .init()
#endif
    }

    /// The "PortraitOldGuy" asset catalog image.
    static var portraitOldGuy: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .portraitOldGuy)
#else
        .init()
#endif
    }

    /// The "PortraitWally" asset catalog image.
    static var portraitWally: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .portraitWally)
#else
        .init()
#endif
    }

    /// The "PriceCaraway" asset catalog image.
    static var priceCaraway: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priceCaraway)
#else
        .init()
#endif
    }

    /// The "PriceCheckLogo" asset catalog image.
    static var priceCheckLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priceCheckLogo)
#else
        .init()
#endif
    }

    /// The "PriceErrorsCap" asset catalog image.
    static var priceErrorsCap: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priceErrorsCap)
#else
        .init()
#endif
    }

    /// The "PriceErrorsFleece" asset catalog image.
    static var priceErrorsFleece: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priceErrorsFleece)
#else
        .init()
#endif
    }

    /// The "PriceFrostedFlakes" asset catalog image.
    static var priceFrostedFlakes: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priceFrostedFlakes)
#else
        .init()
#endif
    }

    /// The "PriceJordan" asset catalog image.
    static var priceJordan: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priceJordan)
#else
        .init()
#endif
    }

    /// The "PriceLamp" asset catalog image.
    static var priceLamp: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priceLamp)
#else
        .init()
#endif
    }

    /// The "PriceMetsCap" asset catalog image.
    static var priceMetsCap: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .priceMetsCap)
#else
        .init()
#endif
    }

    /// The "ScratchAPCHero" asset catalog image.
    static var scratchAPCHero: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .scratchAPCHero)
#else
        .init()
#endif
    }

    /// The "ScratchAPCLogo" asset catalog image.
    static var scratchAPCLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .scratchAPCLogo)
#else
        .init()
#endif
    }

    /// The "ScratchAPCProduct1" asset catalog image.
    static var scratchAPCProduct1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .scratchAPCProduct1)
#else
        .init()
#endif
    }

    /// The "ScratchAPCProduct2" asset catalog image.
    static var scratchAPCProduct2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .scratchAPCProduct2)
#else
        .init()
#endif
    }

    /// The "ScratchAPCProduct3" asset catalog image.
    static var scratchAPCProduct3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .scratchAPCProduct3)
#else
        .init()
#endif
    }

    /// The "ScratchAPCProduct4" asset catalog image.
    static var scratchAPCProduct4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .scratchAPCProduct4)
#else
        .init()
#endif
    }

    /// The "SearchIcon" asset catalog image.
    static var searchIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .searchIcon)
#else
        .init()
#endif
    }

    /// The "ShoeSwipeBlack" asset catalog image.
    static var shoeSwipeBlack: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shoeSwipeBlack)
#else
        .init()
#endif
    }

    /// The "ShoeSwipeGreen" asset catalog image.
    static var shoeSwipeGreen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shoeSwipeGreen)
#else
        .init()
#endif
    }

    /// The "ShoeSwipeKithLogo" asset catalog image.
    static var shoeSwipeKithLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shoeSwipeKithLogo)
#else
        .init()
#endif
    }

    /// The "ShoeSwipeWhiteRed" asset catalog image.
    static var shoeSwipeWhiteRed: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shoeSwipeWhiteRed)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar01" asset catalog image.
    static var shopLookAvatar01: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar01)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar02" asset catalog image.
    static var shopLookAvatar02: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar02)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar03" asset catalog image.
    static var shopLookAvatar03: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar03)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar04" asset catalog image.
    static var shopLookAvatar04: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar04)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar05" asset catalog image.
    static var shopLookAvatar05: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar05)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar06" asset catalog image.
    static var shopLookAvatar06: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar06)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar07" asset catalog image.
    static var shopLookAvatar07: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar07)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar08" asset catalog image.
    static var shopLookAvatar08: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar08)
#else
        .init()
#endif
    }

    /// The "ShopLookAvatar09" asset catalog image.
    static var shopLookAvatar09: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopLookAvatar09)
#else
        .init()
#endif
    }

    /// The "ShopPromise" asset catalog image.
    static var shopPromise: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopPromise)
#else
        .init()
#endif
    }

    /// The "ShopTheLookPerson" asset catalog image.
    static var shopTheLookPerson: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .shopTheLookPerson)
#else
        .init()
#endif
    }

    /// The "SilverShoe1" asset catalog image.
    static var silverShoe1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .silverShoe1)
#else
        .init()
#endif
    }

    /// The "SilverShoe2" asset catalog image.
    static var silverShoe2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .silverShoe2)
#else
        .init()
#endif
    }

    /// The "SilverShoe3" asset catalog image.
    static var silverShoe3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .silverShoe3)
#else
        .init()
#endif
    }

    /// The "SilverShoe4" asset catalog image.
    static var silverShoe4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .silverShoe4)
#else
        .init()
#endif
    }

    /// The "SilverShoe5" asset catalog image.
    static var silverShoe5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .silverShoe5)
#else
        .init()
#endif
    }

    /// The "SilverShoe6" asset catalog image.
    static var silverShoe6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .silverShoe6)
#else
        .init()
#endif
    }

    /// The "SimilarShoe1" asset catalog image.
    static var similarShoe1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .similarShoe1)
#else
        .init()
#endif
    }

    /// The "SimilarShoe2" asset catalog image.
    static var similarShoe2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .similarShoe2)
#else
        .init()
#endif
    }

    /// The "SimilarShoe3" asset catalog image.
    static var similarShoe3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .similarShoe3)
#else
        .init()
#endif
    }

    /// The "SimilarShoe4" asset catalog image.
    static var similarShoe4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .similarShoe4)
#else
        .init()
#endif
    }

    /// The "SimilarShoe5" asset catalog image.
    static var similarShoe5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .similarShoe5)
#else
        .init()
#endif
    }

    /// The "SimilarShoe6" asset catalog image.
    static var similarShoe6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .similarShoe6)
#else
        .init()
#endif
    }

    /// The "SimilarShoe7" asset catalog image.
    static var similarShoe7: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .similarShoe7)
#else
        .init()
#endif
    }

    /// The "SimilarShoe8" asset catalog image.
    static var similarShoe8: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .similarShoe8)
#else
        .init()
#endif
    }

    /// The "StarIcon" asset catalog image.
    static var starIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .starIcon)
#else
        .init()
#endif
    }

    /// The "TagIcon" asset catalog image.
    static var tagIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .tagIcon)
#else
        .init()
#endif
    }

    /// The "VerifyIcon" asset catalog image.
    static var verifyIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .verifyIcon)
#else
        .init()
#endif
    }

    /// The "VoiceIcon" asset catalog image.
    static var voiceIcon: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .voiceIcon)
#else
        .init()
#endif
    }

    /// The "WhiteShoe1" asset catalog image.
    static var whiteShoe1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .whiteShoe1)
#else
        .init()
#endif
    }

    /// The "WhiteShoe2" asset catalog image.
    static var whiteShoe2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .whiteShoe2)
#else
        .init()
#endif
    }

    /// The "WhiteShoe3" asset catalog image.
    static var whiteShoe3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .whiteShoe3)
#else
        .init()
#endif
    }

    /// The "WhiteShoe4" asset catalog image.
    static var whiteShoe4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .whiteShoe4)
#else
        .init()
#endif
    }

    /// The "WhiteShoe5" asset catalog image.
    static var whiteShoe5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .whiteShoe5)
#else
        .init()
#endif
    }

    /// The "WhiteShoe6" asset catalog image.
    static var whiteShoe6: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .whiteShoe6)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ColorResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: DeveloperToolsSupport.ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@available(watchOS, unavailable)
extension DeveloperToolsSupport.ImageResource {

    private init?(thinnableName: Swift.String, bundle: Foundation.Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 14.0, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: DeveloperToolsSupport.ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

