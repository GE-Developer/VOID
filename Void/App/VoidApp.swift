//
//  VoidApp.swift
//  Void
//
//  Created by GE-Developer on 26.07.25.
//

import SwiftUI

@main
struct VoidApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .preferredColorScheme(ThemeManager.shared.theme)
            }
        }
    }
}
