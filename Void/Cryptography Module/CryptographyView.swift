//
//  CryptographyView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CryptographyView: View {
    private let vm = CryptographyViewModel()
    
    
    @State private var showAES256View = false
    @State private var showEmojiView = false
    
    var body: some View {
        cryptographyView
            .navigationDestination(isPresented: $showAES256View) {
                NavigationLazyView(AES256EncryptionView())
            }
            .navigationDestination(isPresented: $showEmojiView) {
                NavigationLazyView(EmojiCodingView())
            }
    }
}

// MARK: - Builder
extension CryptographyView {
    private var cryptographyView: some View {
        CustomScrollView(withBackButton: false) {
            CustomNavigationTitle(title: vm.title, isLargeNavBar: $0)
            Spacer()
        } scrollView: { _ in
            VStack(spacing: 24) {
                symmetrycEncryptionTabs
                encodingTabs
            }
        }
    }
    
    private var symmetrycEncryptionTabs: some View {
        CustomTabImageView(
            title: vm.symmetricEncryptionTitle,
            subtitle: vm.symmetricEncryptionSubtitle,
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
            subtitle: vm.encodingDescription,
            headerImage: Image.system.code
        ) {
            CustomTabSection(
                image: Image.content.emoji,
                text: vm.aes256EmojiTitle,
                action: { showEmojiView = true }
            )
        }
    }
}
