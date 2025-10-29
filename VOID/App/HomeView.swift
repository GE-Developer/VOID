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
        .environmentObject(tabBarState)
        .environmentObject(store)
    }
}
