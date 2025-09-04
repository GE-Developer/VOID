//
//  VoidApp.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 26.07.25.
//

import SwiftUI

@main
struct VoidApp: App {
    private let themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .preferredColorScheme(themeManager.isThemeLight ? .light : .dark)
            }
        }
    }
}

@MainActor
public func L10n(_ key: String.LocalizationValue) -> String {
    let languageBundle = LanguageManager.shared.bundle
    return String(localized: key, bundle: languageBundle)
}
