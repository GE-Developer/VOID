//
//  Gradient + Extension.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

extension Gradient {
    static let accentGragient = LinearGradient(
        colors: [.navigation.accentOne, .navigation.accentTwo],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let basicSubscriptionGradiaent = LinearGradient(
        colors: [.subscription.basicOne, .subscription.basicTwo],
        startPoint: .bottomTrailing,
        endPoint: .topLeading
    )
    
    static let premiumSubscriptionGradiaent = LinearGradient(
        colors: [.subscription.premiumOne, .subscription.premiumTwo],
        startPoint: .leading,
        endPoint: .trailing
    )
}
