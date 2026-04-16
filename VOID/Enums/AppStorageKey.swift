//
//  AppStorageKey.swift
//  VOID
//
//  Created by GE-Developer
//

enum AppStorageKey {
    case theme
    case haptics
    case language
    case sound
    case devTest
    
    var key: String {
        switch self {
        case .theme: return "isDarkMode"
        case .haptics: return "isHapticsOn"
        case .language: return "AppleLanguages"
        case .sound: return "isSoundOn"
        case .devTest: return "devTest"
        }
    }
}
