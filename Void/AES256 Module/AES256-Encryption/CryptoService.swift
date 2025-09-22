//
//  CryptoService.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 20.09.25.
//

import Foundation
import CryptoKit

//// Версия формата контейнера
//enum CryptoFormat: UInt8 {
//    case v1 = 1
//}
//
//final class CryptoService {
//    private let pepperService = PepperService()
//    private let keyDerivationService = KeyDerivationService()
//    private let aesService = AESEncryptionService()
//
//    // MARK: - Encrypt
//    func encrypt(
//        plaintext: String,
//        parameters: AES256Parameters
//    ) throws -> String {
//        // Объединяем пароль + VOID индекс (перец)
//        let combinedPassword = pepperService.combinedSecret(
//            password: parameters.password,
//            voidIndex: parameters.voidIndex
//        )
//
//        // Генерация соли
//        let salt = try keyDerivationService.generateSalt(length: parameters.salt)
//
//        // Мастер-ключ через Argon2
//        let masterKey = try keyDerivationService.deriveMasterKey(
//            password: combinedPassword,
//            salt: salt,
//            iterations: parameters.iterations,
//            memory: parameters.memory,
//            parallelism: parameters.parallelism,
//            length: parameters.keyLength
//        )
//
//        // Саб-ключи для слоёв
//        let keys = try keyDerivationService.deriveSubkeys(
//            masterKey: masterKey,
//            count: Int(parameters.actualLayers)
//        )
//
//        // Чистое шифрование (без expiration)
//        let encrypted = try aesService.encrypt(
//            plaintext: Data(plaintext.utf8),
//            keys: keys
//        )
//
//        // --- Сборка бинарного контейнера ---
//        var container = Data()
//        
//        // Версия формата
//        container.append(CryptoFormat.v1.rawValue)
//
//        // Длина соли + соль
//        var saltLen = UInt16(salt.count).bigEndian
//        withUnsafeBytes(of: &saltLen) { container.append(contentsOf: $0) }
//        container.append(salt)
//
//        // Итерации
//        var iters = parameters.iterations.bigEndian
//        withUnsafeBytes(of: &iters) { container.append(contentsOf: $0) }
//
//        // Память
//        var mem = parameters.memory.bigEndian
//        withUnsafeBytes(of: &mem) { container.append(contentsOf: $0) }
//
//        // Параллелизм, длина ключа, количество слоёв
//        container.append(parameters.parallelism)
//        container.append(parameters.keyLength)
//        container.append(parameters.actualLayers)
//
//        // Expiration (если 0 → бессрочно)
//        var exp = parameters.duration.bigEndian
//        withUnsafeBytes(of: &exp) { container.append(contentsOf: $0) }
//
//        // Длина шифротекста
//        var cipherLen = UInt32(encrypted.count).bigEndian
//        withUnsafeBytes(of: &cipherLen) { container.append(contentsOf: $0) }
//        
//        // Сам шифротекст
//        container.append(encrypted)
//
//        // Кодируем в Base64
//        return container.base64EncodedString()
//    }
//
//    // MARK: - Decrypt
//    func decrypt(
//        ciphertext: String,
//        password: String,
//        voidIndex: UInt16?
//    ) throws -> String {
//        // Декодируем Base64
//        guard let raw = Data(base64Encoded: ciphertext) else {
//            throw CryptoError.invalidFormat
//        }
//
//        var offset = 0
//
//        // Версия
//        guard raw.count > offset else { throw CryptoError.invalidFormat }
//        let versionByte = raw[offset]; offset += 1
//        guard let version = CryptoFormat(rawValue: versionByte) else {
//            throw CryptoError.invalidFormat
//        }
//        
//        switch version {
//        case .v1:
//            // Длина соли
//            guard raw.count >= offset + 2 else { throw CryptoError.invalidFormat }
//            let saltLen = Int(raw.withUnsafeBytes {
//                $0.load(fromByteOffset: offset, as: UInt16.self).bigEndian
//            })
//            offset += 2
//
//            // Соль
//            guard raw.count >= offset + saltLen else { throw CryptoError.invalidFormat }
//            let salt = raw.subdata(in: offset..<offset+saltLen)
//            offset += saltLen
//
//            // Итерации
//            let iterations = raw.withUnsafeBytes {
//                $0.load(fromByteOffset: offset, as: UInt16.self).bigEndian
//            }
//            offset += 2
//
//            // Память
//            let memory = raw.withUnsafeBytes {
//                $0.load(fromByteOffset: offset, as: UInt32.self).bigEndian
//            }
//            offset += 4
//
//            // Параллелизм, длина ключа, слои
//            let parallelism = raw[offset]; offset += 1
//            let keyLength = raw[offset]; offset += 1
//            let layers = raw[offset]; offset += 1
//
//            // Expiration
//            let expiration = raw.withUnsafeBytes {
//                $0.load(fromByteOffset: offset, as: UInt64.self).bigEndian
//            }
//            offset += 8
//
//            // Проверка срока действия
//            if expiration != 0 {
//                let now = UInt64(Date().timeIntervalSince1970)
//                guard now <= expiration else { throw CryptoError.expired }
//            }
//
//            // Длина шифротекста
//            let cipherLen = raw.withUnsafeBytes {
//                $0.load(fromByteOffset: offset, as: UInt32.self).bigEndian
//            }
//            offset += 4
//
//            // Шифротекст
//            guard raw.count >= offset + Int(cipherLen) else {
//                throw CryptoError.invalidFormat
//            }
//            let cipher = raw.subdata(in: offset..<offset+Int(cipherLen))
//
//            // --- Восстановление ключей ---
//            let combinedPassword = pepperService.combinedSecret(
//                password: password,
//                voidIndex: voidIndex
//            )
//            let masterKey = try keyDerivationService.deriveMasterKey(
//                password: combinedPassword,
//                salt: salt,
//                iterations: iterations,
//                memory: memory,
//                parallelism: parallelism,
//                length: keyLength
//            )
//            let keys = try keyDerivationService.deriveSubkeys(
//                masterKey: masterKey,
//                count: Int(layers)
//            )
//
//            // Расшифровка (без проверки expiration внутри AES)
//            let decrypted = try aesService.decrypt(
//                ciphertext: cipher,
//                keys: keys
//            )
//
//            guard let result = String(data: decrypted, encoding: .utf8) else {
//                throw CryptoError.invalidFormat
//            }
//            
//            return result
//        }
//    }
//}


import Foundation
import CryptoKit // Для SHA256

enum CryptoFormat: UInt8 {
    case v1 = 1
}

final class CryptoService {
    private let pepperService = PepperService()
    private let keyDerivationService = KeyDerivationService()
    private let aesService = AESEncryptionService()

    // MARK: - Encrypt
    func encrypt(
        plaintext: String,
        parameters: AES256Parameters
    ) throws -> String {
        // -----------------------------
        // 1. Основной ключ и шифрование текста
        // -----------------------------
        let combinedPassword = pepperService.combinedSecret(
            password: parameters.password,
            voidIndex: parameters.voidIndex
        )

        // Генерация соли для Argon2
        let salt = try keyDerivationService.generateSalt(length: parameters.salt)

        // Мастер-ключ через Argon2
        let masterKey = try keyDerivationService.deriveMasterKey(
            password: combinedPassword,
            salt: salt,
            iterations: parameters.iterations,
            memory: parameters.memory,
            parallelism: parameters.parallelism,
            length: parameters.keyLength
        )

        // Саб-ключи для слоёв AES
        let keys = try keyDerivationService.deriveSubkeys(
            masterKey: masterKey,
            count: Int(parameters.actualLayers)
        )

        // Шифрование текста
        let encryptedText = try aesService.encrypt(
            plaintext: Data(plaintext.utf8),
            keys: keys
        )

        // -----------------------------
        // 2. Формируем контейнер с метаданными
        // -----------------------------
        var container = Data()
        container.append(CryptoFormat.v1.rawValue) // версия

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
        // 3. Meta-ключ для обёртки контейнера
        // -----------------------------
        let metaPassword = pepperService.combinedSecret(
            password: String(parameters.password.reversed()),
            voidIndex: nil
        )

        let metaSalt = try keyDerivationService.generateSalt(length: 32)

        let metaMasterKey = try keyDerivationService.deriveMasterKey(
            password: metaPassword,
            salt: metaSalt,
            iterations: 30,
            memory: 1024 * 128,
            parallelism: 4,
            length: 128
        )

        let metaKeys = try keyDerivationService.deriveSubkeys(masterKey: metaMasterKey, count: 1)

        // Шифруем контейнер meta-ключом
        let metaEncrypted = try aesService.encrypt(plaintext: container, keys: metaKeys)

        // -----------------------------
        // 4. Контроль целостности (имитация HMAC)
        // -----------------------------
        // Сумма зависит от metaEncrypted + metaMasterKey
        var checksumData = metaEncrypted
        checksumData.append(contentsOf: metaMasterKey) // ключ добавляется в хеш
        let checksum = Data(SHA512.hash(data: checksumData)) // SHA256 для защиты целостности

        // -----------------------------
        // 5. Финальный пакет: metaSalt + metaEncrypted + checksum
        // -----------------------------
        var finalData = Data()
        finalData.append(metaSalt)
        finalData.append(metaEncrypted)
        finalData.append(checksum)

        // Возвращаем Base64 для передачи
        return finalData.base64EncodedString()
    }

    // MARK: - Decrypt
    func decrypt(
        ciphertext: String,
        password: String,
        voidIndex: UInt16?
    ) throws -> String {
        // -----------------------------
        // 1. Base64 → Data
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
        // 2. Извлекаем metaSalt, metaEncrypted и checksum
        // -----------------------------
        let metaSalt = raw.subdata(in: 0..<metaSaltLength)
        let metaEncrypted = raw.subdata(in: metaSaltLength..<(raw.count - checksumLength))
        let checksum = raw.subdata(in: (raw.count - checksumLength)..<raw.count)

        // -----------------------------
        // 3. Восстанавливаем meta-ключ
        // -----------------------------
        let metaPassword = pepperService.combinedSecret(
            password: String(password.reversed()),
            voidIndex: nil
        )

        let metaMasterKey = try keyDerivationService.deriveMasterKey(
            password: metaPassword,
            salt: metaSalt,
            iterations: 30,
            memory: 1024 * 128,
            parallelism: 4,
            length: 128
        )

        let metaKeys = try keyDerivationService.deriveSubkeys(masterKey: metaMasterKey, count: 1)

        // -----------------------------
        // 4. Проверка целостности
        // -----------------------------
        var checksumData = metaEncrypted
        checksumData.append(contentsOf: metaMasterKey)
        let calculated = Data(SHA512.hash(data: checksumData))
        guard checksum == calculated else {
            throw CryptoError.integrityCheckFailed
        }

        // -----------------------------
        // 5. Расшифровка meta-слоя → получаем контейнер
        // -----------------------------
        let container = try aesService.decrypt(ciphertext: metaEncrypted, keys: metaKeys)

        // -----------------------------
        // 6. Расшифровка основного текста
        // -----------------------------
        var offset = 0
        guard container.count > offset else { throw CryptoError.invalidFormat }
        let versionByte = container[offset]; offset += 1
        guard let version = CryptoFormat(rawValue: versionByte) else { throw CryptoError.invalidFormat }

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
            let combinedPassword = pepperService.combinedSecret(password: password, voidIndex: voidIndex)
            let masterKey = try keyDerivationService.deriveMasterKey(
                password: combinedPassword,
                salt: salt,
                iterations: iterations,
                memory: memory,
                parallelism: parallelism,
                length: keyLength
            )

            let keys = try keyDerivationService.deriveSubkeys(masterKey: masterKey, count: Int(layers))
            let decrypted = try aesService.decrypt(ciphertext: cipher, keys: keys)

            guard let result = String(data: decrypted, encoding: .utf8) else {
                throw CryptoError.invalidFormat
            }

            return result
        }
    }
}
