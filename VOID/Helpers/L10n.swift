//
//  L10n.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

public func L10n(_ key: String.LocalizationValue) -> String {
    String(localized: key, bundle: LanguageManager.shared.bundle)
}
