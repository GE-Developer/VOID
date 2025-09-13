//
//  SettingsViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var isThemeLight: Bool {
        didSet { themeManager.isThemeLight = isThemeLight }
    }
    
    @Published var isHapticsOff: Bool {
        didSet { hapticsManager.isHapticsOff = isHapticsOff }
    }
    
    @Published var isSoundOff: Bool {
        didSet { soundManager.isSoundOff = isSoundOff }
    }
    
    var title: String {
        L10n("Settings.title")
    }
    
    var generalSettingsTitle: String {
        L10n("Settings.General.title")
    }
    var darkModeTitle: String {
        L10n("Settings.General.DarkMode.title")
    }
    
    var languageTitle: String {
        L10n("Settings.General.Language.title")
    }
    
    var language: String {
        Language(rawValue: languageManager.currentLanguageID)?.localizedName ?? ""
    }
    
    var hapticsTitle: String {
        L10n("Settings.General.Haptics.title")
    }
    
    var soundTitle: String {
        L10n("Settings.General.Sound.title")
    }
    
    var accessTitle: String {
        L10n("Settings.Access.title")
    }
    
    var subscriptionTitle: String {
        L10n("Settings.Access.Subscription.title")
    }
    
    var restorePurchasesTitle: String {
        L10n("Settings.Access.RestorePurchases.title")
    }
    
    var reviewTitle: String {
        L10n("Settings.Access.Review.title")
    }
    
    var aboutAppTitle: String {
        L10n("Settings.AboutApp.title")
    }
    var termsOfUseTitle: String {
        L10n("Settings.AboutApp.TermsOfUse.title")
    }
    
    var privacyPolicyTitle: String {
        L10n("Settings.AboutApp.PrivacyPolicy.title")
    }
    
    var projectTitle: String {
        L10n("Settings.AboutApp.Project.title")
    }
    
    var appVersionTitle: String {
        L10n("Settings.AppVersion.title")
    }
    
    let appVersion: String
    let languageSubtitle = "Language"
    
    private let themeManager = ThemeManager.shared
    private let languageManager = LanguageManager.shared
    private let hapticsManager = HapticsManager.shared
    private let soundManager = SoundManager.shared
    
    init() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
        
        isThemeLight = themeManager.isThemeLight
        isHapticsOff = hapticsManager.isHapticsOff
        isSoundOff = soundManager.isSoundOff
        appVersion = "\(version) (\(build))"
    }
}
