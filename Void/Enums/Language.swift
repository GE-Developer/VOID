//
//  Language.swift
//  Void
//
//  Created by GE-Developer
//

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    case chineseSimplified = "zh-Hans"
    case chineseTraditional = "zh-Hant"
    case hindi = "hi"
//    case arabic = "ar" // RTL
    case french = "fr"
    case russian = "ru"
    case portuguese = "pt"
    case japanese = "ja"
    case german = "de"
    case korean = "ko"
    case vietnamese = "vi"
    case turkish = "tr"
    case italian = "it"
//    case urdu = "ur" // RTL
    case dutch = "nl"
    case swedish = "sv"
    case ukrainian = "uk"
    case georgian = "ka"
//    case persian = "fa" // RTL
    
    var id: String { rawValue }
    
    var localizedName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Español"
        case .chineseSimplified: return "简体中文"
        case .chineseTraditional: return "繁體中文"
        case .hindi: return "हिन्दी"
//        case .arabic: return "العربية"
        case .french: return "Français"
        case .russian: return "Русский"
        case .portuguese: return "Português"
        case .japanese: return "日本語"
        case .german: return "Deutsch"
        case .korean: return "한국어"
        case .vietnamese: return "Tiếng Việt"
        case .turkish: return "Türkçe"
        case .italian: return "Italiano"
//        case .urdu: return "اردو"
        case .dutch: return "Nederlands"
        case .swedish: return "Svenska"
        case .ukrainian: return "Українська"
        case .georgian: return "ქართული"
//        case .persian: return "فارسی"
        }
    }
    
    var englishName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        case .chineseSimplified: return "Chinese (Simplified)"
        case .chineseTraditional: return "Chinese (Traditional)"
        case .hindi: return "Hindi"
//        case .arabic: return "Arabic"
        case .french: return "French"
        case .russian: return "Russian"
        case .portuguese: return "Portuguese"
        case .japanese: return "Japanese"
        case .german: return "German"
        case .korean: return "Korean"
        case .vietnamese: return "Vietnamese"
        case .turkish: return "Turkish"
        case .italian: return "Italian"
//        case .urdu: return "Urdu"
        case .dutch: return "Dutch"
        case .swedish: return "Swedish"
        case .ukrainian: return "Ukrainian"
        case .georgian: return "Georgian"
//        case .persian: return "Persian"
        }
    }
}
