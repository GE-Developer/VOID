//
//  FullScreenLoader.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct FullScreenLoader: View {
    private let animationTitle = "VOID"
    private let title = L10n("FullScreenAnimation.title")
    private let subtitle = L10n("FullScreenAnimation.subtitle")
    
    var body: some View {
        fullScreenLoader
    }
}

// MARK: - Builder
extension FullScreenLoader {
    private var fullScreenLoader: some View {
        ZStack {
            background
            CustomForm {
                VStack(spacing: 16) {
                    voidAnimation
                    Divider()
                    notificationMessage
                }
                .padding()
            }
            .shadow(color: Color.void.viewShadow, radius: 10)
            .padding(30)
        }
    }
    
    private var background: some View {
        Rectangle()
            .foregroundStyle(.ultraThinMaterial)
            .ignoresSafeArea()
    }
    
    private var text: some View {
        Text(animationTitle)
            .font(.system(size: 100, weight: .heavy, design: .rounded))
    }
    
    private var voidAnimation: some View {
        text
            .foregroundStyle(Color(.secondarySystemGroupedBackground).opacity(0.99))
            .shadow(color: Color.void.blackAndWhite, radius: 0.3, y: 0.7)
            .frame(height: 80)
            .overlay {
                MatrixAnimationView(.eas256, color: Color.void.blackAndWhite, letterSize: 7, columnSpacing: 0, rowSpacing: 0, updateDelay: 20, speedRange: 3...6)
                    .mask(text)
            }
    }
    
    private var notificationMessage: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.void.mainText)
            Text(subtitle)
                .foregroundStyle(Color.void.secondaryText)
                .font(.subheadline)
        }
        .multilineTextAlignment(.center)
        .fontWeight(.light)
        .fontDesign(.rounded)
    }
}
