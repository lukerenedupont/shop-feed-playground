//
//  AppChromeState.swift
//  Shop feed playground
//

import SwiftUI
import Combine

@MainActor
final class AppChromeState: ObservableObject {
    @Published var hideGlobalFeedChrome: Bool = false
}
