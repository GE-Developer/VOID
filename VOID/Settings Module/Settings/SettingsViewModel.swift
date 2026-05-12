//
//  SettingsViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet { themeManager.isDarkMode = isDarkMode }
    }

    @Published var isHapticsOn: Bool {
        didSet { hapticsManager.isHapticsOn = isHapticsOn }
    }

    @Published var isSoundOn: Bool {
        didSet { soundManager.isSoundOn = isSoundOn }
    }
    
    @Published var isScreenshotProtectionOn: Bool {
        didSet { screenshotProtector.isScreenshotProtectionOn = isScreenshotProtectionOn }
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
    
    var reviewTitle: String {
        L10n("Settings.Access.Review.title")
    }
    
    var safetyTitle: String {
        L10n("Settings.Safety.title")
    }
    
    var screenshotProtectionTitle: String {
        L10n("Settings.Safety.ScreenshotProtection.title")
    }
    
    var customizationTitle: String {
        L10n("Settings.Customization.title")
    }
    
    var styleTitle: String {
        L10n("Settings.Customization.Style.title")
    }
    
    var appIconTitle: String {
        L10n("Settings.Customization.AppIcon.title")
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
    
    let languageSubtitle = "Language"
    
    private let themeManager = ThemeManager.shared
    private let languageManager = LanguageManager.shared
    private let hapticsManager = HapticsManager.shared
    private let soundManager = SoundManager.shared
    private let screenshotProtector = ScreenshotManager.shared
    
    init() {
        isDarkMode = themeManager.isDarkMode
        isHapticsOn = hapticsManager.isHapticsOn
        isSoundOn = soundManager.isSoundOn
        isScreenshotProtectionOn = screenshotProtector.isScreenshotProtectionOn
    }
    
    func rateApp() {
        guard let url = URL(
            string: "https://apps.apple.com/app/\(Plist.get(.appID))?action=write-review"
        ) else { return }
        UIApplication.shared.open(url)
    }
    
    func showPrivacyPolicy() {
        guard let url = URL(string: Plist.get(.privacyPolicy)) else { return }
        UIApplication.shared.open(url)
    }
    
    func showTermsOfUse() {
        guard let url = URL(string: Plist.get(.termsOfUse)) else { return }
        UIApplication.shared.open(url)
    }
}
