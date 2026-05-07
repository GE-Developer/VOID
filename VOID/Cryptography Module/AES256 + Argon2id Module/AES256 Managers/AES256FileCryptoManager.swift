//
//  AES256FileCryptoManager.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation
import CryptoKit

final class AES256FileCryptoManager {
    private let pepperService = PepperService()
    private let keyDerivationService = KeyDerivationService()
    private let streamService = AES256FileStreamService()
    private let aesService = AESEncryptionService()

    private static let chunkSize: UInt32 = 256 * 1024
    private static let metaSaltLength = 32
    private static let checksumLength = 64

    func encrypt(
        inputURL: URL,
        outputURL: URL,
        parameters: AES256Parameters,
        mimeType: String,
        progress: @Sendable @escaping (Double) -> Void
    ) async throws {
        try Task.checkCancellation()

        let attrs = try FileManager.default.attributesOfItem(atPath: inputURL.path)
        guard let fileSize = (attrs[.size] as? NSNumber)?.uint64Value else {
            throw CryptoError.fileReadFailed
        }

        let combinedPassword = await pepperService.combinedSecret(
            password: parameters.password,
            voidIndex: parameters.voidIndex
        )
        try Task.checkCancellation()

        let salt = try await keyDerivationService.generateSalt(length: parameters.salt)
        try Task.checkCancellation()

        let masterKey = try await keyDerivationService.deriveMasterKey(
            password: combinedPassword,
            salt: salt,
            iterations: parameters.iterations,
            memory: parameters.memory,
            parallelism: parameters.parallelism,
            length: parameters.keyLength
        )
        try Task.checkCancellation()

        let keys = try await keyDerivationService.deriveSubkeys(
            masterKey: masterKey,
            count: Int(parameters.actualLayers)
        )
        try Task.checkCancellation()

        let header = AES256FileHeader(
            originalFileName: inputURL.lastPathComponent,
            originalFileSize: fileSize,
            mimeType: mimeType,
            chunkSize: Self.chunkSize,
            argon2Salt: salt,
            iterations: parameters.iterations,
            memory: parameters.memory,
            parallelism: parameters.parallelism,
            keyLength: parameters.keyLength,
            layers: parameters.actualLayers,
            expiration: parameters.duration
        )

        let metaPassword = await pepperService.combinedSecret(
            password: String(parameters.password.reversed()),
            voidIndex: nil
        )
        let metaSalt = try await keyDerivationService.generateSalt(length: Self.metaSaltLength)
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

        let encryptedHeader = try await aesService.encrypt(plaintext: header.encode(), keys: metaKeys)

        FileManager.default.createFile(atPath: outputURL.path, contents: nil)
        guard let outHandle = try? FileHandle(forWritingTo: outputURL) else {
            throw CryptoError.fileWriteFailed
        }
        defer { try? outHandle.close() }

        guard let inHandle = try? FileHandle(forReadingFrom: inputURL) else {
            throw CryptoError.fileReadFailed
        }
        defer { try? inHandle.close() }

        let hasher = StreamingSHA512()

        var prefix = Data()
        prefix.append(CryptoVersion.v1.rawValue)
        prefix.append(metaSalt)
        FileEncryptionCodec.appendUInt32(UInt32(encryptedHeader.count), to: &prefix)
        prefix.append(encryptedHeader)

        do {
            try outHandle.write(contentsOf: prefix)
        } catch {
            throw CryptoError.fileWriteFailed
        }
        hasher.update(prefix)
        hasher.update(Data(metaMasterKey))

        try await streamService.encryptStream(
            input: inHandle,
            output: outHandle,
            keys: keys,
            chunkSize: Int(Self.chunkSize),
            totalSize: fileSize,
            hasher: hasher,
            progress: progress
        )

        let checksum = hasher.finalize()
        do {
            try outHandle.write(contentsOf: checksum)
        } catch {
            throw CryptoError.fileWriteFailed
        }
    }

    func decrypt(
        inputURL: URL,
        outputDirectoryURL: URL,
        password: String,
        voidIndex: UInt16?,
        progress: @Sendable @escaping (Double) -> Void
    ) async throws -> URL {
        try Task.checkCancellation()

        let attrs = try FileManager.default.attributesOfItem(atPath: inputURL.path)
        guard let fileSize = (attrs[.size] as? NSNumber)?.uint64Value else {
            throw CryptoError.fileReadFailed
        }
        guard fileSize > UInt64(1 + Self.metaSaltLength + 4 + Self.checksumLength) else {
            throw CryptoError.invalidFormat
        }

        guard let inHandle = try? FileHandle(forReadingFrom: inputURL) else {
            throw CryptoError.fileReadFailed
        }
        defer { try? inHandle.close() }

        let hasher = StreamingSHA512()

        let versionData = inHandle.readData(ofLength: 1)
        guard versionData.count == 1, versionData[0] == CryptoVersion.v1.rawValue else {
            throw CryptoError.invalidFormat
        }
        hasher.update(versionData)

        let metaSalt = inHandle.readData(ofLength: Self.metaSaltLength)
        guard metaSalt.count == Self.metaSaltLength else { throw CryptoError.invalidFormat }
        hasher.update(metaSalt)

        let headerLenData = inHandle.readData(ofLength: 4)
        guard headerLenData.count == 4 else { throw CryptoError.invalidFormat }
        hasher.update(headerLenData)
        let headerLen = Int(headerLenData.withUnsafeBytes { $0.load(as: UInt32.self).bigEndian })

        guard headerLen > 0, headerLen < 1_048_576 else { throw CryptoError.invalidFormat }

        let encryptedHeader = inHandle.readData(ofLength: headerLen)
        guard encryptedHeader.count == headerLen else { throw CryptoError.invalidFormat }
        hasher.update(encryptedHeader)

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
        let metaKeys = try await keyDerivationService.deriveSubkeys(masterKey: metaMasterKey, count: 1)
        try Task.checkCancellation()

        hasher.update(Data(metaMasterKey))

        let headerData: Data
        do {
            headerData = try await aesService.decrypt(ciphertext: encryptedHeader, keys: metaKeys)
        } catch {
            throw CryptoError.integrityCheckFailed
        }

        let header: AES256FileHeader
        do {
            header = try AES256FileHeader.decode(headerData)
        } catch {
            throw CryptoError.integrityCheckFailed
        }

        if header.expiration != 0 {
            let now = UInt64(Date().timeIntervalSince1970)
            guard now <= header.expiration else { throw CryptoError.expired }
        }

        let combinedPassword = await pepperService.combinedSecret(
            password: password,
            voidIndex: voidIndex
        )
        try Task.checkCancellation()

        let masterKey = try await keyDerivationService.deriveMasterKey(
            password: combinedPassword,
            salt: header.argon2Salt,
            iterations: header.iterations,
            memory: header.memory,
            parallelism: header.parallelism,
            length: header.keyLength
        )
        let keys = try await keyDerivationService.deriveSubkeys(
            masterKey: masterKey,
            count: Int(header.layers)
        )
        try Task.checkCancellation()

        let safeName: String = {
            let last = (header.originalFileName as NSString).lastPathComponent
            if last.isEmpty || last == "." || last == ".." {
                return "decrypted"
            }
            return last
        }()
        let outputURL = outputDirectoryURL.appendingPathComponent(safeName)
        FileManager.default.createFile(atPath: outputURL.path, contents: nil)
        guard let outHandle = try? FileHandle(forWritingTo: outputURL) else {
            throw CryptoError.fileWriteFailed
        }
        defer { try? outHandle.close() }

        try await streamService.decryptStream(
            input: inHandle,
            output: outHandle,
            keys: keys,
            chunkSize: header.chunkSize,
            totalPlaintextSize: header.originalFileSize,
            hasher: hasher,
            progress: progress
        )

        let storedChecksum = inHandle.readData(ofLength: Self.checksumLength)
        guard storedChecksum.count == Self.checksumLength else { throw CryptoError.invalidFormat }
        let calculated = hasher.finalize()
        guard storedChecksum == calculated else { throw CryptoError.integrityCheckFailed }

        return outputURL
    }
}
