//
//  AES256EncryptionViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

final class AES256EncryptionViewModel: ObservableObject {
    @Published var encryptionParameters = AES256Parameters(
        password: "вв",
        voidIndex: 3000,
        salt: 8,
        iterations: 200,
        memory: 1024 * 32,
        parallelism: 1,
        keyLength: 32,
        layers: 1,
        selectedHours: 0,
        selectedMinutes: 5,
        dateInactive: true
    )
    
    @Published var text = ""
    @Published var currentMode: CryptoAction = .encrypt
    @Published var errorMessage = ""
    @Published var showErrorAlert = false
    
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
    
    private var currentTask: Task<Void, Never>?
    
    let title = L10n("Cryptography.AES-256")
    let encryptionTitle = L10n("Cryptography.encryption")
    let decryptionTitle = L10n("Cryptography.decryption")
    let headetText = L10n("Cryptography.AES-256.instructions")
    let errorTitle = L10n("Error.title")
    let okTitle = "OK"
    
    func startCryptoProcess() {
        currentTask?.cancel()
        
        switch currentMode {
        case .encrypt:
            currentTask = Task { await encrypt() }
        case .decrypt:
            currentTask = Task { await decrypt() }
        }
    }
    
    @MainActor private func encrypt() async {
        defer {
            isEncrypting = false
            currentTask?.cancel()
        }
        
        let userText = text
        text = ""
        
        let cryptoManager = AES256CryptoManager()
        
        isEncrypting = true
        
        do {
            let result = try await cryptoManager.encrypt(
                plaintext: userText,
                parameters: encryptionParameters
            )
            
            let newMessage = Message(
                timestamp: Date(),
                plainText: userText,
                resultText: result,
                encryptionMode: currentMode
            )
            
            messages.append(newMessage)
        } catch {
            let cryptoError = error as? CryptoError
            errorMessage = cryptoError?.errorDescription ?? CryptoError.unknown.errorDescription
            showErrorAlert = true
        }
    }
    
    @MainActor private func decrypt() async {
        defer {
            isEncrypting = false
            currentTask?.cancel()
        }
        
        let userText = text
        text = ""
        
        let cryptoManager = AES256CryptoManager()
        let password = encryptionParameters.password
        let voidIndex = encryptionParameters.voidIndex
        
        isEncrypting = true
        
        do {
            let result = try await cryptoManager.decrypt(
                ciphertext: userText,
                password: password,
                voidIndex: voidIndex
            )
            
            let newMessage = Message(
                timestamp: Date(),
                plainText: userText,
                resultText: result,
                encryptionMode: currentMode
            )
            
            messages.append(newMessage)
        } catch {
            let cryptoError = error as? CryptoError
            errorMessage = cryptoError?.errorDescription ?? CryptoError.unknown.errorDescription
            showErrorAlert = true
        }
    }
}
