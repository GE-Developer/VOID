//
//  FileMessage.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

struct FileMessage: Identifiable, Equatable {
    let id = UUID()
    let originalFileName: String
    let fileSize: UInt64
    let fileURL: URL
    let encryptionMode: CryptoAction
}
