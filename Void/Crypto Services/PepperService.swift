//
//  PepperService.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation
import CryptoKit

final class PepperService {
    
    // MARK: - Obfuscated seed parts
    private let part1_encrypted: [UInt8] = [0x5C, 0x6F, 0x5A]
    private let mask1: [UInt8] = [0xAA, 0xAA, 0xAA]

    private let part2_encrypted: [UInt8] = [0x37, 0x21, 0x4D, 0x1F]
    private let mask2: [UInt8] = [0xAA, 0xAA, 0xAA, 0xAA]

    private let part3_encrypted: [UInt8] = [0x10, 0x3C, 0x5A, 0x7E]
    private let mask3: [UInt8] = [0xAA, 0xAA, 0xAA, 0xAA]

    // Seed recovery
    private var seedData: Data {
        Data(zip(part1_encrypted, mask1).map { $0 ^ $1 }) +
        Data(zip(part2_encrypted, mask2).map { $0 ^ $1 }) +
        Data(zip(part3_encrypted, mask3).map { $0 ^ $1 })
    }

    // MARK: - Returns password + voidKey (if provided)
    func combinedSecret(password: String, voidIndex: UInt16?) async -> String {
        guard let index = voidIndex else { return password }
        
        let combinedPassword = await password + voidKey(for: index)
        
        print("2")
        return combinedPassword
    }
    
    // MARK: - VOID key generation by index
    private func voidKey(for index: UInt16) async -> String {
        var combined = seedData
        var idx = UInt16(index)
        
        combined.append(Data(bytes: &idx, count: MemoryLayout.size(ofValue: idx)))
        
        let hash = SHA256.hash(data: combined)
        
        print("1")
        
        return hash.map { String(format: "%02x", $0) }
            .joined()
            .prefix(16)
            .description
    }
    
    deinit {
     print("PepperService")
    }
}
