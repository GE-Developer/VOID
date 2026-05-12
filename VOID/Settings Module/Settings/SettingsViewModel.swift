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
    
    @Published private(set) var storageSize: String = ""
    
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
    
    var storageTitle: String {
        L10n("Settings.Storage.title")
    }
    
    var clearDataTitle: String {
        L10n("Settings.Storage.ClearData.title")
    }
    
    var clearDataAlertTitle: String {
        L10n("Settings.Storage.ClearData.alertTitle")
    }
    
    var clearDataAlertMessage: String {
        L10n("Settings.Storage.ClearData.alertMessage")
    }
    
    var clearDataAlertActionTitle: String {
        L10n("Settings.Storage.ClearData.alertActionTitle")
    }
    
    var alertCancelTitle: String {
        L10n("Alert.cancel")
    }
    
    var resetSettingsTitle: String {
        L10n("Settings.Storage.ResetSettings.title")
    }
    
    var resetSettingsAlertTitle: String {
        L10n("Settings.Storage.ResetSettings.alertTitle")
    }
    
    var resetSettingsAlertMessage: String {
        L10n("Settings.Storage.ResetSettings.alertMessage")
    }
    
    var resetSettingsAlertActionTitle: String {
        L10n("Settings.Storage.ResetSettings.alertActionTitle")
    }
    
    private var storageDirectories: [URL] {
        let fm = FileManager.default
        return [
            fm.temporaryDirectory,
            fm.urls(for: .cachesDirectory, in: .userDomainMask).first,
            fm.urls(for: .documentDirectory, in: .userDomainMask).first
        ].compactMap { $0 }
    }
    
    let languageSubtitle = "Language"
    
    private let themeManager = ThemeManager.shared
    private let languageManager = LanguageManager.shared
    private let hapticsManager = HapticsManager.shared
    private let soundManager = SoundManager.shared
    private let screenshotProtector = ScreenshotManager.shared
    private let accentColorManager = AccentColorManager.shared
    
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        formatter.allowsNonnumericFormatting = false
        return formatter
    }()
    
    init() {
        isDarkMode = themeManager.isDarkMode
        isHapticsOn = hapticsManager.isHapticsOn
        isSoundOn = soundManager.isSoundOn
        isScreenshotProtectionOn = screenshotProtector.isScreenshotProtectionOn
        refreshStorageSize()
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
    
    func clearStorage() {
        let fm = FileManager.default
        
        for dir in storageDirectories {
            guard let contents = try? fm.contentsOfDirectory(
                at: dir,
                includingPropertiesForKeys: nil
            ) else { continue }
            
            for item in contents {
                try? fm.removeItem(at: item)
            }
        }
        
        hapticsManager.notification(type: .success)
        soundManager.playSound(.newDecryptedMessage)
        refreshStorageSize()
    }
    
    @MainActor
    func resetUserDefaults(store: StoreManager) {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        themeManager.reset()
        hapticsManager.reset()
        soundManager.reset()
        languageManager.reset()
        screenshotProtector.reset()
        accentColorManager.reset()
        store.devTest = false
        UserDefaults.standard.set(false, forKey: AppStorageKey.devTest.key)
        
        Task { try? await AppIconManager.reset() }
        
        isDarkMode = themeManager.isDarkMode
        isHapticsOn = hapticsManager.isHapticsOn
        isSoundOn = soundManager.isSoundOn
        isScreenshotProtectionOn = screenshotProtector.isScreenshotProtectionOn
        hapticsManager.notification(type: .success)
        soundManager.playSound(.newDecryptedMessage)
    }
    
    func refreshStorageSize() {
        let bytes = totalStorageBytes()
        storageSize = byteFormatter.string(fromByteCount: bytes)
    }
    
    private func totalStorageBytes() -> Int64 {
        let fm = FileManager.default
        let keys: [URLResourceKey] = [.totalFileAllocatedSizeKey, .isRegularFileKey]
        var total: Int64 = 0
        
        for dir in storageDirectories {
            guard let enumerator = fm.enumerator(
                at: dir,
                includingPropertiesForKeys: keys
            ) else { continue }
            
            for case let fileURL as URL in enumerator {
                guard
                    let values = try? fileURL.resourceValues(forKeys: Set(keys)),
                    values.isRegularFile == true,
                    let size = values.totalFileAllocatedSize
                else { continue }
                total += Int64(size)
            }
        }
        
        return total
    }
}
