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
        BinaryCodec.appendUInt16(UInt16(nameBytes.count), to: &data)
        data.append(nameBytes)

        BinaryCodec.appendUInt64(originalFileSize, to: &data)

        let mimeBytes = Data(mimeType.utf8)
        BinaryCodec.appendUInt16(UInt16(mimeBytes.count), to: &data)
        data.append(mimeBytes)

        BinaryCodec.appendUInt32(chunkSize, to: &data)

        BinaryCodec.appendUInt16(UInt16(argon2Salt.count), to: &data)
        data.append(argon2Salt)

        BinaryCodec.appendUInt16(iterations, to: &data)
        BinaryCodec.appendUInt32(memory, to: &data)
        data.append(parallelism)
        data.append(keyLength)
        data.append(layers)
        BinaryCodec.appendUInt64(expiration, to: &data)

        return data
    }

    static func decode(_ data: Data) throws -> AES256FileHeader {
        var offset = 0

        let nameLen = Int(try BinaryCodec.readUInt16(data, &offset))
        guard data.count >= offset + nameLen else { throw CryptoError.invalidFormat }
        let nameData = data.subdata(in: offset..<offset + nameLen)
        offset += nameLen
        guard let name = String(data: nameData, encoding: .utf8) else { throw CryptoError.invalidFormat }

        let size = try BinaryCodec.readUInt64(data, &offset)

        let mimeLen = Int(try BinaryCodec.readUInt16(data, &offset))
        guard data.count >= offset + mimeLen else { throw CryptoError.invalidFormat }
        let mimeData = data.subdata(in: offset..<offset + mimeLen)
        offset += mimeLen
        guard let mime = String(data: mimeData, encoding: .utf8) else { throw CryptoError.invalidFormat }

        let chunk = try BinaryCodec.readUInt32(data, &offset)

        let saltLen = Int(try BinaryCodec.readUInt16(data, &offset))
        guard data.count >= offset + saltLen else { throw CryptoError.invalidFormat }
        let salt = data.subdata(in: offset..<offset + saltLen)
        offset += saltLen

        let iters = try BinaryCodec.readUInt16(data, &offset)
        let mem = try BinaryCodec.readUInt32(data, &offset)

        guard data.count >= offset + 3 else { throw CryptoError.invalidFormat }
        let parallel = data[offset]; offset += 1
        let keyLen = data[offset]; offset += 1
        let lyrs = data[offset]; offset += 1

        let exp = try BinaryCodec.readUInt64(data, &offset)

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
