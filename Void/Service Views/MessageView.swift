//
//  MessageView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct MessageView: View {
    @State private var isScaleMessage = false
    @State private var showMessage = false
    
    private var backgroundColor: LinearGradient {
        switch message.encryptionMode {
        case .encrypt:
            return Gradient.accent
        case .decrypt:
            return Gradient.gray
        }
    }
    
    private let message: Message
    
    init(message: Message) {
        self.message = message
    }
    
    var body: some View {
        messageView
    }
}

// MARK: - Builder
extension MessageView {
    private var messageView: some View {
        HStack(spacing: 8) {
            if message.encryptionMode == .encrypt {
                Spacer()
                eyeButton
            }
            
            Text(showMessage ? message.originalText : message.encryptedText)
                .font(.caption2)
//                .fontWeight(.medium)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.mainText)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(backgroundColor)
                        .shadow(color: Color.void.viewShadow, radius: 2)
                }
                .scaleEffect(isScaleMessage ? 1.05 : 1)
                .onLongPressGesture(maximumDistance: 1, perform: copyText) { isScaleMessage = $0 }
            
            if message.encryptionMode == .decrypt {
                eyeButton
                Spacer()
            }
        }
        .padding(.leading, message.encryptionMode == .encrypt ? 16 : 0)
        .padding(.trailing, message.encryptionMode == .decrypt ? 16 : 0)
    }
    
    private var eyeButton: some View {
        Button {
            withTransaction(Transaction(animation: nil)) {
                showMessage.toggle()
            }
        } label: {
            Image.system.eye
                .font(.caption2)
                .foregroundStyle(
                    showMessage
                    ? Gradient.accent
                    : Gradient.gray
                )
        }
    }
    
    private func copyText() {
        UIPasteboard.general.string = message.encryptedText
        HapticsManager.shared.notification(type: .success)
    }
}
