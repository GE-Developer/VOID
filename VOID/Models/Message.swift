//
//  Message.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID()
    let plainText: String
    let resultText: String
    let encryptionMode: CryptoAction
}
