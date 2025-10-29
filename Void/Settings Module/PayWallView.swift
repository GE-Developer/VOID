//
//  PayWallView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct PayWallView: View {
    
    private let title = "Unlock Premium Features"
    private let subtitle = "Choose your plan to enjoy unlimited access to all features."
    private let termsOfUse = "Terms of Use"
    private let privacyPolicy = "Privacy Policy"
    private let continueTitle = "Continue"
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                topper(geo)
                payView
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(background)
        .overlay(backButton)
    }
    
    private var background: some View {
        Color.void.background
            .ignoresSafeArea()
    }
    
    private var backButton: some View {
        VStack {
            HStack {
                Spacer()
                ExitButton()
                    .padding()
            }
            Spacer()
        }
    }
    
    private var payView: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text(title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.void.mainText)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.void.secondaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .fontDesign(.rounded)
            .minimumScaleFactor(0.7)
            .padding(.horizontal)
            
            
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color(.secondarySystemGroupedBackground))
                .frame(height: 90)
                .padding(.horizontal)
//            HStack {
//                RoundedRectangle(cornerRadius: 15)
//                    .foregroundStyle(Color.gray)
//                RoundedRectangle(cornerRadius: 15)
//                    .foregroundStyle(Color.gray)
//                RoundedRectangle(cornerRadius: 15)
//                    .foregroundStyle(Color.gray)
//            }
            
            TabView {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(.secondarySystemGroupedBackground))
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(.secondarySystemGroupedBackground))
                    .padding(.horizontal)
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(.secondarySystemGroupedBackground))
                    .padding(.horizontal)
            }
            .tabViewStyle(.page)
            
            continueButton
                .padding(.horizontal)
            
            VStack(spacing: 6) {
                bottomButton(text: privacyPolicy) { }
                bottomButton(text: termsOfUse) { }
            }
            .padding(.horizontal)
        }
        .padding(.top, 6)
    }
    
    private var continueButton: some View {
        Button {
            print("Кнопка нажата")
        } label: {
            Text(continueTitle)
                .font(.title3)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(Gradient.payWallAccent)
                .foregroundStyle(Color.white)
                .clipShape(Capsule())
                .shadow(color: Color.void.mainText, radius: 1)
        }

    }
    
    private func topper(_ geo: GeometryProxy) -> some View {
        ZStack(alignment: .bottom) {
            MatrixAnimationView(.binary, color: Gradient.payWallAccent, letterSize: 12, columnSpacing: 0, rowSpacing: 0, updateDelay: 50, speedRange: 7...8)
                .frame(height: geo.size.height / 2.8)
            Rectangle()
                .frame(height: 40)
                .foregroundStyle(LinearGradient(colors: [.void.background, .void.background.opacity(0.7), Color.clear], startPoint: .bottom, endPoint: .top))
        }
    }
    
    private func bottomButton(text: String, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .fontWeight(.light)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.secondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}
