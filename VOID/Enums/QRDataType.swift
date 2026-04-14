//
//  QRDataType.swift
//  VOID
//
//  Created by GE-Developer
//

enum QRDataType: String, CaseIterable, Identifiable {
    case plainText
    case url
    case wifi
    case contact
    case email
    case phone
    case sms
    case location

    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .plainText:
            L10n("QR.DataType.plainText")
        case .url:
            L10n("QR.DataType.url")
        case .wifi:
            L10n("QR.DataType.wifi")
        case .contact:
            L10n("QR.DataType.contact")
        case .email:
            L10n("QR.DataType.email")
        case .phone:
            L10n("QR.DataType.phone")
        case .sms:
            L10n("QR.DataType.sms")
        case .location:
            L10n("QR.DataType.location")
        }
    }
    
    static var title: String { L10n("QR.DataType.title") }
}
