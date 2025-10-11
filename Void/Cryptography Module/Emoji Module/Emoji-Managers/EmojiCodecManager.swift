//
//  EmojiCodecManager.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

struct EmojiCodecManager {
    private static let base64Alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")

    static func encode(_ text: String, mood: EmojiMood) async throws -> String {
        let base64 = try CodecService.encode(text, mode: .base64)
        let table = mood.emojis

        let emojiString = base64.compactMap { char -> String? in
            if let index = base64Alphabet.firstIndex(of: char) {
                return String(table[index])
            } else if char == "=" {
                return String(mood.padding)
            } else {
                return nil
            }
        }.joined()

        guard !emojiString.isEmpty else { throw CryptoError.encodingFailed }
        return emojiString
    }

    static func decode(_ emojiText: String) async throws -> String {
        guard let firstEmoji = emojiText.first else { throw CryptoError.decodingFailed
        }

        guard let mood = EmojiMood.allCases.first(
            where: { $0.emojis.contains(firstEmoji) }
        ) else {
            throw CryptoError.invalidInputData
        }

        let table = mood.emojis
        var base64 = ""

        for char in emojiText {
            if let index = table.firstIndex(of: char) {
                base64.append(base64Alphabet[index])
            } else if char == mood.padding {
                base64.append("=")
            } else {
                throw CryptoError.decodingFailed
            }
        }

        let decoded = try CodecService.decode(base64, mode: .base64)
        return decoded
    }
}
