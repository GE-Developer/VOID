//
//  AppIconViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation

final class AppIconViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var showError = false
    
    @Published private(set) var currentIcon = AppIconManager.currentIcon()
    
    let title = L10n("Settings.Customization.AppIcon.title")
    let defaultFormTitle = L10n("Settings.Customization.AppIcon.defaultIconTitle")
    let alternativeFormTitle = L10n("Settings.Customization.AppIcon.alternativeIconTitle")
    let errorTitle = L10n("Error.title")
    let errorMessage = L10n("Error.iconChangingFailure")

    let defaulIcon = AppIcon.blackVoid
    let alternativeIcons = AppIcon.premiumIcons
    
    private let haptic = HapticsManager.shared

    @MainActor
    func selectIcon(_ icon: AppIcon) {
        guard currentIcon != icon else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        Task {
            do {
                try await AppIconManager.setIcon(icon)
                currentIcon = icon
            } catch {
                showError = true
            }
        }
        
        haptic.impact(style: .rigid)
    }
    
    func isCurrent(_ icon: AppIcon) -> Bool {
        currentIcon == icon
    }
}
