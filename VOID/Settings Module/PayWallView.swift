//
//  PayWallView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI
import StoreKit

struct PayWallView: View {
    @EnvironmentObject private var store: StoreManager
    @StateObject private var vm: PayWallViewModel
    
    init(_ store: StoreManager) {
        _vm = StateObject(wrappedValue: PayWallViewModel(store: store))
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                topper(geo)
                payView
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(background)
        .overlay(backButton)
//        .animation(.easeIn, value: store.purchasedProductIDs.isEmpty)
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
    
    private var payView: some View {
        VStack(spacing: 12) {
            VStack(spacing: 6) {
                Text(vm.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.void.mainText)
                    .lineLimit(1)
                Text(vm.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.void.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(height: 80)
            .fontDesign(.rounded)
            .minimumScaleFactor(0.7)
            .padding(.horizontal)
            
            
            if let inAppPurchase = vm.inAppPurchases.first {
                VStack {
                    Text(inAppPurchase.displayName)
                    Text(inAppPurchase.displayPrice)
                    Text(inAppPurchase.description)
                    
                    if inAppPurchase.isFamilyShareable {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 40, height: 10)
                            .foregroundStyle(.green)
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 90)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(
                            vm.chosenProduct == inAppPurchase
                            ? Color.blue
                            : Color(.secondarySystemGroupedBackground)
                        )
                }
                .onTapGesture {
                    vm.chosenProduct = inAppPurchase
                }
                .padding(.horizontal)
            }
            
            
            
            HStack(spacing: 12) {
                ForEach(vm.subscriptions) { subscription in
                    VStack {
                        Text(vm.name(for: subscription))
                            .font(.headline)
                        Text(subscription.displayPrice)
                            .font(.headline)
                        Text(vm.description(for: subscription))
                            .font(.caption2)
                        
                        
                        if subscription.isFamilyShareable {
                            Text(vm.premiumShareText)
                                .foregroundStyle(.green)
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(
                                vm.chosenProduct == subscription
                                ? Color.blue
                                : Color(.secondarySystemGroupedBackground)
                            )
                    }
                    .onTapGesture {
                        vm.chosenProduct = subscription
                    }
                    
                }
            }
            .padding(.horizontal)
 
            Spacer()
            
            continueButton
                .padding(.horizontal)
            
            HStack(spacing: 6) {
                bottomButton(text: vm.privacyPolicy) { }
                    .frame(maxWidth: .infinity)
                bottomButton(text: vm.termsOfUse) { }
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .padding(.top, 6)
    }
    
    private var continueButton: some View {
        Button {
            Task {
                try await vm.purchase(vm.chosenProduct!)
            }
        } label: {
            Text(vm.continueTitle)
                .font(.title3)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Gradient.payWallAccent)
                .foregroundStyle(Color.white)
                .clipShape(Capsule())
                .shadow(color: Color.void.mainText, radius: 1)
        }
        .disabled(vm.purchaseButtonDisabled)

    }
    
    private func topper(_ geo: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            MatrixAnimationView(
                store.purchasedProductIDs.isEmpty ? .binary : .englishCapitalizedAlphabet,
                color: store.purchasedProductIDs.isEmpty ? Gradient.payWallAccent : Gradient.gold,
                letterSize: 12,
                columnSpacing: 0,
                rowSpacing: 0,
                updateDelay: 500,
                speedRange: 5...7
            )
            .frame(height: geo.size.height / 2.8)
            Rectangle()
                .frame(height: 40)
                .foregroundStyle(LinearGradient(colors: [.void.background, .void.background.opacity(0.7), Color.clear], startPoint: .bottom, endPoint: .top))
        }
    }
    
    private func bottomButton(text: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .fontWeight(.light)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
    }
}
