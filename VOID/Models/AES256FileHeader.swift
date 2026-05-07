//
//  AES256FileHeader.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

struct AES256FileHeader: Equatable {
    let originalFileName: String
    let originalFileSize: UInt64
    let mimeType: String
    let chunkSize: UInt32
    let argon2Salt: Data
    let iterations: UInt16
    let memory: UInt32
    let parallelism: UInt8
    let keyLength: UInt8
    let layers: UInt8
    let expiration: UInt64

    func encode() -> Data {
        var data = Data()

        let nameBytes = Data(originalFileName.utf8)
        FileEncryptionCodec.appendUInt16(UInt16(nameBytes.count), to: &data)
        data.append(nameBytes)

        FileEncryptionCodec.appendUInt64(originalFileSize, to: &data)

        let mimeBytes = Data(mimeType.utf8)
        FileEncryptionCodec.appendUInt16(UInt16(mimeBytes.count), to: &data)
        data.append(mimeBytes)

        FileEncryptionCodec.appendUInt32(chunkSize, to: &data)

        FileEncryptionCodec.appendUInt16(UInt16(argon2Salt.count), to: &data)
        data.append(argon2Salt)

        FileEncryptionCodec.appendUInt16(iterations, to: &data)
        FileEncryptionCodec.appendUInt32(memory, to: &data)
        data.append(parallelism)
        data.append(keyLength)
        data.append(layers)
        FileEncryptionCodec.appendUInt64(expiration, to: &data)

        return data
    }

    static func decode(_ data: Data) throws -> AES256FileHeader {
        var offset = 0

        let nameLen = Int(try FileEncryptionCodec.readUInt16(data, &offset))
        guard data.count >= offset + nameLen else { throw CryptoError.invalidFormat }
        let nameData = data.subdata(in: offset..<offset + nameLen)
        offset += nameLen
        guard let name = String(data: nameData, encoding: .utf8) else { throw CryptoError.invalidFormat }

        let size = try FileEncryptionCodec.readUInt64(data, &offset)

        let mimeLen = Int(try FileEncryptionCodec.readUInt16(data, &offset))
        guard data.count >= offset + mimeLen else { throw CryptoError.invalidFormat }
        let mimeData = data.subdata(in: offset..<offset + mimeLen)
        offset += mimeLen
        guard let mime = String(data: mimeData, encoding: .utf8) else { throw CryptoError.invalidFormat }

        let chunk = try FileEncryptionCodec.readUInt32(data, &offset)

        let saltLen = Int(try FileEncryptionCodec.readUInt16(data, &offset))
        guard data.count >= offset + saltLen else { throw CryptoError.invalidFormat }
        let salt = data.subdata(in: offset..<offset + saltLen)
        offset += saltLen

        let iters = try FileEncryptionCodec.readUInt16(data, &offset)
        let mem = try FileEncryptionCodec.readUInt32(data, &offset)

        guard data.count >= offset + 3 else { throw CryptoError.invalidFormat }
        let parallel = data[offset]; offset += 1
        let keyLen = data[offset]; offset += 1
        let lyrs = data[offset]; offset += 1

        let exp = try FileEncryptionCodec.readUInt64(data, &offset)

        guard chunk > 0, chunk <= 16_777_216 else { throw CryptoError.invalidFormat }
        guard lyrs >= 1, lyrs <= 7 else { throw CryptoError.invalidFormat }
        guard keyLen >= 32 else { throw CryptoError.invalidFormat }
        guard parallel >= 1 else { throw CryptoError.invalidFormat }

        return AES256FileHeader(
            originalFileName: name,
            originalFileSize: size,
            mimeType: mime,
            chunkSize: chunk,
            argon2Salt: salt,
            iterations: iters,
            memory: mem,
            parallelism: parallel,
            keyLength: keyLen,
            layers: lyrs,
            expiration: exp
        )
    }
}

// MARK: - Binary Codec Helpers

enum FileEncryptionCodec {
    static func appendUInt16(_ value: UInt16, to data: inout Data) {
        var v = value.bigEndian
        withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
    }

    static func appendUInt32(_ value: UInt32, to data: inout Data) {
        var v = value.bigEndian
        withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
    }

    static func appendUInt64(_ value: UInt64, to data: inout Data) {
        var v = value.bigEndian
        withUnsafeBytes(of: &v) { data.append(contentsOf: $0) }
    }

    static func readUInt16(_ data: Data, _ offset: inout Int) throws -> UInt16 {
        guard offset + 2 <= data.count else { throw CryptoError.invalidFormat }
        var v: UInt16 = 0
        withUnsafeMutableBytes(of: &v) { $0.copyBytes(from: data[offset..<offset + 2]) }
        offset += 2
        return UInt16(bigEndian: v)
    }

    static func readUInt32(_ data: Data, _ offset: inout Int) throws -> UInt32 {
        guard offset + 4 <= data.count else { throw CryptoError.invalidFormat }
        var v: UInt32 = 0
        withUnsafeMutableBytes(of: &v) { $0.copyBytes(from: data[offset..<offset + 4]) }
        offset += 4
        return UInt32(bigEndian: v)
    }

    static func readUInt64(_ data: Data, _ offset: inout Int) throws -> UInt64 {
        guard offset + 8 <= data.count else { throw CryptoError.invalidFormat }
        var v: UInt64 = 0
        withUnsafeMutableBytes(of: &v) { $0.copyBytes(from: data[offset..<offset + 8]) }
        offset += 8
        return UInt64(bigEndian: v)
    }
}
