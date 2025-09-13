//
//  CustomScrollView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomScrollView<Header: View, Scroll: View, Title: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var offsetY = 0.0
    @State private var headerHeight = 0.0
    
    private var scrollBehavior: TargetBehaviour {
        .init(headerHeight, largeNavBarHeight, smallNavBarHeight)
    }
    
    private var isLargeNavBar: Bool {
        -offsetY < 8
    }
    
    private var scrollMargins: Double {
        min(max(offsetY + 2, -headerHeight - smallNavBarHeight + 8 + 5),2)
    }
    
    private let withBackButton: Bool
    private let largeNavBarHeight = 70.0
    private let smallNavBarHeight = 50.0
    
    @ViewBuilder private let titleHStackView: (_ isLargeNavBar: Bool) -> Title
    @ViewBuilder private let headerView: (_ minY: CGFloat) -> Header
    @ViewBuilder private let scrollView: (_ proxy: ScrollViewProxy) -> Scroll
    
    init(
        withBackButton: Bool = true,
        @ViewBuilder titleHStackView: @escaping (_ isLargeNavBar: Bool) -> Title,
        @ViewBuilder headerView: @escaping (_ minY: CGFloat) -> Header = { _ in EmptyView() },
        @ViewBuilder scrollView: @escaping (_ proxy: ScrollViewProxy) -> Scroll
    ) {
        self.withBackButton = withBackButton
        self.titleHStackView = titleHStackView
        self.headerView = headerView
        self.scrollView = scrollView
    }
    
    var body: some View {
        customScrollView
    }
}

// MARK: - Builder
extension CustomScrollView {
    private var customScrollView: some View {
        ZStack(alignment: .top) {
            background.zIndex(0)
            navigationBar.zIndex(3)
            header.zIndex(2)
            scroll.zIndex(1)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
    
    private var background: some View {
        Color.main.background
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private var backButton: some View {
        if withBackButton {
            Button {
                dismiss()
            } label: {
                Image.system.back
                    .fontWeight(.light)
                    .padding(10)
                    .foregroundStyle(Color.navigation.backButton)
                    .frame(width: 20)
                    .background { Color.clear }
            }
        }
    }
    
    private var navigationBar: some View {
        ZStack {
            UnevenRoundedRectangle(
                bottomLeadingRadius: isLargeNavBar ? 0 : 10,
                bottomTrailingRadius: isLargeNavBar ? 0 : 10
            )
            .ignoresSafeArea()
            .foregroundStyle(.ultraThinMaterial)
            .opacity(isLargeNavBar ? 0 : 1)
            .shadow(color: Color.navigation.navBarShadow, radius: isLargeNavBar ? 0 : 5)
            
            HStack {
                backButton
                titleHStackView(isLargeNavBar)
            }
            .padding(.horizontal)
        }
        .frame(height: isLargeNavBar ? largeNavBarHeight : smallNavBarHeight)
        .animation(.easeOut(duration: 0.2), value: isLargeNavBar)
    }
    
    private var header: some View {
        headerView(offsetY)
            .getHeight($headerHeight)
            .safeAreaPadding(.top, largeNavBarHeight + 8)
            .safeAreaPadding(.horizontal)
    }
    
    private var geometryReader: some View {
        GeometryReader { geo in
            let offset = geo.frame(in: .scrollView(axis: .vertical)).minY
            Color.clear
                .onChange(of: offset) {
                    offsetY = offset
                }
        }
        .frame(height: 0)
    }
    
    private var scroll: some View {
        ScrollViewReader { proxy in
            ScrollView {
                geometryReader
                scrollView(proxy)
            }
        }
        .safeAreaPadding(.horizontal)
        .safeAreaPadding(.top, largeNavBarHeight + headerHeight + 16)
        .scrollDismissesKeyboard(.interactively)
        .scrollTargetBehavior(scrollBehavior)
        .contentMargins(.top, scrollMargins, for: .scrollIndicators)
    }
}

// MARK: - ScrollTargetBehavior
fileprivate struct TargetBehaviour: ScrollTargetBehavior {
    private let headerHeight: Double
    private let largeNavBarHeight: Double
    private let smallNavBarHeight: Double
    
    init(
        _ headerHeight: Double,
        _ largeNavBarHeight: Double,
        _ smallNavBarHeight: Double
    ) {
        self.headerHeight = headerHeight
        self.largeNavBarHeight = largeNavBarHeight
        self.smallNavBarHeight = smallNavBarHeight
    }
    
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        let fullHeader = headerHeight + 8 + largeNavBarHeight - smallNavBarHeight
        let halfHeader = headerHeight / 2 + 8 + largeNavBarHeight - smallNavBarHeight
        
        switch target.rect.minY {
        case 0 ..< halfHeader:
            target.rect.origin = .zero
        case halfHeader ..< fullHeader:
            target.rect.origin = .init(x: 0, y: fullHeader)
        default:
            break
        }
    }
}
