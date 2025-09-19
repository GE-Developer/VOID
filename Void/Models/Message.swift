//
//  Message.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let timestamp: Date
    let originalText: String
    let encryptedText: String
    let encryptionMode: CryptoAction
}
