//
//  CryptoActionButtons.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 05.08.25.
//

import SwiftUI

struct CryptoActionButtons: View {
    @Binding private var cryptoAction: CryptoAction
    
    private let decryptiontitle: String
    private let encryptiontitle: String
    
    init(
        cryptoAction: Binding<CryptoAction>,
        decryptiontitle: String,
        encryptiontitle: String
    ) {
        _cryptoAction = cryptoAction
        self.decryptiontitle = decryptiontitle
        self.encryptiontitle = encryptiontitle
    }
    
    var body: some View {
        cryptoActionButtons
    }
}

// MARK: - Builder
extension CryptoActionButtons {
    private var cryptoActionButtons: some View {
        HStack {
            button(title: decryptiontitle, isActive: cryptoAction == .decrypt) {
                cryptoAction = .decrypt
            }
            button(title: encryptiontitle, isActive: cryptoAction == .encrypt) {
                cryptoAction = .encrypt
            }
        }
        .frame(height: 35)
    }
    
    private func button(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(
                        isActive
                        ? Gradient.accentGragient
                        : Gradient.basicSubscriptionGradiaent
                    )
                    .shadow(color: Color.navigation.navBarShadow, radius: 2)
                
                Text(title)
                    .foregroundStyle(Color.main.text)
                    .font(.caption)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .textCase(.uppercase)
            }
            .opacity(isActive ? 1 : 0.8)
        }
        .disabled(isActive)
        .animation(.easeInOut, value: isActive)
    }
}
