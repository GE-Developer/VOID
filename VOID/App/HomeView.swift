//
//  HomeView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct HomeView: View {
    @State private var tabBarState = TabBarState()
    @StateObject private var store = StoreManager()
    
    @State private var languageManager = LanguageManager.shared
    
    private var layoutDirection: LayoutDirection {
        let rtlLanguages = Language.rtlLanguages
        return rtlLanguages.contains(languageManager.currentLanguageID) ? .rightToLeft : .leftToRight
    }
    
    private let accent = AccentColorManager.shared
    private let screenshotProtector = ScreenshotManager.shared
    
    var body: some View {
        @Bindable var tabBarState = tabBarState
        TabView(selection: $tabBarState.selectedTab) {
            NavigationStack {
                CryptographyView()
            }
            .environment(\.parentTab, .cryptography)
            .toolbar(.hidden, for: .tabBar)
            .tag(TabBarState.RootTab.cryptography)
            
            NavigationStack {
                SettingsView()
            }
            .environment(\.parentTab, .settings)
            .toolbar(.hidden, for: .tabBar)
            .tag(TabBarState.RootTab.settings)
        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBar()
        }
        .task { setAccentColorIfPremiumExpired() }
        .task { await setIconIfPremiumExpired() }
        .task { setCaptureProtectionIfPremiumExpired() }
        .environment(\.layoutDirection, layoutDirection)
        .preferredColorScheme(ThemeManager.shared.theme)
        .screenshotDisabled(screenshotProtector.isScreenshotProtectionOn)
        .environment(tabBarState)
        .environment(languageManager)
        .environmentObject(store)
    }
    
    private func setAccentColorIfPremiumExpired() {
        guard !store.isPremium else { return }
        if accent.currentColor != .midnightBlue {
            accent.currentColor = .midnightBlue
        }
    }
    
    private func setIconIfPremiumExpired() async {
        guard !store.isPremium else { return }
        if AppIconManager.currentIcon() != .blackVoid {
            do {
                try await Task.sleep(for: .milliseconds(600))
                try await AppIconManager.setIcon(.blackVoid)
            } catch {
                return
            }
        }
    }
    
    private func setCaptureProtectionIfPremiumExpired() {
        guard !store.isPremium else { return }
        if screenshotProtector.isScreenshotProtectionOn {
            screenshotProtector.isScreenshotProtectionOn = false
        }
    }
}
