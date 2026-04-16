//
//  CryptographyView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct CryptographyView: View {
    @EnvironmentObject private var tabBarState: TabBarState
    
    @State private var showAES256View = false
    @State private var showEmojiView = false
    @State private var showQRCodeView = false
    
    private let vm = CryptographyViewModel()
    
    var body: some View {
        cryptographyView
            .navigationDestination(isPresented: $showAES256View) {
                NavigationLazyView(AES256EncryptionView())
            }
            .navigationDestination(isPresented: $showEmojiView) {
                NavigationLazyView(EmojiCodingView())
            }
            .navigationDestination(isPresented: $showQRCodeView) {
                NavigationLazyView(QRCodeGeneratorView())
            }
    }
}

// MARK: - Builder
extension CryptographyView {
    private var cryptographyView: some View {
        CustomScrollView(withBackButton: false, tabBarIsVisible: true) {
            CustomNavigationTitle(title: vm.title, isLargeNavBar: $0)
            Spacer()
            logo
                .frame(height: 18)
                .opacity(0.5)
                .offset(y: 2)
        } scrollView: { proxy in
            VStack(spacing: 24) {
                symmetrycEncryptionTabs
                encodingTabs
            }
            .padding(.bottom, tabBarState.height)
        }
    }
    
    private var symmetrycEncryptionTabs: some View {
        CustomTabImageView(
            title: vm.symmetricEncryptionTitle,
            headerImage: Image.system.key(true)
        ) {
            CustomTabSection(
                image: Image.content.voidAES256Argon2id,
                text: vm.aes256Argon2idTitle,
                subtext: vm.aes256Argon2idSubitle,
                action: { showAES256View = true }
            )
        }
    }
    
    private var encodingTabs: some View {
        CustomTabImageView(
            title: vm.encodingTitle,
            headerImage: Image.system.code
        ) {
            CustomTabSection(
                image: Image.content.emoji,
                text: vm.aes256EmojiTitle,
                action: { showEmojiView = true }
            )
            CustomTabSection(
                image: Image.content.voidAES256Argon2id,
                text: "QR CODE" ,
                action: { showQRCodeView = true }
            )
        }
    }
}
