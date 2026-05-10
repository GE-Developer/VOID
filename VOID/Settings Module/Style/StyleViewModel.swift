//
//  StyleViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

struct StyleViewModel {
    let colorCases = AccentColorManager.ColorName.allCases
    
    let title = L10n("Settings.Customization.Style.title")
    let headerText = L10n("Settings.Customization.Style.headerTitle")
    
    private let styleManager = AccentColorManager.shared
    private let haptic = HapticsManager.shared
    
    func changeAccent(to colorCase: AccentColorManager.ColorName) {
        haptic.impact(style: .rigid)
        styleManager.currentColor = colorCase
    }
    
    func isCurrent(_ colorCase: AccentColorManager.ColorName) -> Bool {
        styleManager.currentColor == colorCase
    }
}
