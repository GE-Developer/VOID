//
//  QRCodeGeneratorViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation
import CoreGraphics

final class QRCodeGeneratorViewModel: ObservableObject {
    enum FieldType {
        case url
        case ssid
        case ssidPassword
        case name
        case phone
        case email
        case subject

        var limit: Int {
            switch self {
            case .url: 500
            case .ssid: 32
            case .ssidPassword: 63
            case .name: 25
            case .phone: 16
            case .email: 30
            case .subject: 20
            }
        }
    }
    
    enum URLScheme: String, CaseIterable {
        case https = "https://"
        case http  = "http://"
        case ftp   = "ftp://"
    }

    enum WifiEncryption: String, CaseIterable {
        case wpa  = "WPA/WPA2"
        case wep  = "WEP"
        case open = "N/A"
    }
    
    @Published var selectedErrorCorrection: QRErrorCorrection = .high {
        didSet {
            text = trimToByteLimit(text)
            emailBody = trimToByteLimit(emailBody)
            smsMessage = trimToByteLimit(smsMessage)
        }
    }
    @Published var selectedDataType: QRDataType = .plainText

    @Published var text = ""
    @Published var selectedURLScheme: URLScheme = .http
    @Published var url = ""
    @Published var wifiSSID = ""
    @Published var wifiPassword = ""
    @Published var wifiEncryption: WifiEncryption = .wpa
    @Published var contactName = ""
    @Published var contactPhone = ""
    @Published var contactEmail = ""
    @Published var emailAddress = ""
    @Published var emailSubject = ""
    @Published var emailBody = ""
    @Published var phoneNumber = ""
    @Published var smsNumber = ""
    @Published var smsMessage = ""

    @Published private(set) var qrImage: CGImage?

    @MainActor
    func generate() async {
        guard !stringResult.isEmpty else {
            qrImage = nil
            return
        }
        var config = QRCodeConfiguration()
        config.errorCorrection = selectedErrorCorrection
        do {
            qrImage = try await QRCodeGeneratorManager.generateQRCode(
                from: stringResult,
                configuration: config
            )
            print("generate")
        } catch {
            print("QR generation failed: \(error)")
            qrImage = nil
        }
    }
    
    var payloadDescription: String {
        print("payloadDescription")
        return "\(payloadProgress) / \(selectedErrorCorrection.byteLimit)"
    }
    
    var disabledErrorCorrectionLevels: Set<QRErrorCorrection> {
        print("disabledErrorCorrectionLevels")
        let progress = payloadProgress
        return Set(QRErrorCorrection.allCases.filter { progress > $0.byteLimit })
    }
    
    var stringResult: String {
        print("stringResult")
        return QRCodeGeneratorManager.formatPayload(
            type: selectedDataType,
            text: text,
            url: selectedURLScheme.rawValue + url,
            wifiSSID: wifiSSID,
            wifiPassword: wifiPassword,
            wifiEncryption: wifiEncryption.rawValue,
            contactName: contactName,
            contactPhone: contactPhone,
            contactEmail: contactEmail,
            emailAddress: emailAddress,
            emailSubject: emailSubject,
            emailBody: emailBody,
            phoneNumber: phoneNumber,
            smsNumber: smsNumber,
            smsMessage: smsMessage,
            latitude: "",
            longitude: ""
        )
    }
    
    private var payloadProgress: Int {
        print("payloadProgress")
        switch selectedDataType {
        case .plainText: return text.utf8.count
        case .email:     return emailBody.utf8.count
        case .sms:       return smsMessage.utf8.count
        default:         return 0
        }
    }
    
    let urlSchemeOptions = URLScheme.allCases.map(\.rawValue)
    let wifiEncryptionOptions = WifiEncryption.allCases.map(\.rawValue)
    
    let title = L10n("QRCode.title")
    let errorCorrectionTitle = QRErrorCorrection.title
    let dataTypeTitle = QRDataType.title
    
    let errorTitle = L10n("Error.title")
    let okTitle = "OK"
    
    let textPlaceholder = L10n("QRCode.Placeholder.text")
    let urlPlaceholder = "example.com"
    let wifiSSIDPlaceholder = L10n("QRCode.Placeholder.ssid")
    let passwordPlaceholder = L10n("QRCode.Placeholder.password")
    let namePlaceholder = L10n("QRCode.Placeholder.name")
    let phonePlaceholder = "+1 234 567 890"
    let emailPlaceholder = "user@gmail.com"
    let subjectPlaceholder = L10n("QRCode.Placeholder.subject")
    let messagePlaceholder = L10n("QRCode.Placeholder.message")
    let smsInputHeader = L10n("QRCode.Input.sms")

    func isEmailValid(_ value: String) -> Bool {
        Validator.isValid(value, type: .email)
    }
    
    func isPhoneValid(_ value: String) -> Bool {
        Validator.isValid(value, type: .phone)
    }
    
    func isUrlValid(_ value: String)   -> Bool {
        Validator.isValid(value, type: .url)
    }
    
    func counter(_ value: String, for fieldType: FieldType) -> String {
        "\(value.count) / \(fieldType.limit)"
    }
    
    func trimToByteLimit(_ text: String) -> String {
        guard text.utf8.count > selectedErrorCorrection.byteLimit else { return text }

        var result = text
        while result.utf8.count > selectedErrorCorrection.byteLimit && !result.isEmpty {
            result.removeLast()
        }
        return result
    }

    func sanitize(text: String, fieldType: FieldType) -> String {
        switch fieldType {
        case .url:
            let cleaned = text.lowercased().filter { $0.isASCII && !$0.isWhitespace }
            return String(cleaned.prefix(fieldType.limit))
        case .ssid, .ssidPassword, .name, .subject:
            let cleaned = text.filter { !$0.isNewline }
            return String(cleaned.prefix(fieldType.limit))
        case .phone:
            let allowed: Set<Character> = Set("0123456789+")
            let cleaned = text.filter { allowed.contains($0) }
            return String(cleaned.prefix(fieldType.limit))
        case .email:
            let allowed: Set<Character> = Set("abcdefghijklmnopqrstuvwxyz0123456789@._%+-")
            let cleaned = text.lowercased().filter { allowed.contains($0) }
            return String(cleaned.prefix(fieldType.limit))
        }
    }
}






//    // MARK: UI constants
//
//    let title = L10n("QRCode.title")
//    let errorTitle = L10n("Error.title")
//    let okTitle = "OK"
//
//    let customizationButtonTitle = L10n("QRCode.Customization.button")
//    let customizationButtonIcon = "paintbrush"
//
//    let addPresetButtonTitle = L10n("QRCode.Preset.add")
//    let addPresetButtonIcon = "plus"
//    let presetsSectionHeader = L10n("QRCode.Preset.listHeader")
//    let deletePresetTitle = L10n("QRCode.Preset.delete")
//
//    let urlInputHeader = L10n("QRCode.Input.url")
//    let wifiInputHeader = L10n("QRCode.Input.wifi")
//    let contactInputHeader = L10n("QRCode.Input.contact")
//    let emailInputHeader = L10n("QRCode.Input.email")
//    let phoneInputHeader = L10n("QRCode.Input.phone")
//    let smsInputHeader = L10n("QRCode.Input.sms")
//    let locationInputHeader = L10n("QRCode.Input.location")
//
//    let textPlaceholder = L10n("QRCode.Placeholder.text")
//    let urlPlaceholder = "example.com"
//    let ssidPlaceholder = L10n("QRCode.Placeholder.ssid")
//    let passwordPlaceholder = L10n("QRCode.Placeholder.password")
//    let namePlaceholder = L10n("QRCode.Placeholder.name")

//    let subjectPlaceholder = L10n("QRCode.Placeholder.subject")
//    let messagePlaceholder = L10n("QRCode.Placeholder.message")
//
//    let wifiEncryptionTitle = L10n("QRCode.Placeholder.encryption")
