//
//  AES256CryptoManager.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation
import CryptoKit

final class AES256CryptoManager {
    private let pepperService = PepperService()
    private let keyDerivationService = KeyDerivationService()
    private let aesService = AESEncryptionService()
    
    // MARK: - Encrypt
    func encrypt(
        plaintext: String,
        parameters: AES256Parameters
    ) async throws -> String {
        
        // MARK: - Main Key and Text Encryption
        try Task.checkCancellation()
        
        // Combined password
        let combinedPassword = await pepperService.combinedSecret(
            password: parameters.password,
            voidIndex: parameters.voidIndex
        )
        try Task.checkCancellation()
        
        // Generate salt for Argon2
        let salt = try await keyDerivationService.generateSalt(length: parameters.salt)
        
        try Task.checkCancellation()
        
        // Master key via Argon2
        let masterKey = try await keyDerivationService.deriveMasterKey(
            password: combinedPassword,
            salt: salt,
            iterations: parameters.iterations,
            memory: parameters.memory,
            parallelism: parameters.parallelism,
            length: parameters.keyLength
        )
        
        try Task.checkCancellation()
        
        // Subkeys for AES layers
        let keys = try await keyDerivationService.deriveSubkeys(
            masterKey: masterKey,
            count: Int(parameters.actualLayers)
        )
        
        try Task.checkCancellation()
        
        // Encrypt text
        let encryptedText = try await aesService.encrypt(
            plaintext: Data(plaintext.utf8),
            keys: keys
        )
        
        try Task.checkCancellation()
        
        // MARK: - Construct container with metadata
        var container = Data()
        container.append(CryptoVersion.v1.rawValue)
        
        var saltLen = UInt16(salt.count).bigEndian
        withUnsafeBytes(of: &saltLen) { container.append(contentsOf: $0) }
        container.append(salt)
        
        var iters = parameters.iterations.bigEndian
        withUnsafeBytes(of: &iters) { container.append(contentsOf: $0) }
        
        var mem = parameters.memory.bigEndian
        withUnsafeBytes(of: &mem) { container.append(contentsOf: $0) }
        
        container.append(parameters.parallelism)
        container.append(parameters.keyLength)
        container.append(parameters.actualLayers)
        
        var exp = parameters.duration.bigEndian
        withUnsafeBytes(of: &exp) { container.append(contentsOf: $0) }
        
        var cipherLen = UInt32(encryptedText.count).bigEndian
        withUnsafeBytes(of: &cipherLen) { container.append(contentsOf: $0) }
        container.append(encryptedText)
        
        // MARK: - Meta key for container wrapping
        let metaPassword = await pepperService.combinedSecret(
            password: String(parameters.password.reversed()),
            voidIndex: nil
        )
        
        let metaSalt = try await keyDerivationService.generateSalt(length: 32)
        
        try Task.checkCancellation()
        let metaMasterKey = try await keyDerivationService.deriveMasterKey(
            password: metaPassword,
            salt: metaSalt,
            iterations: 30,
            memory: 1024 * 128,
            parallelism: 4,
            length: 128
        )
        
        let metaKeys = try await keyDerivationService.deriveSubkeys(masterKey: metaMasterKey, count: 1)
        
        try Task.checkCancellation()
        
        // Encrypt container with meta key
        let metaEncrypted = try await aesService.encrypt(plaintext: container, keys: metaKeys)
        
        // MARK: - Integrity check
        try Task.checkCancellation()
        
        // Checksum depends on metaEncrypted + metaMasterKey
        var checksumData = metaEncrypted
        
        // key included in hash
        checksumData.append(contentsOf: metaMasterKey)
        
        // SHA512 for integrity protection
        let checksum = Data(SHA512.hash(data: checksumData))
        
        // MARK: - Final package: metaSalt + metaEncrypted + checksum
        try Task.checkCancellation()
        
        var finalData = Data()
        finalData.append(metaSalt)
        finalData.append(metaEncrypted)
        finalData.append(checksum)
        
        try Task.checkCancellation()
        
        // Return Base64 for transmission
        return finalData.base64EncodedString()
    }

    // MARK: - Decrypt
    func decrypt(
        ciphertext: String,
        password: String,
        voidIndex: UInt16?
    ) async throws -> String {
        try Task.checkCancellation()
        
        // MARK: - Base64 → Data
        guard let raw = Data(base64Encoded: ciphertext) else {
            throw CryptoError.invalidFormat
        }

        let metaSaltLength = 32
        let checksumLength = 64
        
        guard raw.count > metaSaltLength + checksumLength else {
            throw CryptoError.invalidFormat
        }
        
        // MARK: - Extract metaSalt, metaEncrypted and checksum
        try Task.checkCancellation()
        
        let metaSalt = raw.subdata(in: 0..<metaSaltLength)
        let metaEncrypted = raw.subdata(in: metaSaltLength..<(raw.count - checksumLength))
        let checksum = raw.subdata(in: (raw.count - checksumLength)..<raw.count)
        
        // MARK: - Recover meta key
        try Task.checkCancellation()
        
        let metaPassword = await pepperService.combinedSecret(
            password: String(password.reversed()),
            voidIndex: nil
        )

        try Task.checkCancellation()
        
        let metaMasterKey = try await keyDerivationService.deriveMasterKey(
            password: metaPassword,
            salt: metaSalt,
            iterations: 30,
            memory: 1024 * 128,
            parallelism: 4,
            length: 128
        )

        try Task.checkCancellation()
        
        let metaKeys = try await keyDerivationService.deriveSubkeys(
            masterKey: metaMasterKey,
            count: 1
        )

        // MARK: - Check integrity
        try Task.checkCancellation()
        
        var checksumData = metaEncrypted
        checksumData.append(contentsOf: metaMasterKey)
        
        let calculated = Data(SHA512.hash(data: checksumData))
        
        guard checksum == calculated else { throw CryptoError.integrityCheckFailed }

        // MARK: - Decrypt meta layer → get container
        try Task.checkCancellation()
        
        let container = try await aesService.decrypt(
            ciphertext: metaEncrypted,
            keys: metaKeys
        )
        
        // MARK: - Decrypt main text
        try Task.checkCancellation()
        
        var offset = 0
        
        guard container.count > offset else { throw CryptoError.invalidFormat }
        let versionByte = container[offset]
        offset += 1
        
        guard let version = CryptoVersion(rawValue: versionByte) else {
            throw CryptoError.invalidFormat
        }

        switch version {
        case .v1:
            guard container.count >= offset + 2 else { throw CryptoError.invalidFormat }
            let saltLen = Int(
                container.withUnsafeBytes {
                    $0.load(fromByteOffset: offset, as: UInt16.self).bigEndian
                }
            )
            offset += 2
            
            guard container.count >= offset + saltLen else {
                throw CryptoError.invalidFormat
            }
            let salt = container.subdata(in: offset..<offset + saltLen)
            offset += saltLen

            let iterations = container.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: UInt16.self).bigEndian
            }
            offset += 2
            
            let memory = container.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: UInt32.self).bigEndian
            }
            offset += 4
            
            let parallelism = container[offset]
            offset += 1
            
            let keyLength = container[offset]
            offset += 1
            
            let layers = container[offset]
            offset += 1
            
            let expiration = container.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: UInt64.self).bigEndian
            }
            offset += 8

            if expiration != 0 {
                let now = UInt64(Date().timeIntervalSince1970)
                guard now <= expiration else { throw CryptoError.expired }
            }

            let cipherLen = container.withUnsafeBytes {
                $0.load(fromByteOffset: offset, as: UInt32.self).bigEndian
            }
            offset += 4
            
            guard container.count >= offset + Int(cipherLen) else {
                throw CryptoError.invalidFormat
            }
            let cipher = container.subdata(in: offset..<offset + Int(cipherLen))

            // Recover main key
            try Task.checkCancellation()
            
            let combinedPassword = await pepperService.combinedSecret(
                password: password,
                voidIndex: voidIndex
            )

            try Task.checkCancellation()
            
            let masterKey = try await keyDerivationService.deriveMasterKey(
                password: combinedPassword,
                salt: salt,
                iterations: iterations,
                memory: memory,
                parallelism: parallelism,
                length: keyLength
            )

            try Task.checkCancellation()
            
            let keys = try await keyDerivationService.deriveSubkeys(
                masterKey: masterKey,
                count: Int(layers)
            )

            try Task.checkCancellation()
            
            let decrypted = try await aesService.decrypt(
                ciphertext: cipher,
                keys: keys
            )

            guard let result = String(data: decrypted, encoding: .utf8) else {
                throw CryptoError.invalidFormat
            }

            return result
        }
    }
}
