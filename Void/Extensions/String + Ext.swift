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
    let defaults = UserDefaults.standard
    let languageArray = defaults.array(forKey: AppStorageKey.language.key) as? [String]
    let languageID = languageArray?.first
        ?? Bundle.main.preferredLocalizations.first
        ?? Bundle.main.developmentLocalization
        ?? "en"

    let bundle: Bundle
    if let path = Bundle.main.path(forResource: languageID, ofType: "lproj"),
       let langBundle = Bundle(path: path) {
        bundle = langBundle
    } else {
        bundle = .main
    }

    return String(localized: key, bundle: bundle)
}
