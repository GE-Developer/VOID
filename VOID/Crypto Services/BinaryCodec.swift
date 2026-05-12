//
//  BinaryCodec.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

enum BinaryCodec {
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
