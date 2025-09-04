//
//  ThemeManager.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

@MainActor
@Observable
final class ThemeManager {
    
    var isThemeLight: Bool {
        didSet { defaults.set(isThemeLight, forKey: key) }
    }
    
    static let shared = ThemeManager()
    
    private let defaults = UserDefaults.standard
    private let key = AppStorageKey.theme.key
    
    private init() {
        isThemeLight = defaults.bool(forKey: key)
    }
}
