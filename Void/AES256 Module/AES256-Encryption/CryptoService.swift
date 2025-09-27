//
//  CryptoService.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 20.09.25.
//

import Foundation
import CryptoKit

final class CryptoService {
    private let pepperService = PepperService()
    private let keyDerivationService = KeyDerivationService()
    private let aesService = AESEncryptionService()

    // MARK: - Encrypt
    func encrypt(plaintext: String, parameters: AES256Parameters) async throws -> String {
        
        // -----------------------------
        // MARK: Основной ключ и шифрование текста
        // -----------------------------
        // Комбинированный пароль
        try Task.checkCancellation()
        let combinedPassword = await pepperService.combinedSecret(
            password: parameters.password,
            voidIndex: parameters.voidIndex
        )
        try Task.checkCancellation()
        // Генерация соли для Argon2
        let salt = try await keyDerivationService.generateSalt(length: parameters.salt)

        try Task.checkCancellation()
        // Мастер-ключ через Argon2
        let masterKey = try await keyDerivationService.deriveMasterKey(
            password: combinedPassword,
            salt: salt,
            iterations: parameters.iterations,
            memory: parameters.memory,
            parallelism: parameters.parallelism,
            length: parameters.keyLength
        )
 
        try Task.checkCancellation()
        // Саб-ключи для слоёв AES
        let keys = try await keyDerivationService.deriveSubkeys(
            masterKey: masterKey,
            count: Int(parameters.actualLayers)
        )

        try Task.checkCancellation()
        // Шифрование текста
        let encryptedText = try await aesService.encrypt(
            plaintext: Data(plaintext.utf8),
            keys: keys
        )

        try Task.checkCancellation()
        // -----------------------------
        // MARK: Формируем контейнер с метаданными
        // -----------------------------
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

        // -----------------------------
        // MARK: Meta-ключ для обёртки контейнера
        // -----------------------------
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
        // Шифруем контейнер meta-ключом
        let metaEncrypted = try await aesService.encrypt(plaintext: container, keys: metaKeys)

        // -----------------------------
        // MARK: Контроль целостности
        // -----------------------------
        try Task.checkCancellation()
        // Сумма зависит от metaEncrypted + metaMasterKey
        var checksumData = metaEncrypted
        checksumData.append(contentsOf: metaMasterKey) // ключ добавляется в хеш
        let checksum = Data(SHA512.hash(data: checksumData)) // SHA256 для защиты целостности

        // -----------------------------
        // MARK: Финальный пакет: metaSalt + metaEncrypted + checksum
        // -----------------------------
        try Task.checkCancellation()
        var finalData = Data()
        finalData.append(metaSalt)
        finalData.append(metaEncrypted)
        finalData.append(checksum)

        try Task.checkCancellation()
        // Возвращаем Base64 для передачи
        return finalData.base64EncodedString()
    }

    // MARK: - Decrypt
    func decrypt(
        ciphertext: String,
        password: String,
        voidIndex: UInt16?
    ) async throws -> String {
        // -----------------------------
        // MARK: Base64 → Data
        // -----------------------------
        guard let raw = Data(base64Encoded: ciphertext) else {
            throw CryptoError.invalidFormat
        }

        let metaSaltLength = 32
        let checksumLength = 64
        guard raw.count > metaSaltLength + checksumLength else {
            throw CryptoError.invalidFormat
        }

        // -----------------------------
        // MARK: Извлекаем metaSalt, metaEncrypted и checksum
        // -----------------------------
        let metaSalt = raw.subdata(in: 0..<metaSaltLength)
        let metaEncrypted = raw.subdata(in: metaSaltLength..<(raw.count - checksumLength))
        let checksum = raw.subdata(in: (raw.count - checksumLength)..<raw.count)

        // -----------------------------
        // MARK: Восстанавливаем meta-ключ
        // -----------------------------
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
        let metaKeys = try await keyDerivationService.deriveSubkeys(masterKey: metaMasterKey, count: 1)

        // -----------------------------
        // MARK: Проверка целостности
        // -----------------------------
        try Task.checkCancellation()
        var checksumData = metaEncrypted
        checksumData.append(contentsOf: metaMasterKey)
        let calculated = Data(SHA512.hash(data: checksumData))
        guard checksum == calculated else {
            throw CryptoError.integrityCheckFailed
        }

        // -----------------------------
        // MARK: Расшифровка meta-слоя → получаем контейнер
        // -----------------------------
        try Task.checkCancellation()
        let container = try await aesService.decrypt(ciphertext: metaEncrypted, keys: metaKeys)

        // -----------------------------
        // MARK: Расшифровка основного текста
        // -----------------------------
        var offset = 0
        
        guard container.count > offset else { throw CryptoError.invalidFormat }
        let versionByte = container[offset]
        offset += 1
        
        guard let version = CryptoVersion(rawValue: versionByte) else { throw CryptoError.invalidFormat }

        switch version {
        case .v1:
            guard container.count >= offset + 2 else { throw CryptoError.invalidFormat }
            let saltLen = Int(container.withUnsafeBytes { $0.load(fromByteOffset: offset, as: UInt16.self).bigEndian })
            offset += 2
            
            guard container.count >= offset + saltLen else { throw CryptoError.invalidFormat }
            let salt = container.subdata(in: offset..<offset+saltLen)
            offset += saltLen

            let iterations = container.withUnsafeBytes { $0.load(fromByteOffset: offset, as: UInt16.self).bigEndian }
            offset += 2
            
            let memory = container.withUnsafeBytes { $0.load(fromByteOffset: offset, as: UInt32.self).bigEndian }
            offset += 4
            
            let parallelism = container[offset]; offset += 1
            
            let keyLength = container[offset]; offset += 1
            
            let layers = container[offset]; offset += 1
            
            let expiration = container.withUnsafeBytes { $0.load(fromByteOffset: offset, as: UInt64.self).bigEndian }
            offset += 8

            if expiration != 0 {
                let now = UInt64(Date().timeIntervalSince1970)
                guard now <= expiration else { throw CryptoError.expired }
            }

            let cipherLen = container.withUnsafeBytes { $0.load(fromByteOffset: offset, as: UInt32.self).bigEndian }
            offset += 4
            
            guard container.count >= offset + Int(cipherLen) else { throw CryptoError.invalidFormat }
            let cipher = container.subdata(in: offset..<offset+Int(cipherLen))

            // Восстанавливаем основной ключ
            try Task.checkCancellation()
            let combinedPassword = await pepperService.combinedSecret(password: password, voidIndex: voidIndex)
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
            let keys = try await keyDerivationService.deriveSubkeys(masterKey: masterKey, count: Int(layers))
            try Task.checkCancellation()
            let decrypted = try await aesService.decrypt(ciphertext: cipher, keys: keys)

            guard let result = String(data: decrypted, encoding: .utf8) else {
                throw CryptoError.invalidFormat
            }

            return result
        }
    }
    
    deinit {
     print("CryptoService")
    }
}
