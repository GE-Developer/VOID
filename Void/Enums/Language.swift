//
//  Language.swift
//  Void
//
//  Created by GE-Developer
//

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case russian = "ru"
    case ukrainian = "uk"
//    case georgian = "ka"
//    case german = "de"
//    case french = "fr"
//    case spanish = "es"
//    case italian = "it"
//    case portuguese = "pt"
//    case polish = "pl"
//    case turkish = "tr"
    case japanese = "ja"
//    case korean = "ko"
//    case chineseSimplified = "zh-Hans"
//    case chineseTraditional = "zh-Hant"
    
    var id: String { rawValue }
    
    var localizedName: String {
        switch self {
        case .english: return "English"
        case .russian: return "Русский"
        case .ukrainian: return "Українська"
//        case .georgian: return "ქართული"
//        case .german: return "Deutsch"
//        case .french: return "Français"
//        case .spanish: return "Español"
//        case .italian: return "Italiano"
//        case .portuguese: return "Português"
//        case .polish: return "Polski"
//        case .turkish: return "Türkçe"
        case .japanese: return "日本語"
//        case .korean: return "한국어"
//        case .chineseSimplified: return "简体中文"
//        case .chineseTraditional: return "繁體中文"
        }
    }
    
    var englishName: String {
        switch self {
        case .english: return "Base"
        case .russian: return "Russian"
        case .ukrainian: return "Ukrainian"
//        case .georgian: return "Georgian"
//        case .german: return "German"
//        case .french: return "French"
//        case .spanish: return "Spanish"
//        case .italian: return "Italian"
//        case .portuguese: return "Portuguese"
//        case .polish: return "Polish"
//        case .turkish: return "Turkish"
        case .japanese: return "Japanese"
//        case .korean: return "Korean"
//        case .chineseSimplified: return "Chinese (Simplified)"
//        case .chineseTraditional: return "Chinese (Traditional)"
        }
    }
}
