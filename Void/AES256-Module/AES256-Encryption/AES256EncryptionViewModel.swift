//
//  AES256EncryptionViewModel.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 28.07.25.
//

import Foundation
//import Combine

struct AES256Parameters {
    var password: String
    var salt: Int
    var iterations: UInt16 
    var memory: UInt32
    var parallelism: UInt8
    var keyLength: UInt8
    var layers: UInt8
    var selectedHours: Int
    var selectedMinutes: Int
    var dateInactive: Bool
    
    var duration: UInt64 {
        let timeInterval = TimeInterval((selectedHours * 60 + selectedMinutes) * 60)
        return UInt64(
            self.dateInactive
            ? 0
            : (Date().timeIntervalSince1970 + timeInterval)
        )
    }
    
    var actualLayers: UInt8 {
        min(layers, keyLength / 32)
    }
}

struct Message: Identifiable {
    let id = UUID()
    let timestamp: Date
    let originalText: String
    let resultText: String
    let encryptionMode: CryptoAction
}

@MainActor
final class AES256EncryptionViewModel: ObservableObject {
    @Published var encryptionParameters = AES256Parameters(
        password: "",
        salt: 128,
        iterations: 20,
        memory: 1024 * 4,
        parallelism: 3,
        keyLength: 64,
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
    
    let title = L10n("Cryptography.title")
    let subtitle = L10n("Cryptography.AES-256")
    let encryptionTitle = L10n("Cryptography.encryption")
    let decryptionTitle = L10n("Cryptography.decryption")
    
    @Published var text = ""
    @Published var resultText = ""
    
    @Published var currentMode: CryptoAction = .encrypt
    
    @Published private(set) var isEncrypting = false
    
    private var currentTask: Task<Void, Never>?
    
    func encrypt() {
        currentTask?.cancel()
        currentTask = Task { [weak self] in
            guard let self else { return }
            do {
                let passwordManager = PasswordManager()
                let combinedPassword = passwordManager.combinedSecret(password: encryptionParameters.password, voidIndex: 3000)

                let userText = text
                await MainActor.run { self.text = "" }

                let result = try await EncryptionService().encrypt(
                    plaintext: Data(userText.utf8),
                    password: combinedPassword,
                    saltLength: self.encryptionParameters.salt,
                    iterations: self.encryptionParameters.iterations,
                    memoryKiB: self.encryptionParameters.memory,
                    parallelism: self.encryptionParameters.parallelism,
                    keyLength: self.encryptionParameters.keyLength,
                    layers: self.encryptionParameters.actualLayers,
                    expirationTimestamp: self.encryptionParameters.duration
                )

                await MainActor.run {
                    self.resultText = result
                    self.messages.append(Message(
                        timestamp: Date(),
                        originalText: userText,
                        resultText: result,
                        encryptionMode: self.currentMode
                    ))
                }
            } catch {
                await MainActor.run {
                    self.resultText = "Ошибка: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func decrypt() async {
        let passwordManager = PasswordManager()
        let combinedPassword = passwordManager.combinedSecret(password: encryptionParameters.password, voidIndex: 3000)
        
        let userText = text
        text = ""
        let encryptionService = EncryptionService()
        guard !userText.isEmpty else { return }
        isEncrypting = true

        do {
            print("do")
            let result = try await Task.detached(priority: .userInitiated) {
                let decryptedData = try await encryptionService.decrypt(userText, password: combinedPassword)
                guard let string = String(data: decryptedData, encoding: .utf8) else {
                    throw NSError(domain: "DecodeError", code: -1)
                }
                return string
            }.value
            
            resultText = result
            let message = Message(
                timestamp: Date(),
                originalText: userText,
                resultText: resultText,
                encryptionMode: currentMode
            )
            messages.append(message)

        } catch {
            resultText = "Ошибка: \(error.localizedDescription)"
        }

        isEncrypting = false
    }
    
    func printThat() {
        print("+++")
        print(encryptionParameters)
        print("+++")
    }
    
    deinit {
        currentTask?.cancel()
        print("DEINIT - AES256EncryptionViewModel")
    }
}
