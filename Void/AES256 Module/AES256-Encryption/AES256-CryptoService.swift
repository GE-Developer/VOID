//
//  AES256-CryptoService.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation
import CryptoKit
import Argon2Swift
 
final class EncryptionService {
    
    private enum EncryptionError: Error {
        case invalidInput
        case encryptionFailed
        case decryptionFailed
        case expiredData
        case invalidFormat
    }
    
    // MARK: - Генерация nonce (12 байт)
    private func generateNonce() throws -> AES.GCM.Nonce {
        var nonceData = Data(count: 12)
        let result = nonceData.withUnsafeMutableBytes { buffer in
            guard let baseAddress = buffer.baseAddress else {
                return errSecParam
            }
            return SecRandomCopyBytes(kSecRandomDefault, 12, baseAddress)
        }
        if result != errSecSuccess {
            throw EncryptionError.encryptionFailed
        }
        guard let nonce = try? AES.GCM.Nonce(data: nonceData) else {
            throw EncryptionError.invalidInput
        }
        return nonce
    }
    
    // MARK: - Генерация соли
    private func generateSalt(length: Int) throws -> Data {
        var salt = Data(count: length)
        try salt.withUnsafeMutableBytes { buffer in
            guard let baseAddress = buffer.baseAddress else {
                throw EncryptionError.invalidInput
            }
            let result = SecRandomCopyBytes(kSecRandomDefault, length, baseAddress)
            if result != errSecSuccess {
                throw EncryptionError.encryptionFailed
            }
        }
        return salt
    }
    
    // MARK: - Производство мастер-ключа Argon2id
    private func deriveMasterKey(
        password: String,
        salt: Data,
        iterations: UInt16,
        memoryKiB: UInt32,
        parallelism: UInt8,
        keyLength: UInt8
    ) throws -> Data {
        let passwordData = Data(password.utf8)
        
        let result = try Argon2Swift.hashPasswordBytes(
            password: passwordData,
            salt: Salt(bytes: salt),
            iterations: Int(iterations),
            memory: Int(memoryKiB),
            parallelism: Int(parallelism),
            length: Int(keyLength),
            type: .id,
            version: .V13
        )
        
        return result.hashData()
    }
    
    // MARK: - Упаковка параметров (фиксированный размер 21 байт)
    private func packParameters(
        saltLength: UInt16,
        iterations: UInt16,
        memoryKiB: UInt32,
        parallelism: UInt8,
        keyLength: UInt8,
        layers: UInt8,
        expirationTimestamp: UInt64
    ) -> Data {
        var data = Data()
        data.append(contentsOf: withUnsafeBytes(of: saltLength.bigEndian, Array.init))      // 2
        data.append(contentsOf: withUnsafeBytes(of: iterations.bigEndian, Array.init))       // 2
        data.append(contentsOf: withUnsafeBytes(of: memoryKiB.bigEndian, Array.init))        // 4
        data.append(parallelism)                                                             // 1
        data.append(keyLength)                                                               // 1
        data.append(layers)                                                                  // 1
        data.append(contentsOf: withUnsafeBytes(of: expirationTimestamp.bigEndian, Array.init)) // 8
        return data
    }
    
    // MARK: - Распарсить параметры из Data
    private func unpackParameters(_ data: Data) throws -> (
        saltLength: UInt16,
        iterations: UInt16,
        memoryKiB: UInt32,
        parallelism: UInt8,
        keyLength: UInt8,
        layers: UInt8,
        expirationTimestamp: UInt64
    ) {
        guard data.count == 19 else {
            throw EncryptionError.invalidFormat
        }
        var offset = 0
        
        func readUInt16() -> UInt16 {
            defer { offset += 2 }
            return data.subdata(in: offset..<offset+2).withUnsafeBytes { $0.load(as: UInt16.self).bigEndian }
        }
        
        func readUInt32() -> UInt32 {
            defer { offset += 4 }
            return data.subdata(in: offset..<offset+4).withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
        }
        
        func readUInt8() -> UInt8 {
            defer { offset += 1 }
            return data[offset]
        }
        
        func readUInt64() -> UInt64 {
            defer { offset += 8 }
            return data.subdata(in: offset..<offset+8).withUnsafeBytes { $0.load(as: UInt64.self).bigEndian }
        }
        
        let saltLength = readUInt16()
        let iterations = readUInt16()
        let memoryKiB = readUInt32()
        let parallelism = readUInt8()
        let keyLength = readUInt8()
        let layers = readUInt8()
        let expirationTimestamp = readUInt64()
        
        return (saltLength, iterations, memoryKiB, parallelism, keyLength, layers, expirationTimestamp)
    }
    
    // MARK: - Шифрование
    func encrypt(
        plaintext: Data,
        password: String,
        saltLength: Int,
        iterations: UInt16,
        memoryKiB: UInt32,
        parallelism: UInt8,
        keyLength: UInt8,
        layers: UInt8,
        expirationTimestamp: UInt64
    ) async throws -> String {
        
        let salt = try generateSalt(length: saltLength)
        
        let masterKey = try deriveMasterKey(
            password: password,
            salt: salt,
            iterations: iterations,
            memoryKiB: memoryKiB,
            parallelism: parallelism,
            keyLength: keyLength
        )
        
        let maxLayers = masterKey.count / 32
        let actualLayers = min(Int(layers), maxLayers)
        
        let keys = stride(from: 0, to: actualLayers * 32, by: 32).map {
            masterKey.subdata(in: $0..<$0+32)
        }
        
        var dataToEncrypt = plaintext
        var encryptedData = Data()
        
        for keyData in keys {
            try Task.checkCancellation()
            let key = SymmetricKey(data: keyData)
            let nonce = try generateNonce()
            let sealedBox = try AES.GCM.seal(dataToEncrypt, using: key, nonce: nonce)
            
            encryptedData.append(Data(nonce))                                    // 12 байт nonce
            let ciphertextLength = UInt32(sealedBox.ciphertext.count)
            encryptedData.append(withUnsafeBytes(of: ciphertextLength.bigEndian) { Data($0) })
            encryptedData.append(sealedBox.ciphertext)                           // ciphertext
            encryptedData.append(sealedBox.tag)                                  // 16 байт tag
            
            dataToEncrypt = sealedBox.ciphertext
        }
        
        // Пакуем параметры (с saltLength для удобства парсинга)
        let paramsData = packParameters(
            saltLength: UInt16(saltLength),
            iterations: iterations,
            memoryKiB: memoryKiB,
            parallelism: parallelism,
            keyLength: keyLength,
            layers: UInt8(actualLayers),
            expirationTimestamp: expirationTimestamp
        )
        
        var finalData = Data()
        finalData.append(paramsData)   // 19 байт параметров в начале
        finalData.append(salt)         // потом соль
        finalData.append(encryptedData) // потом encrypted payload
        
        print(actualLayers)
        
        return finalData.base64EncodedString()
    }
    
    // MARK: - Расшифровка
    func decrypt(_ base64String: String, password: String) async throws -> Data {
        guard let data = Data(base64Encoded: base64String) else {
            throw EncryptionError.invalidInput
        }
        
        // Сначала вытаскиваем параметры (19 байт)
        guard data.count > 19 else {
            throw EncryptionError.invalidFormat
        }
        
        let paramsData = data.subdata(in: 0..<19)
        let (saltLength, iterations, memoryKiB, parallelism, keyLength, layers, expirationTimestamp) = try unpackParameters(paramsData)
        
        // Проверка времени жизни
        if expirationTimestamp != 0 {
            let now = UInt64(Date().timeIntervalSince1970)
            if now > expirationTimestamp {
                throw EncryptionError.expiredData
            }
        }
        
        // Далее соль
        let saltStart = 19
        let saltEnd = saltStart + Int(saltLength)
        guard data.count > saltEnd else {
            throw EncryptionError.invalidFormat
        }
        let salt = data.subdata(in: saltStart..<saltEnd)
        
        // Остаток - зашифрованные данные
        let encryptedData = data.subdata(in: saltEnd..<data.count)
        
        // Производим мастер-ключ (async, но Argon2Swift синхронен, так что просто await для API)
        let masterKey = try deriveMasterKey(
            password: password,
            salt: salt,
            iterations: iterations,
            memoryKiB: memoryKiB,
            parallelism: parallelism,
            keyLength: keyLength
        )
        
        let maxLayers = masterKey.count / 32
        let actualLayers = min(Int(layers), maxLayers)
        let keys = stride(from: 0, to: actualLayers * 32, by: 32).map {
            masterKey.subdata(in: $0..<$0+32)
        }
        
        // Расшифровываем по слоям в обратном порядке
        var currentData = Data()
        var offset = 0
        
        var layersData: [(nonce: AES.GCM.Nonce, ciphertext: Data, tag: Data)] = []
        
        for _ in 0..<actualLayers {
            guard encryptedData.count > offset + 12 + 4 else {
                throw EncryptionError.invalidFormat
            }
            
            let nonceData = encryptedData.subdata(in: offset..<offset+12)
            offset += 12
            
            let cipherLenData = encryptedData.subdata(in: offset..<offset+4)
            offset += 4
            let cipherLen = cipherLenData.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
            
            guard encryptedData.count >= offset + Int(cipherLen) + 16 else {
                throw EncryptionError.invalidFormat
            }
            
            let cipherData = encryptedData.subdata(in: offset..<offset+Int(cipherLen))
            offset += Int(cipherLen)
            
            let tagData = encryptedData.subdata(in: offset..<offset+16)
            offset += 16
            
            guard let nonce = try? AES.GCM.Nonce(data: nonceData) else {
                throw EncryptionError.invalidFormat
            }
            
            layersData.append((nonce, cipherData, tagData))
        }
        
        // Дешифруем в обратном порядке
        currentData = layersData.last!.ciphertext
        
        for (index, layer) in layersData.enumerated().reversed() {
            let keyData = keys[index]
            let key = SymmetricKey(data: keyData)
            
            let sealedBox = try AES.GCM.SealedBox(nonce: layer.nonce, ciphertext: currentData, tag: layer.tag)
            
            do {
                currentData = try AES.GCM.open(sealedBox, using: key)
                print("currentData")
            } catch {
                print("Ошибка")
                throw error
            }
        }
        
        return currentData
    }
}
