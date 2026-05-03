//
//  AboutEncryptionView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct AboutEncryptionView: View {
    private let vm: AboutEncryptionProtocol
    private let animationLetterSpacing: CGFloat
    
    init(vm: AboutEncryptionProtocol, _ animationLetterSpacing: CGFloat = 1) {
        self.vm = vm
        self.animationLetterSpacing = animationLetterSpacing
    }
    
    var body: some View {
        aboutAES256View
    }
}

// MARK: - Builder
extension AboutEncryptionView {
    private var aboutAES256View: some View {
        CustomScrollView(title: vm.title, subTitle: vm.subtitle) {
            EmptyView()
        } content: { _ in
            headerAnimation
            aboutContent
        }
    }
    
    private var headerAnimation: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(Color.black)
            .shadow(color: Color.void.blackAndWhite, radius: 1.5)
            .overlay {
                MatrixAnimationView(
                    vm.letterType,
                    color: Gradient.accent,
                    columnSpacing: animationLetterSpacing,
                    rowSpacing: animationLetterSpacing
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(height: 80)
    }
    
    private var aboutContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            blockTitle(vm.firstTitle, Gradient.accent)
                .padding(.top, 20)
            blockDescription(vm.firstDescription, Gradient.accent)
            
            
            if let title = vm.secondTitle, let description = vm.secondDescription {
                blockTitle(title, Gradient.gold)
                    .padding(.top, 20)
                blockDescription(description, Gradient.gold)
            }
            
            if let title = vm.thirdTitle, let description = vm.thirdDescription {
                blockTitle(title, Gradient.accent)
                    .padding(.top, 20)
                blockDescription(description, Gradient.accent)
            }
            
            if let title = vm.fourthTitle, let description = vm.fourthDescription {
                blockTitle(title, Gradient.gold)
                    .padding(.top, 20)
                blockDescription(description, Gradient.gold)
            }
            
            if let title = vm.fifthTitle, let description = vm.fifthDescription {
                blockTitle(title, Gradient.accent)
                    .padding(.top, 20)
                blockDescription(description, Gradient.accent)
            }
        }
    }
    
    private func blockTitle(_ text: String, _ color: LinearGradient) -> some View {
        HStack {
            Circle()
                .frame(width: 4)
                .foregroundStyle(color)
            Text(text)
                .font(.title2)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.mainText)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 8)
        }
    }
    
    private func blockDescription(_ text: String, _ color: LinearGradient) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 2)
                .foregroundStyle(color)
            Text(text.asMarkdown)
                .font(.callout)
                .fontWeight(.light)
                .fontDesign(.rounded)
                .foregroundStyle(Color.void.secondaryText)
                .padding(.horizontal, 8)
        }
    }
}
