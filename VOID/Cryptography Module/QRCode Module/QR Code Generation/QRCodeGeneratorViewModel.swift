//
//  QRCodeGeneratorViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation
import CoreGraphics
import CoreLocation
import ImageIO

@Observable
final class QRCodeGeneratorViewModel {
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

    var selectedErrorCorrection: QRErrorCorrection = .high {
        didSet {
            text = trimToByteLimit(text)
            emailBody = trimToByteLimit(emailBody)
            smsMessage = trimToByteLimit(smsMessage)
            configuration.errorCorrection = selectedErrorCorrection
            if selectedErrorCorrection != .high {
                clearLogo()
            }
        }
    }

    var selectedDataType: QRDataType = .plainText

    @ObservationIgnored var configuration = QRCodeConfiguration() {
        didSet {
            regenerateTask?.cancel()
            regenerateTask = Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(600))
                guard !Task.isCancelled else { return }
                await generate()
            }
        }
    }

    private(set) var hasLogo: Bool = false

    var text = ""
    var selectedURLScheme: URLScheme = .http
    var url = ""
    var wifiSSID = ""
    var wifiPassword = ""
    var wifiEncryption: WifiEncryption = .wpa
    var contactName = ""
    var contactPhone = ""
    var contactEmail = ""
    var emailAddress = ""
    var emailSubject = ""
    var emailBody = ""
    var phoneNumber = ""
    var smsNumber = ""
    var smsMessage = ""
    var selectedCoordinate: CLLocationCoordinate2D?

    var latitudeString: String {
        selectedCoordinate.map { String(format: "%.6f", $0.latitude) } ?? ""
    }

    var longitudeString: String {
        selectedCoordinate.map { String(format: "%.6f", $0.longitude) } ?? ""
    }

    var coordinateDescription: String {
        guard selectedCoordinate != nil else { return "" }
        return "\(latitudeString), \(longitudeString)"
    }
    
    var payloadDescription: String {
        "\(payloadProgress) / \(selectedErrorCorrection.byteLimit) B"
    }

    var isQRCodeReady: Bool {
        qrImage != nil && !generationFailed
    }

    var canAddLogo: Bool {
        selectedErrorCorrection == .high
    }

    var payloadFraction: Double {
        Double(payloadProgress) / Double(selectedErrorCorrection.byteLimit)
    }

    var disabledErrorCorrectionLevels: Set<QRErrorCorrection> {
        let progress = payloadProgress
        return Set(QRErrorCorrection.allCases.filter { progress > $0.byteLimit })
    }

    var stringResult: String {
        QRCodeGeneratorManager.formatPayload(
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
            latitude: latitudeString,
            longitude: longitudeString
        )
    }
    
    private(set) var qrImage: CGImage?
    private(set) var generationFailed = false
    private(set) var qrQuality: QRScanQuality = .good

    private var payloadProgress: Int {
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
    let errorDescription = L10n("Error.qrGenerationFailed")
    let logoAlertTitle = L10n("QRCode.Logo.alertTitle")
    let logoAlertMessage = L10n("QRCode.Logo.alertMessage")
    let inputDataTitle = L10n("QRCode.InputData.title")
    let payloadTitle = L10n("QRCode.Payload.title")
    
    let textPlaceholder = L10n("QRCode.Placeholder.text")
    let urlPlaceholder = "example.com"
    let wifiSSIDPlaceholder = L10n("QRCode.Placeholder.ssid")
    let passwordPlaceholder = L10n("QRCode.Placeholder.password")
    let namePlaceholder = L10n("QRCode.Placeholder.name")
    let phonePlaceholder = "+1 234 567 890"
    let emailPlaceholder = "user@gmail.com"
    let subjectPlaceholder = L10n("QRCode.Placeholder.subject")
    let messagePlaceholder = L10n("QRCode.Placeholder.message")
    
    @ObservationIgnored private var regenerateTask: Task<Void, Never>?
    @ObservationIgnored private var analysisTask: Task<Void, Never>?
    
    init() {
        configuration.errorCorrection = selectedErrorCorrection
    }

    @MainActor
    func generate() async {
        guard canGenerate() else {
            qrImage = nil
            generationFailed = false
            qrQuality = .good
            analysisTask?.cancel()
            return
        }

        generationFailed = false

        do {
            qrImage = try await QRCodeGeneratorManager.generateQRCode(
                from: stringResult,
                configuration: configuration
            )
            scheduleQualityAnalysis()
        } catch {
            qrImage = nil
            generationFailed = true
            qrQuality = .good
            analysisTask?.cancel()
        }
    }

    private func scheduleQualityAnalysis() {
        analysisTask?.cancel()
        guard let image = qrImage else { return }
        analysisTask = Task { @MainActor in
            let quality = await QRCodeAnalysisService.analyze(image)
            guard !Task.isCancelled else { return }
            qrQuality = quality
        }
    }

    func setLogo(from data: Data) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: 512
        ]

        guard
            let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
        else { return }

        configuration.style.logoImage = image
        hasLogo = true
    }

    func clearLogo() {
        guard configuration.style.logoImage != nil else { return }
        configuration.style.logoImage = nil
        hasLogo = false
    }

    func isEmailValid(_ value: String) -> Bool {
        value.isEmpty || Validator.isValid(value, type: .email)
    }

    func isPhoneValid(_ value: String) -> Bool {
        value.isEmpty || Validator.isValid(value, type: .phone)
    }

    func isUrlValid(_ value: String)   -> Bool {
        value.isEmpty || Validator.isValid(value, type: .url)
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

    private func canGenerate() -> Bool {
        switch selectedDataType {
        case .plainText:
            return !text.isEmpty
        case .url:
            return !url.isEmpty && isUrlValid(url)
        case .wifi:
            return wifiEncryption == .open
                ? !wifiSSID.isEmpty
                : !wifiSSID.isEmpty && !wifiPassword.isEmpty
        case .contact:
            let hasInput = !contactName.isEmpty
                || !contactPhone.isEmpty
                || !contactEmail.isEmpty
            return hasInput
                && isPhoneValid(contactPhone)
                && isEmailValid(contactEmail)
        case .email:
            return !emailAddress.isEmpty && isEmailValid(emailAddress)
        case .phone:
            return !phoneNumber.isEmpty && isPhoneValid(phoneNumber)
        case .sms:
            return !smsNumber.isEmpty && isPhoneValid(smsNumber)
        case .location:
            return selectedCoordinate != nil
        }
    }
}
