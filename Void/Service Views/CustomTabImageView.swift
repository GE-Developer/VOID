//
//  CustomTabImageView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

// MARK: - TabViewSection
struct CustomTabImageView<Tab: View>: View {
    private let title: String
    private let subtitle: String
    private let headerImage: Image
    private let tabHeight: CGFloat
    
    @ViewBuilder private let tab: () -> Tab
    
    init(
        title: String,
        subtitle: String,
        headerImage: Image,
        tabHeight: CGFloat = 230,
        @ViewBuilder _ tab: @escaping () -> Tab
    ) {
        self.title = title
        self.subtitle = subtitle
        self.headerImage = headerImage
        self.tabHeight = tabHeight
        self.tab = tab
    }
    
    var body: some View {
        customTabImageView
    }
}

// MARK: - Builder
extension CustomTabImageView {
    private var customTabImageView: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider()
                .padding(.horizontal)
                .padding(.vertical, 6)
            TabView {
                tab()
            }
            .frame(height: tabHeight)
            .overlay(gradientCurtains)
        }
        .padding(.bottom, 6)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
    
    private var header: some View {
        HStack(spacing: 10) {
            headerImage
                .font(.footnote)
                .frame(width: 28, height: 28)
                .foregroundStyle(Gradient.accent)
                .overlay {
                    Circle().stroke(Gradient.accent, lineWidth: 1)
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.void.mainText)
                Text(subtitle)
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(Color.void.secondaryText)
            }
            .fontDesign(.rounded)
            .lineLimit(2)
            .minimumScaleFactor(0.85)
            .multilineTextAlignment(.leading)
        }
        .frame(height: 75)
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
    
    private var gradientCurtains: some View {
        HStack(spacing: 0) {
            let colors = [
                Color(.secondarySystemGroupedBackground),
                Color(.secondarySystemGroupedBackground).opacity(0)
            ]
            
            LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                .frame(width: 18)
            Spacer()
            LinearGradient(colors: colors, startPoint: .trailing, endPoint: .leading)
                .frame(width: 18)
        }
    }
}
