//
//  AES256FileStreamService.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation
import CryptoKit

final class AES256FileStreamService {
    func encryptStream(
        input: FileHandle,
        output: FileHandle,
        keys: [SymmetricKey],
        chunkSize: Int,
        totalSize: UInt64,
        hasher: StreamingSHA512,
        progress: @Sendable (Double) -> Void
    ) async throws {
        if totalSize == 0 {
            let encrypted = try encryptChunk(plaintext: Data(), keys: keys, chunkIndex: 0, isLast: true)
            try writeOrThrow(output, encrypted)
            hasher.update(encrypted)
            progress(1)
            return
        }

        var chunkIndex: UInt64 = 0
        var bytesProcessed: UInt64 = 0

        while bytesProcessed < totalSize {
            try Task.checkCancellation()

            let plaintext = input.readData(ofLength: chunkSize)
            guard !plaintext.isEmpty else { throw CryptoError.fileReadFailed }

            let isLast = bytesProcessed + UInt64(plaintext.count) >= totalSize

            let encrypted = try encryptChunk(
                plaintext: plaintext,
                keys: keys,
                chunkIndex: chunkIndex,
                isLast: isLast
            )

            try writeOrThrow(output, encrypted)
            hasher.update(encrypted)

            bytesProcessed += UInt64(plaintext.count)
            progress(Double(bytesProcessed) / Double(totalSize))

            chunkIndex += 1
            if isLast { break }
        }
    }

    func decryptStream(
        input: FileHandle,
        output: FileHandle,
        keys: [SymmetricKey],
        chunkSize: UInt32,
        totalPlaintextSize: UInt64,
        hasher: StreamingSHA512,
        progress: @Sendable (Double) -> Void
    ) async throws {
        let layerCount = keys.count

        if totalPlaintextSize == 0 {
            let onDisk = (12 + 4 + 0 + 16) * layerCount
            let encrypted = input.readData(ofLength: onDisk)
            guard encrypted.count == onDisk else { throw CryptoError.invalidFormat }
            hasher.update(encrypted)
            _ = try decryptChunk(data: encrypted, keys: keys, chunkIndex: 0, isLast: true, plaintextSize: 0)
            progress(1)
            return
        }

        var chunkIndex: UInt64 = 0
        var bytesProcessed: UInt64 = 0

        while bytesProcessed < totalPlaintextSize {
            try Task.checkCancellation()

            let remaining = totalPlaintextSize - bytesProcessed
            let thisPlainSize = min(UInt64(chunkSize), remaining)
            let isLast = thisPlainSize == remaining

            let onDisk = (12 + 4 + Int(thisPlainSize) + 16) * layerCount
            let encrypted = input.readData(ofLength: onDisk)
            guard encrypted.count == onDisk else { throw CryptoError.invalidFormat }

            hasher.update(encrypted)

            let plaintext = try decryptChunk(
                data: encrypted,
                keys: keys,
                chunkIndex: chunkIndex,
                isLast: isLast,
                plaintextSize: Int(thisPlainSize)
            )

            try writeOrThrow(output, plaintext)

            bytesProcessed += thisPlainSize
            progress(Double(bytesProcessed) / Double(totalPlaintextSize))

            chunkIndex += 1
        }
    }

    private func encryptChunk(
        plaintext: Data,
        keys: [SymmetricKey],
        chunkIndex: UInt64,
        isLast: Bool
    ) throws -> Data {
        let aad = makeAAD(chunkIndex: chunkIndex, isLast: isLast)

        var current = plaintext
        var output = Data()

        for key in keys {
            let nonce = AES.GCM.Nonce()

            guard let sealed = try? AES.GCM.seal(
                current,
                using: key,
                nonce: nonce,
                authenticating: aad
            ) else {
                throw CryptoError.encryptionFailed
            }

            var cipherLen = UInt32(sealed.ciphertext.count).bigEndian

            output.append(Data(nonce))
            withUnsafeBytes(of: &cipherLen) { output.append(contentsOf: $0) }
            output.append(sealed.ciphertext)
            output.append(sealed.tag)

            current = sealed.ciphertext
        }

        return output
    }

    private func decryptChunk(
        data: Data,
        keys: [SymmetricKey],
        chunkIndex: UInt64,
        isLast: Bool,
        plaintextSize: Int
    ) throws -> Data {
        let aad = makeAAD(chunkIndex: chunkIndex, isLast: isLast)

        var offset = 0
        var layers: [(nonce: AES.GCM.Nonce, ciphertext: Data, tag: Data)] = []

        for _ in keys {
            guard data.count >= offset + 12 + 4 else { throw CryptoError.invalidFormat }
            let nonceData = data.subdata(in: offset..<offset + 12); offset += 12
            let lenData = data.subdata(in: offset..<offset + 4); offset += 4
            let cipherLen = Int(lenData.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian })
            guard data.count >= offset + cipherLen + 16 else { throw CryptoError.invalidFormat }
            let cipher = data.subdata(in: offset..<offset + cipherLen); offset += cipherLen
            let tag = data.subdata(in: offset..<offset + 16); offset += 16
            guard let nonce = try? AES.GCM.Nonce(data: nonceData) else {
                throw CryptoError.nonceGenerationFailed
            }
            layers.append((nonce, cipher, tag))
        }

        guard let last = layers.last else { throw CryptoError.invalidFormat }
        var current = last.ciphertext

        for (i, layer) in layers.enumerated().reversed() {
            guard
                let sealed = try? AES.GCM.SealedBox(
                    nonce: layer.nonce,
                    ciphertext: current,
                    tag: layer.tag
                ),
                let decrypted = try? AES.GCM.open(sealed, using: keys[i], authenticating: aad)
            else {
                throw CryptoError.integrityCheckFailed
            }
            current = decrypted
        }

        guard current.count == plaintextSize else { throw CryptoError.integrityCheckFailed }
        return current
    }

    private func makeAAD(chunkIndex: UInt64, isLast: Bool) -> Data {
        var aad = Data()
        var idx = chunkIndex.bigEndian
        withUnsafeBytes(of: &idx) { aad.append(contentsOf: $0) }
        aad.append(isLast ? 1 : 0)
        return aad
    }

    private func writeOrThrow(_ handle: FileHandle, _ data: Data) throws {
        do {
            try handle.write(contentsOf: data)
        } catch {
            throw CryptoError.fileWriteFailed
        }
    }
}
