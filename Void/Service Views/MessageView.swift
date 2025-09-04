//
//  MessageView.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 06.08.25.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    
    var backgroundColor: LinearGradient {
        switch message.encryptionMode {
        case .encrypt:
            return Gradient.accentGragient
        case .decrypt:
            return Gradient.basicSubscriptionGradiaent
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if message.encryptionMode == .encrypt { Spacer() }
            
            Text(message.resultText)
                .font(.caption2)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .foregroundStyle(Color.white)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(backgroundColor)
                }
            
            if message.encryptionMode == .decrypt { Spacer() }
        }
        .padding(.leading, message.encryptionMode == .encrypt ? 16 : 0)
        .padding(.trailing, message.encryptionMode == .decrypt ? 16 : 0)
    }
}

