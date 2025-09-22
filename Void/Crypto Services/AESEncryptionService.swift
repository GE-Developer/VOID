//
//  AESEncryptionService.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation
import CryptoKit

final class AESEncryptionService {
    
    // MARK: - Text Encryption
    func encrypt(plaintext: Data, keys: [SymmetricKey]/*, expiration: UInt64*/) throws -> Data {
        var current = plaintext
        var outData = Data()
        
        for key in keys {
            let nonce = AES.GCM.Nonce()
            
            guard let sealed = try? AES.GCM.seal(current, using: key, nonce: nonce) else {
                throw CryptoError.encryptionFailed
            }
            var cipherLength = UInt32(sealed.ciphertext.count).bigEndian
            
            outData.append(Data(nonce))
            withUnsafeBytes(of: &cipherLength) { outData.append(contentsOf: $0) }
            outData.append(sealed.ciphertext)
            outData.append(sealed.tag)
            
            current = sealed.ciphertext
        }
        
        return outData
    }
    
    // MARK: - Text Decryption
    func decrypt(ciphertext: Data, keys: [SymmetricKey]/*, expiration: UInt64*/) throws -> Data {        
        var offset = 0
        var layers: [(nonce: AES.GCM.Nonce, ciphertext: Data, tag: Data)] = []
        
        for _ in keys {
            guard ciphertext.count >= offset + 12 + 4 else {
                throw CryptoError.invalidFormat
            }
            
            let nonceData = ciphertext.subdata(in: offset..<offset + 12)
            offset += 12
            
            let lenData = ciphertext.subdata(in: offset..<offset + 4)
            offset += 4
            
            let cipherLen = Int(lenData.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian })
            
            guard ciphertext.count >= offset + cipherLen + 16 else {
                throw CryptoError.invalidFormat
            }
            
            let cipher = ciphertext.subdata(in: offset..<offset + cipherLen)
            offset += cipherLen
            
            let tag = ciphertext.subdata(in: offset..<offset + 16)
            offset += 16
            
            guard let nonce = try? AES.GCM.Nonce(data: nonceData) else {
                throw CryptoError.nonceGenerationFailed
            }
            let layer = (nonce: nonce, ciphertext: cipher, tag: tag)
            
            layers.append(layer)
        }
        
        guard let lastLayer = layers.last else {
            throw CryptoError.invalidFormat
        }
        
        var current = lastLayer.ciphertext
        
        for (i, layer) in layers.enumerated().reversed() {
            guard
                let sealed = try? AES.GCM.SealedBox(
                    nonce: layer.nonce,
                    ciphertext: current,
                    tag: layer.tag
                ),
                let decrypted = try? AES.GCM.open(sealed, using: keys[i])
            else {
                throw CryptoError.decryptionFailed
            }
            
            current = decrypted
        }
        
        return current
    }
}
