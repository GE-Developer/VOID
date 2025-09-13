//
//  String + Ext.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

extension String {
    var asMarkdown: AttributedString {
        (try? AttributedString(markdown: self)) ?? AttributedString(self)
    }
}

@MainActor
public func L10n(_ key: String.LocalizationValue) -> String {
    let languageBundle = LanguageManager.shared.bundle
    return String(localized: key, bundle: languageBundle)
}
