//
//  Gradient + Ext.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

extension Gradient {
    static var accent: LinearGradient {
        AccentColorManager.shared.currentColor.gradient
    }
    
    static let gray = LinearGradient(
        colors: [.void.grayLight, .void.grayDark],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let gold = LinearGradient(
        colors: [.void.goldLight, .void.goldDark],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let green = LinearGradient(
        colors: [.void.greenLight, .void.greenDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let red = LinearGradient(
        colors: [.void.errorRed, .void.errorRed],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
