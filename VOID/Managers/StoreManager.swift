//
//  StoreManager.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation
import StoreKit

enum AppPurchase: CaseIterable {
    case lifetime
    case monthly
    case annual
    
    var id: String {
        switch self {
        case .lifetime: return "premium.lifetime"
        case .monthly: return "premium.monthly"
        case .annual: return "premium.annual"
        }
    }
    
    static var subscriptionIDs: [String] {
        [self.monthly.id, self.annual.id]
    }
    
    
    static var inAppPurchaseIDs: [String] {
        [self.lifetime.id]
    }
}







@MainActor
final class StoreManager: ObservableObject {
    var isPremium: Bool {
        devTest || isSubscribed || isPurchased
    }
    
    @Published var devTest: Bool
    
    var isSubscribed: Bool {
        purchasedProductIDs.contains { AppPurchase.subscriptionIDs.contains($0) }
    }
    
    var isPurchased: Bool {
        purchasedProductIDs.contains { AppPurchase.inAppPurchaseIDs.contains($0) }
    }

    
    @Published private(set) var purchasedProductIDs: Set<String> = []
    
    private var updates: Task<Void, Never>? = nil
    

    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transactions) = result else { continue }
            
            if transactions.revocationDate == nil {
                purchasedProductIDs.insert(transactions.productID)
            } else {
                purchasedProductIDs.remove(transactions.productID)
            }
        }
    }
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await updatePurchasedProducts()
            }
        }
    }
    
    
    
    func restorePurchases() async throws {
        try await AppStore.sync()
    }
    

    
    
    
    init() {
        devTest = UserDefaults.standard.bool(forKey: AppStorageKey.devTest.key)
        
        Task {
        
            await updatePurchasedProducts()
            
        }
        
        updates = observeTransactionUpdates()
//        chosenProduct = subscriptions.first
    }
    
    deinit {
        updates?.cancel()
    }
}
