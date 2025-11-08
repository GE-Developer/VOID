//
//  PayWallView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI
//import StoreKit

struct PayWallView: View {
    @EnvironmentObject private var store: StoreManager
    @StateObject private var vm: PayWallViewModel

    init(_ store: StoreManager) {
        _vm = StateObject(wrappedValue: PayWallViewModel(store: store))
    }
    
    var body: some View {
        payWall
            .environmentObject(vm)
    }
}

// MARK: - Builder
extension PayWallView {
    private var payWall: some View {

        VStack(spacing: 0) {
            topper
            mainView
                .padding(.top, 5)
                .padding(.horizontal)
                .padding(.bottom, isFaceIDPhone ? 20 : 5)
        }
        .ignoresSafeArea()
        .background(background)
        .overlay(backButton)
    }
    
    private var mainView: some View {
       
            VStack(spacing: 0) {
                title
                subtitle
                VStack(spacing: 22) {
                    lifetimeButton
                    subscriptionButtons
                }
                .frame(height: 80+22+170+20)
                
                VStack(spacing: 10) {
                    purchaseText
                    continueButton
                    
                    HStack(spacing: 6) {
                        bottomLink(text: vm.privacyPolicy) { vm.showPrivacyPolicy() }
                        bottomLink(text: vm.termsOfUse) { vm.showTermsOfUse() }
                    }
                }
            }
            
        
    }
    
    private var title: some View {
        Text(vm.title)
            .font(.title)
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .foregroundStyle(Color.void.mainText)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .frame(height: 34)
    }
    
    private var subtitle: some View {
        Text(vm.subtitle)
            .font(.subheadline)
            .fontDesign(.rounded)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.void.secondaryText)
            .lineLimit(2)
            .minimumScaleFactor(0.7)
            .frame(height: 38)
    }
    
    private var purchaseText: some View {
        Text(vm.subtitle)
            .font(.subheadline)
            .fontDesign(.rounded)
            .foregroundStyle(Color.void.secondaryText)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .frame(height: 18)
    }
    
    private var continueButton: some View {
        Button {
            Task {
                try await vm.purchase(vm.chosenProduct!)
            }
        } label: {
            Text(vm.purchaseButtonTitle)
                .font(.title3)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Gradient.payWallAccent)
                .foregroundStyle(Color.white)
                .clipShape(Capsule())
                .shadow(color: Color.void.mainText, radius: 1)
        }
        .disabled(vm.purchaseButtonDisabled)
    }

    private var background: some View {
        Color.void.background
            .ignoresSafeArea()
    }
    
    private var backButton: some View {
        VStack {
            HStack {
                Spacer()
                ExitButton()
                    .padding()
            }
            Spacer()
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Lifetime
    @ViewBuilder
    private var lifetimeButton: some View {
        if let inAppPurchase = vm.inAppPurchases.first {
            ProductButton(product: inAppPurchase, buttonType: .horisontal)
        }
    }
    
    // MARK: - Subscriptions
    private var subscriptionButtons: some View {
        HStack(spacing: 12) {
            ForEach(vm.subscriptions) {
                ProductButton(product: $0, isDisabled: vm.isMonthlyButtonDisabled($0))
            }
        }
    }

    private var topper: some View {
        ZStack(alignment: .bottom) {
            MatrixAnimationView(
                .binary,
                color: Gradient.payWallAccent,
                letterSize: 12,
                columnSpacing: 0,
                rowSpacing: 0,
                updateDelay: nil,
                speedRange: 8...9
            )
            Rectangle()
                .frame(height: 40)
                .foregroundStyle(LinearGradient(colors: [.void.background, .void.background.opacity(0.7), Color.clear], startPoint: .bottom, endPoint: .top))
        }
    }
    
//    private func monthlyButtonDisabled() {
//        
//    }
    
    private func bottomLink(text: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .fontWeight(.light)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(1)
                .frame(maxWidth: .infinity)
                .frame(height: 31)
        }
    }
}
