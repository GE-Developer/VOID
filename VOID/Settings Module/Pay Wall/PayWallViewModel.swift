//
//  PayWallViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import StoreKit
import Foundation

@MainActor
final class PayWallViewModel: ObservableObject {
    @Published private(set) var inAppPurchases: [Product] = []
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var chosenProduct: Product?
    @Published private(set) var isLoading = false
    
    @Published private(set) var showLoadAgain = false
    @Published var showError = false
    
    private(set) var errorDescription: String = ""
    
    var subtitle: String {
        if isPurchased(.lifetime) || store.devTest {
            return L10n("PayWall.Subtitle.lifetime")
        }
        
        if isPurchased(.annual) {
            return L10n("PayWall.Subtitle.annual")
        }
        
        if isPurchased(.monthly) {
            return L10n("PayWall.Subtitle.monthly")
        }
    
        return L10n("PayWall.Subtitle.default")
    }
    
    var purchaseButtonTitle: String {
        if isChosen(.lifetime) {
            return isPurchased(.lifetime)
            ? L10n("PayWall.Button.owned")
            : L10n("PayWall.Button.purchase")
        }
        
        if isChosen(.annual) {
            guard !isPurchased(.annual) else { return L10n("PayWall.Button.manage") }
            
            return isPurchased(.monthly)
            ? L10n("PayWall.Button.upgrade")
            : L10n("PayWall.Button.subscribe")
        }
        
        if isChosen(.monthly) {
            guard !isPurchased(.monthly) else { return L10n("PayWall.Button.manage") }
 
            return L10n("PayWall.Button.subscribe")
        }
        
        return L10n("PayWall.Button.purchase")
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
        
        let percentInt = NSDecimalNumber(decimal: roundedPercent).intValue
        
        let savingText = L10n("PayWall.annualSaving") + " " + "\(percentInt)%"
        
        return roundedPercent > 0 ? savingText : nil
    }
    
    var monthlyStatus: String? {
        if store.purchasedProductIDs.contains(AppPurchase.annual.id) {
            return "Not available"
        } else if store.purchasedProductIDs.contains(AppPurchase.monthly.id) {
            return "Purchased"
        }
        return nil
    }
    
    var annualStatus: String? {
        store.purchasedProductIDs.contains(AppPurchase.annual.id) ? "Purchased" : nil
    }
    
    let title = L10n("PayWall.title")
    let termsOfUse = L10n("Settings.AboutApp.TermsOfUse.title")
    let privacyPolicy = L10n("Settings.AboutApp.PrivacyPolicy.title")
    let restorePurchasesTitle = L10n("Settings.Access.RestorePurchases.title")
    let familyShareText = L10n("PayWall.familyPlan")
    
    let errorTitle = L10n("Error.title")
    let errorOK = "OK"
    
    private let haptic = HapticsManager.shared
    private let sound = SoundManager.shared
    private unowned let store: StoreManager
    
    init(store: StoreManager) {
        self.store = store
        
        Task { await loadProducts() }
    }
    
    func name(for product: Product) -> String {
        let appProduct = AppPurchase.allCases.first { $0.id == product.id }
        
        guard let appProduct else { return product.displayName }
        
        switch appProduct {
        case .lifetime: return L10n("PayWall.Lifetime.title")
        case .monthly: return L10n("PayWall.Monthly.title")
        case .annual: return L10n("PayWall.Annual.title")
        }
    }
    
    func description(for product: Product) -> String {
        let appProduct = AppPurchase.allCases.first { $0.id == product.id }
        
        guard let appProduct else { return product.displayName }
        
        switch appProduct {
        case .lifetime: return L10n("PayWall.Lifetime.subtitle")
        case .monthly: return L10n("PayWall.Monthly.subtitle")
        case .annual: return L10n("PayWall.Annual.subtitle")
        }
    }

    func freeTrialDescription(for product: Product) async -> String? {
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

        return L10n("PayWall.trialPeriod \(days)")
    }

    func purchase(_ product: Product?) {
        guard let product else { return }
        Task {
            do {
                try await store.purchase(product)
            } catch {
                let storeError = error as? StoreError
                errorDescription = storeError?.description ?? StoreError.unknown.description
                showError.toggle()
                haptic.notification(type: .error)
                sound.playSound(.errorAlert)
            }
        }
    }
    
    func tapped(on product: Product) {
        chosenProduct = product
        haptic.selectionChanged()
    }
    
    func showPrivacyPolicy() {
        guard let url = URL(string: Plist.get(.privacyPolicy)) else { return }
        UIApplication.shared.open(url)
    }
    
    func showTermsOfUse() {
        guard let url = URL(string: Plist.get(.termsOfUse)) else { return }
        UIApplication.shared.open(url)
    }
    
    func isMonthlyButtonDisabled(_ subscription: Product) -> Bool {
        isPurchased(.annual) && subscription.id == AppPurchase.monthly.id
    }
    
    func restorePurchases() {
        Task {
            do {
                try await store.restorePurchases()
            } catch {
                errorDescription = StoreError.syncError.description
                showError.toggle()
                sound.playSound(.errorAlert)
                haptic.notification(type: .error)
            }
        }
    }
    
    func isChosen(_ appPurchase: AppPurchase) -> Bool {
        guard let chosenProductID = chosenProduct?.id else { return false }
        
        return chosenProductID == appPurchase.id
    }
    
    private func isPurchased(_ appPurchase: AppPurchase) -> Bool {
        store.purchasedProductIDs.contains(appPurchase.id)
    }
    
    private func loadProducts() async {
        guard !isLoading else { return }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        let subscriptionIDs = AppPurchase.subscriptionIDs
        let inAppPurchaseIDs = AppPurchase.inAppPurchaseIDs
        
        do {
            let fetchedSubscriptions = try await Product.products(for: subscriptionIDs)
            inAppPurchases = try await Product.products(for: inAppPurchaseIDs)
            
            subscriptions = AppPurchase.subscriptionIDs.compactMap { id in
                fetchedSubscriptions.first(where: { $0.id == id })
            }
            showLoadAgain = false
        } catch {
            errorDescription = StoreError.loadingError.description
            showError.toggle()
            haptic.notification(type: .error)
            sound.playSound(.errorAlert)
            showLoadAgain = true
        }
    }
}






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

enum StoreError: Error {
    case revokedCertificate
    case invalidCertificateChain
    case invalidDeviceVerification
    case invalidEncoding
    case invalidSignature
    case missingRequiredProperties
    case userCancelled
    case pending
    case unknown
    case system
    case productNotChosen
    case loadingError
    case syncError
    
    var description: String {
        switch self {
        case .revokedCertificate:
            return ""
        case .invalidCertificateChain:
            return ""
        case .invalidDeviceVerification:
            return ""
        case .invalidEncoding:
            return ""
        case .invalidSignature:
            return ""
        case .missingRequiredProperties:
            return ""
        case .userCancelled:
            return ""
        case .pending:
            return ""
        case .unknown:
            return ""
        case .system:
            return ""
        case .productNotChosen:
            return ""
        case .loadingError:
            return ""
        case .syncError:
            return "Sync failed"
        }
    }
    
    static func from(_ reason: VerificationResult<Transaction>.VerificationError) -> StoreError {
        switch reason {
        case .revokedCertificate: return .revokedCertificate
        case .invalidCertificateChain: return .invalidCertificateChain
        case .invalidDeviceVerification: return .invalidDeviceVerification
        case .invalidEncoding: return .invalidEncoding
        case .invalidSignature: return .invalidSignature
        case .missingRequiredProperties: return .missingRequiredProperties
        @unknown default: return .unknown
        }
    }
}



struct Plist {
    enum Key: String {
        case appID = "App ID"
        case lifetimeProduct = "Lifetime Product"
        case annualProduct = "Annual Product"
        case monthlyProduct = "Monthly Product"
        case developerLink = "Developer Link"
        case gitHub = "GitHub"
        case termsOfUse = "Terms of Use"
        case privacyPolicy = "Privacy Policy"
    }
    
    static private let plistName = "Property List"
    
    static func get(_ key: Key) -> String {
        guard let url = Bundle.main.url(forResource: plistName, withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let value = dict[key.rawValue] as? String else { return "" }
        return value
    }
}
