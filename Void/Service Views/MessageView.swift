//
//  MessageView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct MessageView: View {    
    private var backgroundColor: LinearGradient {
        switch message.encryptionMode {
        case .encrypt:
            return Gradient.accent
        case .decrypt:
            return Gradient.gray
        }
    }
    
    private var transitionEdge: Edge {
        message.encryptionMode == .encrypt ? .trailing : .leading
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
        HStack() {
            if message.encryptionMode == .encrypt {
                Spacer()
            }
            
            Text(message.resultText)
                .font(.caption2)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.mainText)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(backgroundColor)
                        .shadow(color: Color.void.viewShadow, radius: 2)
                }
                .onLongPressGesture(maximumDistance: 1, perform: copyText)
            
            if message.encryptionMode == .decrypt {
                Spacer()
            }
        }
        .padding(.leading, message.encryptionMode == .encrypt ? 50 : 0)
        .padding(.trailing, message.encryptionMode == .decrypt ? 50 : 0)
        .transition(
            .asymmetric(
                insertion: .move(edge: transitionEdge).combined(with: .opacity),
                removal: .opacity
            )
        )
    }
        
    private func copyText() {
        UIPasteboard.general.string = message.resultText
        HapticsManager.shared.notification(type: .success)
    }
}
