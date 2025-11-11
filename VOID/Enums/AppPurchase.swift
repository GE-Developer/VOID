//
//  AppPurchase.swift
//  VOID
//
//  Created by GE-Developer
//

enum AppPurchase: CaseIterable {
    case lifetime
    case monthly
    case annual
    
    var id: String {
        switch self {
        case .lifetime: return Plist.get(.lifetimeProduct)
        case .monthly: return Plist.get(.monthlyProduct)
        case .annual: return Plist.get(.annualProduct)
        }
    }
    
    static var subscriptionIDs: [String] {
        [self.monthly.id, self.annual.id]
    }
    
    
    static var inAppPurchaseIDs: [String] {
        [self.lifetime.id]
    }
}
