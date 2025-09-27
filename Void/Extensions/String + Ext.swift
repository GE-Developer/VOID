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

public func L10n(_ key: String.LocalizationValue) -> String {
    String(localized: key, bundle: LanguageManager.shared.bundle)
}
