//
//  TabBarState.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

@Observable
final class TabBarState {
    var selectedTab: RootTab = .cryptography

    private(set) var cryptoDepth: Int = 0
    private(set) var settingsDepth: Int = 0

    var isVisible: Bool {
        switch selectedTab {
        case .cryptography:
            cryptoDepth == 0
        case .settings:
            settingsDepth == 0
        }
    }

    let height: CGFloat = 65

    func enterStack(for tab: RootTab) {
        switch tab {
        case .cryptography:
            cryptoDepth += 1
        case .settings:
            settingsDepth += 1
        }
    }

    func exitStack(for tab: RootTab) {
        switch tab {
        case .cryptography:
            cryptoDepth = max(0, cryptoDepth - 1)
        case .settings:
            settingsDepth = max(0, settingsDepth - 1)
        }
    }

    enum RootTab: Int, CaseIterable, Identifiable {
        case cryptography
        case settings

        var id: Int { rawValue }
    }
}
