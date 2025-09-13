//
//  AES256EncryptionView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct AES256EncryptionView: View {
    @StateObject private var vm = AES256EncryptionViewModel()
    @State private var disabled = true
    @State private var goToSettings = false
    
    init() {
        print("AES256EncryptionView init")
    }
    
    var body: some View {
        
        CustomScrollView { isLargeNavBar in
            CustomNavigationBar(
                title: vm.title,
                subTitle: vm.subtitle,
                isLargeNavBar: isLargeNavBar
            )
            Spacer()
            settingsButton
        } headerView: { offsetY in
            HeaderTextView(text: vm.headetText, offsetY: offsetY)
        } scrollView: { proxy in
            VStack(spacing: 15) {
                if vm.messages.isEmpty {
                    ForEach(vm.introMessages) { introMessage in
                        MessageView(message: introMessage)
                    }
                }
                
                ForEach(vm.messages) { message in
                    MessageView(message: message)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomSafeArea
        }
        .navigationDestination(isPresented: $goToSettings) {
            NavigationLazyView(AES256SettingsView(vm: vm))
        }
    }
}

// MARK: - Builder
extension AES256EncryptionView {
//    private var showTextButton: some View {
//        Button {
////            withAnimation(.easeInOut(duration: 0.1)) {
//                showMessage.toggle()
////            }
//            
//        } label: {
//            Image.system.eye
//                .foregroundStyle(showMessage ? Gradient.premiumSubscriptionGradiaent : Gradient.accentGragient)
//                .font(.title2)
//                .animation(.easeInOut, value: showMessage)
//        }
//
//    }
    
    private var settingsButton: some View {
        Button {
            goToSettings.toggle()
        } label: {
            Image.system.cryptoSettings
                .foregroundStyle(Gradient.accentGragient)
                .font(.title2)
        }
    }
    
    private var bottomSafeArea: some View {
        VStack(spacing: 8) {
            CustomMessageTextField(text: $vm.text, placeholder: vm.placeholder, disabled: $disabled) {
                switch vm.currentMode {
                case .encrypt:
                    Task { await vm.encrypt() }
                case .decrypt:
                    Task { await vm.decrypt() }
                    print("DECRYPT")
                }
            }
            .disabled(disabled)
            .onAppear {
                disabled = vm.encryptionParameters.password == ""
                print(vm.encryptionParameters.password == "")
                print("goToSettings - \(goToSettings)")
            }
            
            .onTapGesture {
                guard disabled else { return }
                goToSettings = true
                print("ЭКРАН НАСТРОЕК")
            }
            
            CryptoActionButtons(
                cryptoAction: $vm.currentMode,
                decryptiontitle: vm.decryptionTitle,
                encryptiontitle: vm.encryptionTitle
            )
        }
//        .onTapGesture {
//            guard disabled else { return }
//            
//        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
    }
}
