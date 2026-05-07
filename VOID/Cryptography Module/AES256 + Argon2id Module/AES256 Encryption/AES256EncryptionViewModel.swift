//
//  AES256EncryptionViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation
import UniformTypeIdentifiers

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
        isTimerEnabled: false
    )

    @Published var text = ""
    @Published var showErrorAlert = false
    @Published var currentMode: CryptoAction = .encrypt

    @Published private(set) var items: [ChatItem] = []
    @Published private(set) var selectedFileURL: URL?
    @Published private(set) var selectedFileName: String?
    @Published private(set) var selectedFileSize: UInt64?
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

    var hasSelectedFile: Bool { selectedFileURL != nil }

    private(set) var errorMessage = ""

    private var currentTask: Task<Void, Never>?
    private var hasSecurityScope = false

    let title = L10n("Cryptography.AES-256")
    let encryptionTitle = L10n("Cryptography.encryption")
    let decryptionTitle = L10n("Cryptography.decryption")
    let headetText = L10n("Cryptography.AES-256.instructions")
    let errorTitle = L10n("Error.title")
    let okTitle = "OK"

    private let soundManager = SoundManager.shared
    private let hapticsManager = HapticsManager.shared

    private static let workDirectory: URL = FileManager.default.temporaryDirectory
        .appendingPathComponent("AES256Files", isDirectory: true)

    init() {
        Self.resetWorkDirectory()
    }

    deinit {
        currentTask?.cancel()
        if hasSecurityScope, let url = selectedFileURL {
            url.stopAccessingSecurityScopedResource()
        }
        try? FileManager.default.removeItem(at: Self.workDirectory)
    }

    private static func resetWorkDirectory() {
        try? FileManager.default.removeItem(at: workDirectory)
        try? FileManager.default.createDirectory(at: workDirectory, withIntermediateDirectories: true)
    }

    func startCryptoProcess() {
        hapticsManager.impact(style: .medium)
        currentTask?.cancel()

        let isFile = selectedFileURL != nil

        switch (currentMode, isFile) {
        case (.encrypt, false): currentTask = Task { await encrypt() }
        case (.decrypt, false): currentTask = Task { await decrypt() }
        case (.encrypt, true):  currentTask = Task { await encryptFile() }
        case (.decrypt, true):  currentTask = Task { await decryptFile() }
        }
    }

    func selectFile(_ url: URL) {
        clearSelectedFile()

        if url.startAccessingSecurityScopedResource() {
            hasSecurityScope = true
        }

        let size = (try? FileManager.default.attributesOfItem(atPath: url.path)[.size] as? NSNumber)?.uint64Value

        selectedFileURL = url
        selectedFileName = url.lastPathComponent
        selectedFileSize = size
    }

    func clearSelectedFile() {
        if hasSecurityScope, let url = selectedFileURL {
            url.stopAccessingSecurityScopedResource()
        }
        hasSecurityScope = false
        selectedFileURL = nil
        selectedFileName = nil
        selectedFileSize = nil
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

            items.append(.text(newMessage))
            soundManager.playSound(.newEncryptedMessage)
            hapticsManager.notification(type: .success)
        } catch {
            handleError(error)
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

            items.append(.text(newMessage))
            soundManager.playSound(.newDecryptedMessage)
            hapticsManager.notification(type: .success)
        } catch {
            handleError(error)
        }
    }

    @MainActor
    private func encryptFile() async {
        guard let inputURL = selectedFileURL else { return }

        defer {
            isEncrypting = false
            currentTask?.cancel()
        }

        let fileManager = AES256FileCryptoManager()

        isEncrypting = true

        let outputURL = Self.workDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("void")

        do {
            let mimeType = UTType(filenameExtension: inputURL.pathExtension)?.identifier ?? "public.data"

            try await fileManager.encrypt(
                inputURL: inputURL,
                outputURL: outputURL,
                parameters: encryptionParameters,
                mimeType: mimeType,
                progress: { _ in }
            )

            let size = (try? FileManager.default.attributesOfItem(atPath: outputURL.path)[.size] as? NSNumber)?.uint64Value ?? 0

            let fileMessage = FileMessage(
                originalFileName: outputURL.lastPathComponent,
                fileSize: size,
                fileURL: outputURL,
                encryptionMode: .encrypt
            )

            items.append(.file(fileMessage))
            clearSelectedFile()
            soundManager.playSound(.newEncryptedMessage)
            hapticsManager.notification(type: .success)
        } catch {
            try? FileManager.default.removeItem(at: outputURL)
            handleError(error)
        }
    }

    @MainActor
    private func decryptFile() async {
        guard let inputURL = selectedFileURL else { return }

        defer {
            isEncrypting = false
            currentTask?.cancel()
        }

        guard inputURL.pathExtension.lowercased() == "void" else {
            handleError(CryptoError.unsupportedFileExtension)
            return
        }

        let fileManager = AES256FileCryptoManager()
        let password = encryptionParameters.password
        let voidIndex = encryptionParameters.voidIndex

        isEncrypting = true

        let outputDir = Self.workDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

            let resultURL = try await fileManager.decrypt(
                inputURL: inputURL,
                outputDirectoryURL: outputDir,
                password: password,
                voidIndex: voidIndex,
                progress: { _ in }
            )

            let size = (try? FileManager.default.attributesOfItem(atPath: resultURL.path)[.size] as? NSNumber)?.uint64Value ?? 0

            let fileMessage = FileMessage(
                originalFileName: resultURL.lastPathComponent,
                fileSize: size,
                fileURL: resultURL,
                encryptionMode: .decrypt
            )

            items.append(.file(fileMessage))
            clearSelectedFile()
            soundManager.playSound(.newDecryptedMessage)
            hapticsManager.notification(type: .success)
        } catch {
            try? FileManager.default.removeItem(at: outputDir)
            handleError(error)
        }
    }

    @MainActor
    private func handleError(_ error: Error) {
        let cryptoError = error as? CryptoError
        errorMessage = cryptoError?.errorDescription ?? CryptoError.unknown.errorDescription

        showErrorAlert = true

        soundManager.playSound(.errorAlert)
        hapticsManager.notification(type: .error)
    }
}
