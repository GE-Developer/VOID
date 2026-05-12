//
//  VOIDApp.swift
//  VOID
//
//  Created by GE-Developer on 26.07.25.
//

import SwiftUI

@main
struct VOIDApp: App {    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(ThemeManager.shared.theme)
        }
    }
}
