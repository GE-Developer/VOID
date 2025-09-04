//
//  CustomNavigationBar.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomNavigationBar: View {
    private let title: String
    private let subTitle: String?
    private let isLarge: Bool
    private let alignment: HorizontalAlignment
    private let multilineAlignment: TextAlignment
    
    init(title: String,
         subTitle: String? = nil,
         isLarge: Bool,
         alignment: HorizontalAlignment = .leading,
         multilineAlignment: TextAlignment = .leading) {
        self.title = title
        self.subTitle = subTitle
        self.isLarge = isLarge
        self.alignment = alignment
        self.multilineAlignment = multilineAlignment
    }
    
    var body: some View {
        navigationBar
    }
}

// MARK: - Builder
extension CustomNavigationBar {
    private var navigationBar: some View {
        VStack(alignment: alignment) {
            mainTitle
            secondaryTitle
        }
        .fontDesign(.rounded)
        .animation(.easeInOut(duration: 0.25), value: subTitle)
    }
    
    private var mainTitle: some View {
        Text(title)
            .font(isLarge ? .title : .title3)
            .fontWeight(.semibold)
            .foregroundStyle(Color.navigation.accentOne)
            .multilineTextAlignment(multilineAlignment)
    }
    
    private var secondaryTitle: some View {
        Group {
            if isLarge, let subTitle {
                Text(subTitle)
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(Color.navigation.secondaryTitle)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
