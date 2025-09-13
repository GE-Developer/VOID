//
//  CustomFormContentText.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomFormContentText: View {
    private var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        customFormContentText
    }
}

// MARK: - Builder
extension CustomFormContentText {
    private var customFormContentText: some View {
        Text(text)
            .foregroundStyle(Gradient.accentGragient)
            .font(.caption)
            .fontDesign(.monospaced)
            .lineLimit(2)
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.trailing)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(background)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(lineWidth: 1)
            .foregroundStyle(Gradient.accentGragient)
            .opacity(0.7)
    }
}
