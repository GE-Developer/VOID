//
//  HomeView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct HomeView: View {
    @StateObject private var tabBarState = TabBarState()
    @StateObject private var store = StoreManager()
    
    private let accent = AccentColorManager.shared
    
    var body: some View {
        Group {
            switch tabBarState.selectedTab {
            case .cryptography:
                NavigationStack {
                    CryptographyView()
                }
            case .settings:
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBar()
        }
        .task { setAccentColorIfPremiumExpired() }
        .environmentObject(tabBarState)
        .environmentObject(store)
    }
    
    private func setAccentColorIfPremiumExpired() {
        if !store.isPremium && accent.currentColor != .midnightBlue {
            accent.currentColor = .midnightBlue
        }
    }
}
