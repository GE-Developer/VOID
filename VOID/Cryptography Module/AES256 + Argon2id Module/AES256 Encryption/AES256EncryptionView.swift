//
//  AES256EncryptionView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI
import UniformTypeIdentifiers

struct AES256EncryptionView: View {
    @StateObject private var vm = AES256EncryptionViewModel()

    @State private var goToSettings = false
    @State private var isCopied = false
    @State private var hideCopyAlertWorkItem: DispatchWorkItem?
    @State private var showFileImporter = false
    @State private var shareItem: ShareItem?

    private var isTextFieldDisabled: Bool {
        vm.encryptionParameters.password.isEmpty
    }

    let backImage = Image.background.aes256Argon2idVOID

    var body: some View {
        aes256EncryptionView
            .navigationDestination(isPresented: $goToSettings) {
                NavigationLazyView(AES256SettingsView(vm: vm))
            }
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.data],
                allowsMultipleSelection: false,
                onCompletion: handleFileImport
            )
            .sheet(item: $shareItem) { item in
                ShareSheet(url: item.url)
            }
    }
}

// MARK: - Builder
extension AES256EncryptionView {
    private var aes256EncryptionView: some View {
        CustomScrollView(title: vm.title, backgroundImage: backImage) {
            NavigationToolButton(.system.cryptoSettings) { goToSettings = true }
        } content: { proxy in
            chatRows
                .onChange(of: vm.items) { scrollTo(proxy) }
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

    private var chatRows: some View {
        VStack(spacing: 15) {
            TopViewHeaderText(text: vm.headetText)
            ForEach(vm.items) { item in
                Group {
                    switch item {
                    case .text(let message):
                        MessageView(message: message) { copyText(message) }
                    case .file(let message):
                        FileMessageView(message: message) { shareFile(message) }
                    }
                }
                .id(item.id)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: vm.items)
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

    @ViewBuilder private var selectedFileChip: some View {
        if let name = vm.selectedFileName {
            HStack(spacing: 8) {
                Image(systemName: "doc.fill")
                    .foregroundStyle(Gradient.accent)

                Text(name)
                    .font(.callout)
                    .fontDesign(.rounded)
                    .foregroundStyle(Color.void.mainText)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Spacer()

                Button {
                    vm.clearSelectedFile()
                } label: {
                    Image.system.xmark
                        .foregroundStyle(Color.void.secondaryText)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.void.textFieldBackground)
                    .shadow(color: Color.void.viewShadow, radius: 2)
            }
        }
    }

    private var bottomSafeArea: some View {
        VStack(spacing: 8) {
            selectedFileChip

            CustomTextField(
                text: $vm.text,
                isDisabled: .constant(isTextFieldDisabled),
                placeholder: vm.placeholder,
                isMultilined: true,
                hasAttachment: vm.hasSelectedFile,
                inputAction: { showFileImporter = true },
                sendAction: vm.startCryptoProcess
            )
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
        guard vm.encryptionParameters.password.isEmpty else { return }
        goToSettings = true
    }

    private func copyText(_ message: Message) {
        UIPasteboard.general.string = message.resultText
        showCopyAlert()
        HapticsManager.shared.notification(type: .success)
    }

    private func shareFile(_ message: FileMessage) {
        shareItem = ShareItem(url: message.fileURL)
        HapticsManager.shared.notification(type: .success)
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            vm.selectFile(url)
        case .failure:
            break
        }
    }

    private func scrollTo(_ proxy: ScrollViewProxy) {
        guard let lastId = vm.items.last?.id else { return }

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

// MARK: - Share Item

struct ShareItem: Identifiable {
    let id = UUID()
    let url: URL
}
