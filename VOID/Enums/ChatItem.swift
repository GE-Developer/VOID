//
//  ChatItem.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

enum ChatItem: Identifiable, Equatable {
    case text(Message)
    case file(FileMessage)

    var id: UUID {
        switch self {
        case .text(let message):
            return message.id
        case .file(let message):
            return message.id
        }
    }

    var encryptionMode: CryptoAction {
        switch self {
        case .text(let message):
            return message.encryptionMode
        case .file(let message):
            return message.encryptionMode
        }
    }
}
