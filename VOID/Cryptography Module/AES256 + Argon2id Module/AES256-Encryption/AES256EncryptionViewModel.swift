//
//  AES256EncryptionViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

final class AES256EncryptionViewModel: ObservableObject {
    @Published var encryptionParameters = AES256Parameters(
        password: "",
        voidIndex: 0,
        salt: 8,
        iterations: 1,
        memory: 1024,
        parallelism: 1,
        keyLength: 32,
        layers: 1,
        selectedHours: 0,
        selectedMinutes: 30,
        dateInactive: true
    )
    
    @Published var text = ""
    @Published var showErrorAlert = false
    @Published var currentMode: CryptoAction = .encrypt
    
    @Published private(set) var messages: [Message] = []
    @Published private(set) var isEncrypting = false
    
    var placeholder: String {
        guard encryptionParameters.password != "" else {
            return L10n("Cryptography.Placeholder.default")
        }
        switch currentMode {
        case .encrypt: return L10n("Cryptography.Placeholder.encrypt")
        case .decrypt: return L10n("Cryptography.Placeholder.decrypt")
        }
    }
    
    private(set) var errorMessage = ""
    
    private var currentTask: Task<Void, Never>?
    
    let title = L10n("Cryptography.AES-256")
    let encryptionTitle = L10n("Cryptography.encryption")
    let decryptionTitle = L10n("Cryptography.decryption")
    let headetText = L10n("Cryptography.AES-256.instructions")
    let errorTitle = L10n("Error.title")
    let okTitle = "OK"
    
    private let soundManager = SoundManager.shared
    private let hapticsManager = HapticsManager.shared
    
    func startCryptoProcess() {
        hapticsManager.impact(style: .medium)
        currentTask?.cancel()
        
        switch currentMode {
        case .encrypt:
            currentTask = Task { await encrypt() }
        case .decrypt:
            currentTask = Task { await decrypt() }
        }
    }
    
    @MainActor
    private func encrypt() async {
        defer {
            isEncrypting = false
            currentTask?.cancel()
        }
        
        let userText = text
        let cryptoManager = AES256CryptoManager()
        
        text = ""
        isEncrypting = true
        
        do {
            let result = try await cryptoManager.encrypt(
                plaintext: userText,
                parameters: encryptionParameters
            )
            
            let newMessage = Message(
                plainText: userText,
                resultText: result,
                encryptionMode: currentMode
            )
            
            messages.append(newMessage)
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
    private func decrypt() async {
        defer {
            isEncrypting = false
            currentTask?.cancel()
        }
        
        let cryptoManager = AES256CryptoManager()
        let password = encryptionParameters.password
        let voidIndex = encryptionParameters.voidIndex
        let userText = text
        
        text = ""
        isEncrypting = true
        
        do {
            let result = try await cryptoManager.decrypt(
                ciphertext: userText,
                password: password,
                voidIndex: voidIndex
            )
            
            let newMessage = Message(
                plainText: userText,
                resultText: result,
                encryptionMode: currentMode
            )
            
            messages.append(newMessage)
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
