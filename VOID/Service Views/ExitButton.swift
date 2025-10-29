//
//  ExitButton.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct ExitButton: View {
    @Environment(\.dismiss) private var dismiss
    
    private let haptic = HapticsManager.shared
    
    var body: some View {
        Button(action: dismissPressed) {
            Image.system.xmark
                .font(.title2)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(10)
                .background {
                    Circle()
                        .foregroundStyle(.ultraThinMaterial)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.gray)
                        }
                        .shadow(color: .white.opacity(0.6), radius: 1)
                }
        }
    }
    
    private func dismissPressed() {
        haptic.impact(style: .rigid)
        dismiss()
    }
}
