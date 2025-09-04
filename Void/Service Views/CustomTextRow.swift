//
//  CustomTextRow.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 30.07.25.
//

import SwiftUI

struct CustomTextRow: View {
    private let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Text(text)
            .foregroundStyle(Color.main.secondaryText)
            .font(.caption)
            .fontDesign(.rounded)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
                .padding(.vertical, 10)
            Spacer()
        }
    }
}
