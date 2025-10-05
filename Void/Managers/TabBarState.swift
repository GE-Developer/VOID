//
//  TabBarState.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUICore

final class TabBarState: ObservableObject {
    @Published var isVisible: Bool = true
    @Published var selectedTab: RootTab = .cryptography
    
    let height: CGFloat = 65
    
    enum RootTab: Int, CaseIterable, Identifiable {
        case cryptography
        case settings
        
        var id: Int { rawValue }
    }
}
