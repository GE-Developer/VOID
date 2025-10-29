//
//  CodecService.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

struct CodecService {
    
    enum CodingMode {
        case utf8
        case ascii
        case base64
    }

    // MARK: - Public Interface
    static func encode(_ text: String, mode: CodingMode) throws -> String {
        switch mode {
        case .utf8: return try encodeUTF8(text)
        case .ascii: return try encodeASCII(text)
        case .base64: return try encodeBase64(text)
        }
    }

    static func decode(_ text: String, mode: CodingMode) throws -> String {
        switch mode {
        case .utf8: return try decodeUTF8(text)
        case .ascii: return try decodeASCII(text)
        case .base64: return try decodeBase64(text)
        }
    }

    // MARK: - UTF8
    private static func encodeUTF8(_ text: String) throws -> String {
        guard let data = text.data(using: .utf8) else {
            throw CryptoError.encodingFailed
        }
        
        return data
            .map { String(format: "%02X", $0) }
            .joined(separator: " ")
    }

    private static func decodeUTF8(_ text: String) throws -> String {
        let bytes = text
            .split(separator: " ")
            .compactMap { UInt8($0, radix: 16) }
        
        guard !bytes.isEmpty else { throw CryptoError.invalidInputData }
        guard let result = String(data: Data(bytes), encoding: .utf8) else {
            throw CryptoError.decodingFailed
        }
        
        return result
    }

    // MARK: - ASCII
    private static func encodeASCII(_ text: String) throws -> String {
        guard let data = text.data(using: .ascii) else {
            throw CryptoError.encodingFailed
        }
        
        return data
            .map { String(format: "%02X", $0) }
            .joined(separator: " ")
    }

    private static func decodeASCII(_ text: String) throws -> String {
        let bytes = text
            .split(separator: " ")
            .compactMap { UInt8($0, radix: 16) }
        
        guard !bytes.isEmpty else { throw CryptoError.invalidInputData }
        guard let result = String(data: Data(bytes), encoding: .ascii) else {
            throw CryptoError.decodingFailed
        }
        
        return result
    }

    // MARK: - Base64
    private static func encodeBase64(_ text: String) throws -> String {
        guard let data = text.data(using: .utf8) else {
            throw CryptoError.encodingFailed
        }
        
        return data.base64EncodedString()
    }

    private static func decodeBase64(_ text: String) throws -> String {
        guard let data = Data(base64Encoded: text) else {
            throw CryptoError.invalidInputData
        }
        guard let result = String(data: data, encoding: .utf8) else {
            throw CryptoError.decodingFailed
        }
        
        return result
    }
}
