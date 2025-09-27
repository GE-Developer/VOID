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
    
    func startEncrypt() {
        isEncrypting = true
        currentTask?.cancel()
        currentTask = Task { await encrypt() }
    }
    
    func cancelTasks() {
        currentTask?.cancel()
        currentTask = nil
        isEncrypting = false
    }
    
    @MainActor
    func encrypt() async {
        isEncrypting = true
        
        defer {
            isEncrypting = false
        }
        
        let userText = text
        text = ""
        
        do {
            let result = try await CryptoService().encrypt(
                plaintext: userText,
                parameters: encryptionParameters
            )
            
            messages.append(
                Message(
                    timestamp: Date(),
                    originalText: userText,
                    encryptedText: result,
                    encryptionMode: currentMode
                )
            )
        } catch {
            let cryptoError = error as? CryptoError
            print(cryptoError?.errorDescription ?? CryptoError.unknown.errorDescription)
        }
    }
    
    func decrypt() async {
        let userText = text
        text = ""
        guard !userText.isEmpty else { return }
        isEncrypting = true

        do {
            let result = try await Task.detached(priority: .userInitiated) {
                
                let decryptedData = try await CryptoService().decrypt(
                    ciphertext: userText,
                    password: self.encryptionParameters.password,
                    voidIndex: self.encryptionParameters.voidIndex
                )
                
                return decryptedData
            }.value
            let message = Message(
                timestamp: Date(),
                originalText: result,
                encryptedText: userText,
                encryptionMode: currentMode
            )
            messages.append(message)
            
        } catch {
            let cryptoError = error as? CryptoError
            print(cryptoError?.errorDescription ?? CryptoError.unknown.errorDescription)
        }
        
        isEncrypting = false
    }
    
    deinit {
        currentTask?.cancel()
        currentTask = nil
        print("DEINIT")
    }
}
