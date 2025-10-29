//
//  CopyAlertView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct CopyAlertView: View {
    @State private var isActive = false
    
    var body: some View {
        copyAlertView
    }
}

// MARK: - Builder
extension CopyAlertView {
    private var copyAlertView: some View {
        HStack {
            Image.system.chechmark
                .foregroundStyle(isActive ? Gradient.green : Gradient.gray)
                .animation(.easeIn(duration: 0.2).delay(0.2), value: isActive)
            Text(L10n("Alert.сopied"))
                .foregroundStyle(Color.void.secondaryText)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(background)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .onAppear {
            withAnimation { isActive = true }
        }
        .onDisappear {
            isActive = false
        }
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.ultraThinMaterial)
            .shadow(color: .void.navBarShadow, radius: 1)
    }
}
