//
//  Message.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Date
    let plainText: String
    let resultText: String
    let encryptionMode: CryptoAction
}
