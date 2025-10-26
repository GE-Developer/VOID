//
//  Gradient + Ext.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

extension Gradient {
    static let accent = LinearGradient(
        colors: [.void.accentLight, .void.accentDark],
        startPoint: .leading,
        endPoint: .trailing
    )
    
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
}
