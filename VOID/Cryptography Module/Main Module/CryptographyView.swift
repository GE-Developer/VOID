//
//  CryptographyView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct CryptographyView: View {
    @EnvironmentObject private var tabBarState: TabBarState
    @EnvironmentObject private var store: StoreManager
    
    @State private var showPayWall = false
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
            .fullScreenCover(isPresented: $showPayWall) {
                NavigationLazyView(PayWallView(store))
            }
    }
}

// MARK: - Builder
extension CryptographyView {
    private var cryptographyView: some View {
        CustomScrollView(title: vm.title, withBackButton: false, tabBarIsVisible: true) {
            logo
                .frame(height: 18)
                .opacity(0.5)
                .offset(y: 2)
        } content: { _ in
            VStack(spacing: 24) {
                topButtonsScroll
                symmetrycEncryptionTabs
                encodingTabs
            }
            .padding(.bottom, tabBarState.height)
        }
    }
    
    private var topButtonsScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 14) {
                topButton(
                    image: Image.content.voidAES256Argon2id,
                    title: vm.qrCodeTitle,
                    action: { showQRCodeView = true })
            }
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
        }
    }
    
    private func topButton(image: Image, title: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 6) {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(Color(.secondarySystemGroupedBackground))
                    image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .padding(4)
                }
                .frame(width: 90, height: 90)
                .premiumOption($showPayWall)
                .overlay {
                    Circle()
                        .stroke(store.isPremium ? Gradient.accent : Gradient.gold, lineWidth: 3)
                }
                .overlay {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            PremiumView(.star)
                                .padding(4)
                                .background {
                                    Circle()
                                        .fill(Color.void.background)
                                        .shadow(color: Color.void.background, radius: 2)
                                }
                                .offset(x: 3, y: 1)
                        }
                    }
                }
            }
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.mainText)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
        }
        .frame(width: 90)
        .padding(.top, 3)
    }
}
