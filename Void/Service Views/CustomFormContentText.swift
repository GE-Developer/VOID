//
//  CustomFormContentText.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 30.07.25.
//

import SwiftUI

struct CustomFormContentText: View {
    private var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .foregroundStyle(Gradient.accentGragient)
            .font(.caption)
            .fontDesign(.monospaced)
            .lineLimit(2)
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.trailing)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Gradient.accentGragient)
                    .opacity(0.7)
            }
    }
}
