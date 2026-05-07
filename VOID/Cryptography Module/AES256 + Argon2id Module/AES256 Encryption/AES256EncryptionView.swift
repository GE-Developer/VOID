//
//  AES256EncryptionView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct AES256EncryptionView: View {
    @StateObject private var vm = AES256EncryptionViewModel()
    
    @State private var isTextFieldDisabled = true
    @State private var goToSettings = false
    @State private var isCopied = false
    @State private var hideCopyAlertWorkItem: DispatchWorkItem?
    
    let backImage = Image.background.aes256Argon2idVOID
    
    var body: some View {
        aes256EncryptionView
            .navigationDestination(isPresented: $goToSettings) {
                NavigationLazyView(AES256SettingsView(vm: vm))
            }
    }
}

// MARK: - Builder
extension AES256EncryptionView {
    private var aes256EncryptionView: some View {
        CustomScrollView(title: vm.title, backgroundImage: backImage) {
            NavigationToolButton(.system.cryptoSettings) { goToSettings = true }
        } content: { proxy in
            messageRows
                .onChange(of: vm.messages) { scrollTo(proxy) }
        }
        .alert(
            Text(vm.errorTitle),
            isPresented: $vm.showErrorAlert,
            actions: { Button(vm.okTitle) {} },
            message: { Text(vm.errorMessage) }
        )
        .safeAreaInset(edge: .bottom) {
            VStack {
                copyAlert
                bottomSafeArea
                    .autocorrectionDisabled(true)
            }
        }
        .overlay(loader)
    }
    
    private var messageRows: some View {
        VStack(spacing: 15) {
            TopViewHeaderText(text: vm.headetText)
            ForEach(vm.messages) { message in
                MessageView(message: message) {
                    copyText(message)
                }
                .id(message.id)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: vm.messages)
    }
    
    @ViewBuilder private var loader: some View {
        if vm.isEncrypting {
            FullScreenLoader()
        }
    }
    
    @ViewBuilder private var copyAlert: some View {
        if isCopied {
            CopyAlertView()
                .transition(
                    .move(edge: .bottom)
                    .combined(with: .opacity)
                )
        }
    }
    
    private var bottomSafeArea: some View {
        VStack(spacing: 8) {
            CustomTextField(
                text: $vm.text,
                isDisabled: $isTextFieldDisabled,
                placeholder: vm.placeholder,
                isMultilined: true,
                sendAction: vm.startCryptoProcess
            )
            .onAppear(perform: checkPassword)
            .onTapGesture(perform: tappedOnTextFieldWithoutPassword)
            
            CryptoActionButtons($vm.currentMode, vm.decryptionTitle, vm.encryptionTitle)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.ultraThinMaterial)
                .shadow(color: .void.navBarShadow, radius: 2)
        }
    }
}

// MARK: - Logic
extension AES256EncryptionView {
    private func tappedOnTextFieldWithoutPassword() {
        guard isTextFieldDisabled else { return }
        goToSettings = true
    }
    
    private func checkPassword() {
        let isPasswordEmpty = vm.encryptionParameters.password == ""
        isTextFieldDisabled = isPasswordEmpty
    }
    
    private func copyText(_ message: Message) {
        UIPasteboard.general.string = message.resultText
        showCopyAlert()
        HapticsManager.shared.notification(type: .success)
    }
    
    private func scrollTo(_ proxy: ScrollViewProxy) {
        guard let lastId = vm.messages.last?.id else { return }
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            proxy.scrollTo(lastId, anchor: .bottom)
        }
    }
    
    private func showCopyAlert() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            isCopied = true
        }
        hideCopyAlertWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                isCopied = false
            }
        }
        hideCopyAlertWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: workItem)
    }
}
