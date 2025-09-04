//
//  LanguageViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

@MainActor
final class LanguageViewModel: ObservableObject {
    
    @Published var tappedLanguage: Language?
    
    var title: String {
        L10n("Settings.General.Language.title")
    }
    
    var alertTitle: String {
        L10n("Settings.General.Language.alertTitle")
    }
    
    var alertMessage: String {
        L10n("Settings.General.Language.alertMessage")
    }
    
    var alertActionTitle: String {
        L10n("Settings.General.Language.alertActionTitle")
    }
    
    var alertCancelTitle: String {
        L10n("Settings.General.Language.alertCancelTitle")
    }
    
    private let languageManager = LanguageManager.shared
    
    init() {
        tappedLanguage = Language(rawValue: languageManager.currentLanguageID)
    }
    
    func isWithCheckmark(_ language: Language) -> Bool {
        language.id == languageManager.currentLanguageID
    }
    
    func setNewLanguage() {
        languageManager.currentLanguageID = tappedLanguage?.id ?? Language.english.id
    }
}
