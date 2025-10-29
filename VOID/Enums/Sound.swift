//
//  Sound.swift
//  VOID
//
//  Created by GE-Developer
//

enum Sound {
    case devMode
    case newEncryptedMessage
    case newDecryptedMessage
    case errorAlert
    
    var name: String {
        switch self {
        case .devMode: return "Dev_Mode"
        case .newEncryptedMessage: return "New_Encrypted_Message"
        case .newDecryptedMessage: return "New_Decrypted_Message"
        case .errorAlert: return "Error_Alert"
        }
    }
}
