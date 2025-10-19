//
//  EmojiCodingViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

final class EmojiCodingViewModel: ObservableObject {
    @Published var text = ""
    @Published var currentMode: CryptoAction = .encrypt
    @Published var currentMood: EmojiMood = .positive {
        didSet { hapticsManager.selectionChanged() }
    }
    @Published var showErrorAlert = false
    
    @Published private(set) var messages: [Message] = []
    
    private(set) var errorMessage = ""
    
    private var currentTask: Task<Void, Never>?
    
    var placeholder: String {
        switch currentMode {
        case .encrypt: return L10n("Coding.Placeholder.encode")
        case .decrypt: return L10n("Coding.Placeholder.decode")
        }
    }
    
    let emojiCodecTitle = L10n("Emoji")
    let settingsTitle = L10n("Settings.title")
    let headerText = L10n("EmojiCoding.headerText")
    let decryptionTitle = L10n("Coding.decode")
    let encryptionTitle = L10n("Coding.encode")
    let errorTitle = L10n("Error.title")
    let okTitle = "OK"
    let emojiFormTitle = L10n("EmojiSettings.EmojiSelection.title")
    let emojiFormDescription = L10n("EmojiSettings.EmojiSelection.description")
    
    private let soundManager = SoundManager.shared
    private let hapticsManager = HapticsManager.shared
    
    func startCryptoProcess() {
        switch currentMode {
        case .encrypt:
            currentTask = Task { await encode() }
        case .decrypt:
            currentTask = Task { await decode() }
        }
    }
    
    @MainActor
    private func encode() async {
        defer {
            currentTask?.cancel()
        }
        
        let plainText = text
        text = ""
        
        do {
            let resultText = try await EmojiCodecManager.encode(
                plainText,
                mood: currentMood
            )
            let message = Message(
                plainText: plainText,
                resultText: resultText,
                encryptionMode: .encrypt
            )
            
            messages.append(message)
            soundManager.playSound(.newEncryptedMessage)
            hapticsManager.notification(type: .success)
        } catch {
            let cryptoError = error as? CryptoError
            errorMessage = cryptoError?.errorDescription ?? CryptoError.unknown.errorDescription
            
            showErrorAlert = true
            
            soundManager.playSound(.errorAlert)
            hapticsManager.notification(type: .error)
        }
    }
    
    @MainActor
    private func decode() async {
        defer {
            currentTask?.cancel()
        }
        
        let plainText = text
        text = ""
        
        do {
            let resultText = try await EmojiCodecManager.decode(plainText)
            let message = Message(
                plainText: plainText,
                resultText: resultText,
                encryptionMode: .decrypt
            )
            
            messages.append(message)
            soundManager.playSound(.newDecryptedMessage)
            hapticsManager.notification(type: .success)
        } catch {
            let cryptoError = error as? CryptoError
            errorMessage = cryptoError?.errorDescription ?? CryptoError.unknown.errorDescription
            
            showErrorAlert = true
            
            soundManager.playSound(.errorAlert)
            hapticsManager.notification(type: .error)
        }
    }
}
