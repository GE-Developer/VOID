//
//  PayWallViewModel.swift
//  VOID
//
//  Created by Mikhail Bukhrashvili on 01.11.25.
//

import StoreKit
import Foundation

@MainActor
final class PayWallViewModel: ObservableObject {
    @Published private(set) var inAppPurchases: [Product] = []
    @Published private(set) var subscriptions: [Product] = []
    
    @Published var chosenProduct: Product?
    
    private var productsLoaded = false
    
    private unowned let store: StoreManager
    
    var purchaseButtonDisabled: Bool {
        chosenProduct == nil
    }
    
    let title = "Premium Features"
    
    var subtitle: String {
        let purchaseIDs = store.purchasedProductIDs
        
        if store.devTest {
            return "No products are in developer mode"
        }
        
        if purchaseIDs.contains(AppPurchase.lifetime.id) {
            return "You have unlimited access!"
        }
        
        if purchaseIDs.contains(AppPurchase.annual.id) {
            return "You already use annual subscription."
        }
        
        if purchaseIDs.contains(AppPurchase.halfyear.id) {
            return "You have 6 months subscription. You always can upgrade."
        }
        
        if purchaseIDs.contains(AppPurchase.monthly.id) {
            return "You have monthly subscription. You can apgrade."
        }
    
        return "Choose your plan to enjoy unlimited access to all features."
    }
    
    var warningText: String? {
        guard store.isPurchased && store.isSubscribed else { return nil }
        return "Выключите"
    }
    
    let termsOfUse = L10n("Settings.AboutApp.TermsOfUse.title")
    let privacyPolicy = L10n("Settings.AboutApp.PrivacyPolicy.title")
    let continueTitle = "Purchase"
    let premiumShareText = "Premium Share"
    
    
    init(store: StoreManager) {
        self.store = store
        print("🟢 PayWallViewModel init")
        
        Task {
            try await loadProducts()
        }
    }
    
    deinit {
        print("🔴 PayWallViewModel deinit")
    }
    

    
    func name(for product: Product) -> String {
        let appProduct = AppPurchase.allCases.first { $0.id == product.id }
        
        guard let appProduct else { return product.displayName }
        
        switch appProduct {
        case .lifetime: return "Life Time"
        case .monthly: return "1 Month"
        case .halfyear: return "6 Months"
        case .annual: return "1 Year"
        }
    }
    
    func description(for product: Product) -> String {
        let appProduct = AppPurchase.allCases.first { $0.id == product.id }
        
        guard let appProduct else { return product.displayName }
        
        switch appProduct {
        case .lifetime: return "Lifetime full access"
        case .monthly: return "1 Month ulimited access with 3 day trial period"
        case .halfyear: return "6 Months unlimited using"
        case .annual: return "1 Year of unlimited use with family sharing"
        }
    }
    
    
    
    
    // MARK: - Загрузка продуктов
    func loadProducts() async throws {
        guard !productsLoaded else { return }
        
        let fetchedSubscriptions = try await Product.products(for: AppPurchase.subscriptionIDs)
        inAppPurchases = try await Product.products(for: AppPurchase.inAppPurchaseIDs)
        
        subscriptions = AppPurchase.subscriptionIDs.compactMap { id in
            fetchedSubscriptions.first(where: { $0.id == id })
        }
        
        productsLoaded = true
    }
    
    // MARK: - Покупка продуктов
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await store.updatePurchasedProducts()
            chosenProduct = nil
        case let .success(.unverified(_, error)):
            break
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }
}
