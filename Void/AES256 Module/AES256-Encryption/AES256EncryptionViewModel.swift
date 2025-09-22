//
//  AES256EncryptionViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

@MainActor
final class AES256EncryptionViewModel: ObservableObject {
    @Published var encryptionParameters = AES256Parameters(
        password: "вв",
        voidIndex: 3000,
        salt: 8,
        iterations: 1,
        memory: 1024 * 1,
        parallelism: 1,
        keyLength: 32,
        layers: 1,
        selectedHours: 0,
        selectedMinutes: 5,
        dateInactive: true
    )
    
    @Published private(set) var messages: [Message] = []
    
    var placeholder: String {
        guard encryptionParameters.password != "" else {
            return L10n("Cryptography.Placeholder.default")
        }
        switch currentMode {
        case .encrypt: return L10n("Cryptography.Placeholder.encrypt")
        case .decrypt: return L10n("Cryptography.Placeholder.decrypt")
        }
    }
    
    let title = L10n("Cryptography.AES-256")
    let encryptionTitle = L10n("Cryptography.encryption")
    let decryptionTitle = L10n("Cryptography.decryption")
    
    let headetText = L10n("Cryptography.AES-256.instructions")
    
    @Published var text = ""
    
    @Published var currentMode: CryptoAction = .encrypt
    
    @Published private(set) var isEncrypting = false
    
    private var currentTask: Task<Void, Never>?
    
    func encrypt() async {
        currentTask?.cancel()
        currentTask = Task { [weak self] in
            guard let self else { return }
            do {

                let userText = text
                await MainActor.run { self.text = "" }

                
                let result = try  CryptoService().encrypt(
                    plaintext: userText,
                    parameters: encryptionParameters
                )
                
                await MainActor.run {
                    self.messages.append(Message(
                        timestamp: Date(),
                        originalText: userText,
                        encryptedText: result,
                        encryptionMode: self.currentMode
                    ))
                }
            } catch {
                let cryptoError = error as? CryptoError
                print(cryptoError?.errorDescription ?? CryptoError.unknown.errorDescription)
            }
        }
    }
    
    func decrypt() async {
        let userText = text
        text = ""
        guard !userText.isEmpty else { return }
        isEncrypting = true

        do {
            print("do")
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
    }
}
