//
//  CustomTabBar.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomTabBar: View {
    @EnvironmentObject private var tabBarState: TabBarState
    
    private let haptics = HapticsManager.shared
    
    var body: some View {
        customTabBar
    }
}

// MARK: - Builder
extension CustomTabBar {
    private var customTabBar: some View {
        HStack(spacing: 7) {
            let tabs = TabBarState.RootTab.allCases
            
            ForEach(tabs) { tab in
                icon(for: tab)
                divider(after: tab, in: tabs)
            }
        }
        .padding(.horizontal, 15)
        .frame(height: tabBarState.height)
        .background(background)
        .overlay(overlayStroke)
        .padding(.horizontal, 80)
        .offset(y: tabBarState.isVisible ? 0 : 80)
        .opacity(tabBarState.isVisible ? 1 : 0)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: tabBarState.isVisible)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(.ultraThinMaterial)
            .shadow(color: Color.void.navBarShadow, radius: 2)
    }
    
    private var overlayStroke: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.void.background.opacity(0.7), lineWidth: 0.1)
    }
    
    private func icon(for tab: TabBarState.RootTab) -> some View {
        Group {
            switch tab {
            case .cryptography:
                Image.system.key(tab == tabBarState.selectedTab)
                    .rotationEffect(.degrees(tab == tabBarState.selectedTab ? 90 : 0))
                    .fontWeight(tab == tabBarState.selectedTab ? .regular : .light)
            case .settings:
                Image.system.gear
                    .rotationEffect(.degrees(tab == tabBarState.selectedTab ? 120 : 0))
                    .fontWeight(tab == tabBarState.selectedTab ? .bold : .regular)
            }
        }
        .font(.title2)
        .foregroundColor(tabBarState.selectedTab == tab ? Color.void.accentDark : Color.void.grayDark)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .animation(.bouncy, value: tabBarState.selectedTab)
        .onTapGesture { tapGesture(on: tab) }
    }
    
    @ViewBuilder
    private func divider(after tab: TabBarState.RootTab, in tabs: [TabBarState.RootTab]) -> some View {
        if tab != tabs.last {
            Divider()
                .padding(.vertical, 20)
                .foregroundStyle(Color.void.grayLight)
        }
    }
}

// MARK: - Logic
extension CustomTabBar {
    private func tapGesture(on tab: TabBarState.RootTab) {
        guard tabBarState.selectedTab != tab else { return }
        withAnimation(.easeIn.speed(4)) {
            tabBarState.selectedTab = tab
        }
        haptics.selectionChanged()
    }
}
