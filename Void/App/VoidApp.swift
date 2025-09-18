//
//  VoidApp.swift
//  Void
//
//  Created by GE-Developer on 26.07.25.
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
