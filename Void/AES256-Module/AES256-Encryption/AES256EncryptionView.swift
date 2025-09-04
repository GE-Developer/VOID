//
//  AES256EncryptionView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct AES256EncryptionView: View {
    @StateObject private var vm = AES256EncryptionViewModel()
    @State private var disabled = false
    @State private var showHint = false
    
    var body: some View {
        
        CustomScrollView() { isLarge in
            CustomNavigationBar(
                title: vm.title,
                subTitle: vm.subtitle,
                isLarge: isLarge
            )
            Spacer()
            NavigationLink {
                AES256SettingsView(vm: vm)
            } label: {
                Image.system.cryptoSettings
                    .foregroundStyle(
                        showHint
                        ? Gradient.basicSubscriptionGradiaent
                        : Gradient.accentGragient
                    )
                    .font(.title2)
                    .animation(.easeInOut.repeatCount(1, autoreverses: true), value: showHint)
            }
            
        } scrollView: {
//            if vm.isEncrypting {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .padding()
//            }
//            TextEditor(text: .constant(vm.resultText))
            ZStack {
                MatrixAnimationView(.allCases.randomElement()!, color: Gradient.accentGragient)
                    .frame(width: 250, height: 300)
                VStack {
                    ForEach(vm.messages) { message in
                        MessageView(message: message)
                            .onLongPressGesture(minimumDuration: 1) {
                                UIPasteboard.general.string = message.resultText
                            }
                    }
                }
//                HStack(spacing: 2) {
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                    VerticalAlphabetView()
//                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomSafeArea
        }
    }
}

// MARK: - Builder
extension AES256EncryptionView {
    private var bottomSafeArea: some View {
        VStack(spacing: 8) {
            CryptoActionButtons(
                cryptoAction: $vm.currentMode,
                decryptiontitle: vm.decryptionTitle,
                encryptiontitle: vm.encryptionTitle
            )
            
            CustomMessageTextField(text: $vm.text, placeholder: vm.placeholder, disabled: $disabled) {
                
                switch vm.currentMode {
                case .encrypt:
                    Task { await vm.encrypt() }
                case .decrypt:
                    Task { await vm.decrypt() }
                    print("DECRYPT")
                }
            }
        }
        .onTapGesture {
            guard disabled && !showHint else { return }
            print("guard disabled && !showHint else { return }")
            showHint = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showHint = false
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
    }
}
