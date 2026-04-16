//
//  QRErrorCorrection.swift
//  VOID
//
//  Created by GE-Developer
//

import QRCode

enum QRErrorCorrection: String, CaseIterable, Codable {
    case low
    case medium
    case quartile
    case high

    var qrCodeLevel: QRCode.ErrorCorrection {
        switch self {
        case .low: .low
        case .medium: .medium
        case .quartile: .quantize
        case .high: .high
        }
    }
    
    var name: String {
        switch self {
        case .low:
            L10n("QR.ErrorCorrection.low")
        case .medium:
            L10n("QR.ErrorCorrection.medium")
        case .quartile:
            L10n("QR.ErrorCorrection.quartile")
        case .high:
            L10n("QR.ErrorCorrection.high")
        }
    }
    
    static var title: String { L10n("QR.ErrorCorrection.title") }
}
