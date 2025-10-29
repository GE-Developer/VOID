//
//  KeyDerivationService.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation
import Argon2Swift
import CryptoKit

final class KeyDerivationService {
    // MARK: - Salt Generator
    func generateSalt(length: Int) async throws -> Data {
        var salt = Data(count: length)
        
        try salt.withUnsafeMutableBytes {
            guard let baseAddress = $0.baseAddress,
                    SecRandomCopyBytes(kSecRandomDefault, length, baseAddress) == errSecSuccess
            else {
                throw CryptoError.saltGenerationFailed
            }
        }
        
        return salt
    }

    // MARK: - Master key derivation using Argon2id
    func deriveMasterKey(
        password: String,
        salt: Data,
        iterations: UInt16,
        memory: UInt32,
        parallelism: UInt8,
        length: UInt8
    ) async throws -> Data {
        let passwordData = Data(password.utf8)
        
        guard let result = try? Argon2Swift.hashPasswordBytes(
            password: passwordData,
            salt: Salt(bytes: salt),
            iterations: Int(iterations),
            memory: Int(memory),
            parallelism: Int(parallelism),
            length: Int(length),
            type: .id,
            version: .V13
        ) else {
            throw CryptoError.argon2Failed
        }
        
        return result.hashData()
    }
    
    // MARK: - Derives multiple subkeys from a master key using HKDF-SHA256.
    func deriveSubkeys(masterKey: Data, count: Int) async throws -> [SymmetricKey] {
        guard !masterKey.isEmpty else { throw CryptoError.invalidMasterKey }
        guard count > 0 else { throw CryptoError.invalidSubkeyCount }

        let pseudorandomKey = SymmetricKey(data: masterKey)
    
        var subkeys: [SymmetricKey] = []

        for i in 0..<count {
            let info = Data("layer\(i)".utf8)
            let subkey = HKDF<SHA256>.deriveKey(
                inputKeyMaterial: pseudorandomKey,
                salt: Data(),
                info: info,
                outputByteCount: 32
            )
            subkeys.append(subkey)
        }
        
        return subkeys
    }
}
