//
//  PasswordManager.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 22.08.25.
//

import Foundation
import CryptoKit

final class PasswordManager {

    // MARK: - Обфусцированные куски seed-а
    private let part1_encrypted: [UInt8] = [0x5C, 0x6F, 0x5A]
    private let mask1: [UInt8] = [0xAA, 0xAA, 0xAA]

    private let part2_encrypted: [UInt8] = [0x37, 0x21, 0x4D, 0x1F]
    private let mask2: [UInt8] = [0xAA, 0xAA, 0xAA, 0xAA]

    private let part3_encrypted: [UInt8] = [0x10, 0x3C, 0x5A, 0x7E]
    private let mask3: [UInt8] = [0xAA, 0xAA, 0xAA, 0xAA]

    // MARK: - Восстановление seed-а
    private var seedData: Data {
        func decrypt(_ data: [UInt8], mask: [UInt8]) -> Data {
            Data(zip(data, mask).map { $0 ^ $1 })
        }
        return decrypt(part1_encrypted, mask: mask1) +
               decrypt(part2_encrypted, mask: mask2) +
               decrypt(part3_encrypted, mask: mask3)
    }

    // MARK: - Генерация voidKey по номеру
    private func voidKey(for index: Int, hexLength: Int = 32) -> String {
        precondition(index >= 0 && index < 10_000, "index must be 0..9999")
        var combined = seedData
        var idx = UInt16(index)
        combined.append(Data(bytes: &idx, count: MemoryLayout.size(ofValue: idx)))

        let hash = SHA256.hash(data: combined)
        let hex = hash.map { String(format: "%02x", $0) }.joined()
        return String(hex.prefix(hexLength))
    }

    // MARK: - Возвращает password + voidKey
    func combinedSecret(password: String, voidIndex: Int?) -> String {
        guard let index = voidIndex else { return password }
        let vKey = voidKey(for: index)
        print(vKey)
        return password + vKey
    }
}
