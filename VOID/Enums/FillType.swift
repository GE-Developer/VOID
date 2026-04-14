//
//  QRFillType.swift
//  VOID
//
//  Created by GE-Developer
//

enum FillType: String, CaseIterable, Identifiable {
    case solid
    case linearGradient
    case radialGradient

    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .solid:
            L10n("FillType.solid")
        case .linearGradient:
            L10n("FillType.linearGradient")
        case .radialGradient:
            L10n("FillType.radialGradient")
        }
    }
}
