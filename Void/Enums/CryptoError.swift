//
//  CryptoError.swift
//  Void
//
//  Created by GE-Developer
//

enum CryptoError: Error {
    // Key derivation
    case saltGenerationFailed
    case invalidMasterKey
    case invalidSubkeyCount
    case argon2Failed

    // AES encryption/decryption
    case nonceGenerationFailed
    case invalidFormat
    case expired
    case encryptionFailed
    case decryptionFailed
    case integrityCheckFailed

    // General / fallback
    case invalidInputData
    case unknown
    
    var errorTitle: String { L10n("Error.title") }

    var errorDescription: String {
        switch self {
        case .saltGenerationFailed:
            return L10n("Error.saltGenerationFailed")
        case .invalidMasterKey:
            return L10n("Master key is empty or corrupted.")
        case .invalidSubkeyCount:
            return L10n("Error.invalidSubkeyCount")
        case .argon2Failed:
            return L10n("Error.argon2Failed")
        case .nonceGenerationFailed:
            return L10n("Error.nonceGenerationFailed")
        case .invalidFormat:
            return L10n("Error.invalidFormat")
        case .expired:
            return L10n("Error.expired")
        case .encryptionFailed:
            return L10n("Error.encryptionFailed")
        case .decryptionFailed:
            return L10n("Error.decryptionFailed")
        case .integrityCheckFailed:
            return L10n("Error.integrityCheckFailed")
        case .invalidInputData:
            return L10n("Error.invalidInputData")
        case .unknown:
            return L10n("Error.unknown")
        }
    }
}
