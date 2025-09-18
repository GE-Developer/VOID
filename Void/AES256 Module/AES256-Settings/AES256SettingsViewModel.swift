//
//  AES256SettingsViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation
 
@MainActor
final class AES256SettingsViewModel: ObservableObject {
    @Published var parameters: AES256Parameters
    
    let title = L10n("Settings.title")
    let subTitle: String
    
    let secutityTitle = L10n("CryptoSettings.Security.title")
    let passwordPlaceholder = L10n("CryptoSettings.Security.passwordPlaceholder")
    let voidTitle = L10n("CryptoSettings.Security.Void.title")
    let voidSubtitle = L10n("CryptoSettings.Security.Void.subtitle")
    
    let dividerMessage = L10n("CryptoSettings.dividerMessage")
    
    let saltTitle = L10n("CryptoSettings.Salt.title")
    let saltValues = [8, 16, 32, 64, 128, 256]
    let saltInstructions = L10n("CryptoSettings.Salt.instructions")
    
    let iterationsTitle = L10n("CryptoSettings.Iterations.title")
    let iterationsValues = Array<UInt16>(1...1000)
    let iterationsLabels = [
        L10n("CryptoSettings.weak"),
        L10n("CryptoSettings.medium"),
        L10n("CryptoSettings.strong"),
        L10n("CryptoSettings.extreme")
    ]
    let iterationsInstructions = L10n("CryptoSettings.Iterations.instructions")
    
    let memoryTitle = L10n("CryptoSettings.Memory.title")
    let memoryValues: [UInt32] = [1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288, 1048576]
    let memoryLabels = [
        L10n("CryptoSettings.weak"),
        L10n("CryptoSettings.strong"),
        L10n("CryptoSettings.max")
    ]
    let memoryInstructions = L10n("CryptoSettings.Memory.instructions")
    
    let parallelismTitle = L10n("CryptoSettings.Parallelism.title")
    let parallelismLabels = [
        L10n("CryptoSettings.lowCPU"),
        L10n("CryptoSettings.highCPU")
    ]
    
    let keyLengthTitle = L10n("CryptoSettings.KeyLength.title")
    let keyLengthValues: [UInt8] = [32, 64, 96, 128, 160, 192, 224]
    let keyLengthInstructions = L10n("CryptoSettings.KeyLength.instructions")

    let layersTitle = L10n("CryptoSettings.Layers.title")
    let layersSubtitle = L10n("CryptoSettings.Layers.subtitle")
    let layersInstructions = L10n("CryptoSettings.Layers.instructions")

    let timerTitle = L10n("CryptoSettings.Timer.title")
    let timerSubtitle = L10n("CryptoSettings.Timer.subtitle")
    let timerInstuctions = L10n("CryptoSettings.Timer.instuctions")
    
    var saltDescription: String {
        "\(parameters.salt) B"
    }
    
    var saltLabels: [String] {
        saltValues.map { "\($0)" }
    }
    
    var memoryDescription: String {
        "\(parameters.memory / 1024) MiB"
    }
    
    var parallelismValues: [UInt8] {
        (1...processor.activeProcessorCount).compactMap { UInt8($0) }
    }
    
    var parallelismInstructions: String {
        L10n("CryptoSettings.Parallelism.instructions \(processor.processorCount)")
    }
    
    var keyLengthDescription: String {
        "\(parameters.keyLength) B"
    }
    
    var keyLenghtLabels: [String] {
        keyLengthValues.map { String(Int($0)) }
    }
    
    var layersRange: ClosedRange<UInt8> {
        1...parameters.keyLength / 32
    }
    
    private let mainVM: AES256EncryptionViewModel
    
    private let processor = ProcessInfo.processInfo
    
    init(mainVM: AES256EncryptionViewModel) {
        self.mainVM = mainVM
        self.parameters = mainVM.encryptionParameters
        self.subTitle = mainVM.title
        print("AES256SettingsViewModel INIT")
    }
    
    deinit {
        print("AES256SettingsViewModel DEINIT")
    }
    
    func commitChanges() {
        mainVM.encryptionParameters = parameters
    }
}
