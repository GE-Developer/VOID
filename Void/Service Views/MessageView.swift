//
//  MessageView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct MessageView: View {
    @State private var isPressing = false
    
    private var backgroundColor: Color {
        switch message.encryptionMode {
        case .encrypt:
            return isPressing ? .void.greenDark : .void.accentLight
        case .decrypt:
            return isPressing ? .void.greenDark : .void.grayDark
        }
    }
    
    private var transitionEdge: Edge {
        message.encryptionMode == .encrypt ? .trailing : .leading
    }
    
    private let message: Message
    
    private let pressAction: () -> Void
    
    init(message: Message, pressAction: @escaping () -> Void) {
        self.message = message
        self.pressAction = pressAction
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
                .font(.caption)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.mainText)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(backgroundColor)
                        .shadow(color: Color.void.navBarShadow, radius: 2)
                }
                .onLongPressGesture(
                    minimumDuration: 0.5,
                    maximumDistance: 0.5,
                    perform: pressAction,
                    onPressingChanged: { pressing in
                        withAnimation(.spring(response: 0.8)) { isPressing = pressing }
                    }
                )
            
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
}
