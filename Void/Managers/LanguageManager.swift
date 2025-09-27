//
//  LanguageManager.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

@MainActor
@Observable
final class LanguageManager {
    
    var currentLanguageID: String {
        didSet {
            defaults.set([currentLanguageID], forKey: key)
            defaults.synchronize()
        }
    }
    
    static let shared = LanguageManager()
    
    private let defaults = UserDefaults.standard
    private let key = AppStorageKey.language.key
    
    private init() {
        let baseAppLanguage = Bundle.main.developmentLocalization ?? Language.english.id
        let baseUserLanguage = Bundle.main.preferredLocalizations.first
        
        currentLanguageID = baseUserLanguage ?? baseAppLanguage
    }
}
