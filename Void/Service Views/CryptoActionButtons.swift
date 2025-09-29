//
//  CryptoActionButtons.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CryptoActionButtons: View {
    @Binding private var cryptoAction: CryptoAction
    
    private let decryptiontitle: String
    private let encryptiontitle: String
    
    private let height: CGFloat = 37
    
    init(
        _ cryptoAction: Binding<CryptoAction>,
        _ decryptiontitle: String,
        _ encryptiontitle: String
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
        .frame(height: height)
    }
    
    private func button(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: height / 2)
                    .foregroundStyle(
                        isActive
                        ? Gradient.accent
                        : Gradient.gray
                    )
                    .shadow(color: Color.void.viewShadow, radius: 2)
                
                Text(title)
                    .foregroundStyle(Color.void.mainText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .textCase(.uppercase)
            }
            .opacity(isActive ? 1 : 0.8)
        }
        .disabled(isActive)
        .animation(.easeInOut, value: isActive)
    }
}
