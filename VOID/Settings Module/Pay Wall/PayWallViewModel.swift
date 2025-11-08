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
    
    @Published private(set) var chosenProduct: Product?
    
    var subtitle: String {
        if isPurchased(.lifetime) || store.devTest {
            return "You own lifetime access"
        }
        
        if isPurchased(.annual) {
            return "Your annual plan is active"
        }
        
        if isPurchased(.monthly) {
            return "Monthly access enabled"
        }
    
        return "Choose your plan and explore everything VOID can do"
    }
    
    var purchaseButtonTitle: String {
        if isChosen(.lifetime) {
            return isPurchased(.lifetime) ? "Owned" : "Purchase"
        }
        
        if isChosen(.annual) {
            guard !isPurchased(.annual) else { return "Manage" }
            
            return isPurchased(.monthly) ? "Upgrade" : "Subscribe"
        }
        
        if isChosen(.monthly) {
            guard !isPurchased(.monthly) else { return "Manage" }
 
            return "Subscribe"
        }
        
        return "Purchase"
    }
    
    var purchaseButtonDisabled: Bool {
        chosenProduct == nil
    }
    
    var annualSaving: String? {
        guard
            let monthly = subscriptions.first(where: { $0.id == AppPurchase.monthly.id }),
            let annual = subscriptions.first(where: { $0.id == AppPurchase.annual.id })
        else {
            return nil
        }

        let monthlyPrice = monthly.price
        let annualPrice = annual.price

        let yearlyCostIfPaidMonthly = monthlyPrice * 12

        let savings = 1 - (annualPrice / yearlyCostIfPaidMonthly)
        var percent = savings * 100

        var roundedPercent = Decimal()
        NSDecimalRound(&roundedPercent, &percent, 0, .plain)

        return roundedPercent > 0 ? "\(roundedPercent)% SAVE" : nil
    }
    
    let title = "Premium Features"
    let termsOfUse = L10n("Settings.AboutApp.TermsOfUse.title")
    let privacyPolicy = L10n("Settings.AboutApp.PrivacyPolicy.title")
    
    let familyShareText = "Family Sharing"
    let trialPeriodText = "3 Days Free"
    
    private let haptic = HapticsManager.shared
    private unowned let store: StoreManager
    
    init(store: StoreManager) {
        self.store = store
        
        Task { try await loadProducts() }
    }
    
 
    
    
 
    
    var warningText: String? {
        guard store.isPurchased && store.isSubscribed else { return nil }
        return "Выключите"
    }

    


    private var productsLoaded = false
    
    func name(for product: Product) -> String {
        let appProduct = AppPurchase.allCases.first { $0.id == product.id }
        
        guard let appProduct else { return product.displayName }
        
        switch appProduct {
        case .lifetime: return "Lifetime"
        case .monthly: return "Monthly"
        case .annual: return "Annual"
        }
    }
    
    func loadProducts() async throws {
        guard !productsLoaded else { return }
        
        let fetchedSubscriptions = try await Product.products(for: AppPurchase.subscriptionIDs)
        inAppPurchases = try await Product.products(for: AppPurchase.inAppPurchaseIDs)
        
        subscriptions = AppPurchase.subscriptionIDs.compactMap { id in
            fetchedSubscriptions.first(where: { $0.id == id })
        }
        
        productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await store.updatePurchasedProducts()
            chosenProduct = nil
        case .success(.unverified(_, _)):
            break
        case .userCancelled:
            break
        case .pending:
            break
        @unknown default:
            break
        }
    }
    
    func description(for product: Product) -> String {
        let appProduct = AppPurchase.allCases.first { $0.id == product.id }
        
        guard let appProduct else { return product.displayName }
        
        switch appProduct {
        case .lifetime: return "One-time purchase"
        case .monthly: return "Every month"
        case .annual: return "Every year"
        }
    }
    
    func additionalPromo(for product: Product) async -> String? {
        guard let sub = product.subscription else { return nil }

        let eligible = await sub.isEligibleForIntroOffer
        guard eligible, let offer = sub.introductoryOffer else { return nil }

        let period = offer.period
        let days: Int
        switch period.unit {
        case .day: days = period.value
        case .week: days = period.value * 7
        case .month: days = period.value * 30
        case .year: days = period.value * 365
        @unknown default: days = period.value
        }

        return "\(days) Days Free"
    }
    
    func tapped(on product: Product) {
        chosenProduct = product
        haptic.selectionChanged()
    }
    
    func showPrivacyPolicy() {
//        guard let url = URL(string: privacyPolicyURL) else { return }
//        UIApplication.shared.open(url)
    }
    
    func showTermsOfUse() {
//        guard let url = URL(string: termsOfUse) else { return }
//        UIApplication.shared.open(url)
    }
    
    func isMonthlyButtonDisabled(_ subscription: Product) -> Bool {
        isPurchased(.annual) && subscription.id == AppPurchase.monthly.id
    }
    
    private func isPurchased(_ appPurchase: AppPurchase) -> Bool {
        store.purchasedProductIDs.contains(appPurchase.id)
    }
    
    private func isChosen(_ appPurchase: AppPurchase) -> Bool {
        guard let chosenProductID = chosenProduct?.id else { return false }
        
        return chosenProductID == appPurchase.id
    }
}
