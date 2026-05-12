//
//  SettingsView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: StoreManager
    @EnvironmentObject private var tabBarState: TabBarState
    
    @StateObject private var vm = SettingsViewModel()
    
    @State private var languageViewPresented = false
    @State private var showPayWall = false
    @State private var projectViewPresented = false
    @State private var showStyleView = false
    @State private var showAppIconView = false
    @State private var showClearDataAlert = false
    @State private var showResetSettingsAlert = false
    
    init() {
        UIScrollView.appearance().delaysContentTouches = false
    }
    
    var body: some View {
        settingsView
            .navigationDestination(isPresented: $languageViewPresented) {
                NavigationLazyView(LanguageView())
            }
            .navigationDestination(isPresented: $projectViewPresented) {
                NavigationLazyView(AboutProjectView())
            }
            .navigationDestination(isPresented: $showStyleView) {
                NavigationLazyView(StyleView())
            }
            .navigationDestination(isPresented: $showAppIconView) {
                NavigationLazyView(AppIconView())
            }
            .fullScreenCover(isPresented: $showPayWall) {
                NavigationLazyView(PayWallView(store))
            }
            .alert(
                Text(vm.clearDataAlertTitle),
                isPresented: $showClearDataAlert,
                actions: { clearDataAlertActions },
                message: { Text(vm.clearDataAlertMessage) }
            )
            .alert(
                Text(vm.resetSettingsAlertTitle),
                isPresented: $showResetSettingsAlert,
                actions: { resetSettingsAlertActions },
                message: { Text(vm.resetSettingsAlertMessage) }
            )
            .onAppear { vm.refreshStorageSize() }
    }
}

// MARK: - Builder
extension SettingsView {
    private var settingsView: some View {
        CustomScrollView(title: vm.title, withBackButton: false, tabBarIsVisible: true) {
            logo
                .frame(height: 18)
                .opacity(0.5)
                .offset(y: 2)
        } content: { _ in
            VStack(spacing: 25) {
                CustomForm(headerText: vm.generalSettingsTitle) {
                    themeToggle
                    Divider().padding(.leading, 50)
                    languageButton
                    Divider().padding(.leading, 50)
                    vibrationToggle
                    Divider().padding(.leading, 50)
                    soundToggle
                }
                
                CustomForm(headerText: vm.accessTitle) {
                    PremiumView(.status)
                } content: {
                    subscriptionButton
                    Divider().padding(.leading, 50)
                    reviewButton
                }
                
                CustomForm(headerText: vm.storageTitle) {
                    clearDataButton
                    Divider().padding(.leading, 50)
                    resetSettingsButton
                }
                
                CustomForm(headerText: vm.safetyTitle) {
                    PremiumView(.textAndStar)
                } content: {
                    screenshotProtectionToggle
                }
                
                CustomForm(headerText: vm.customizationTitle) {
                    styleButton
                    Divider().padding(.leading, 50)
                    appIconButton
                }
                
                CustomForm(headerText: vm.aboutAppTitle) {
                    termsOfUseButton
                    Divider().padding(.leading, 50)
                    privacyPolicyButton
                    Divider().padding(.leading, 50)
                    projectButton
                }
                
                AppVersion()
            }
            .padding(.bottom, tabBarState.height)
        }
    }
    
    private var themeToggle: some View {
        CustomToggleRow(
            isOn: $vm.isDarkMode,
            icon: .system.darkMode,
            title: vm.darkModeTitle
        )
    }
    
    private var languageButton: some View {
        Group {
            if vm.language == "English" {
                CustomButtonRow(
                    icon: .system.language,
                    title: vm.languageTitle,
                    additionalTitle: vm.language,
                    isLink: true,
                    action: { languageViewPresented.toggle() }
                )
            } else {
                CustomButtonRow(
                    icon: .system.language,
                    title: vm.languageTitle,
                    subtitle: vm.languageSubtitle,
                    additionalTitle: vm.language,
                    isLink: true,
                    action: { languageViewPresented.toggle() }
                )
            }
        }
    }
    
    private var vibrationToggle: some View {
        CustomToggleRow(
            isOn: $vm.isHapticsOn,
            icon: .system.vibration,
            title: vm.hapticsTitle
        )
    }
    
    private var soundToggle: some View {
        CustomToggleRow(
            isOn: $vm.isSoundOn,
            icon: .system.sound,
            title: vm.soundTitle
        )
    }
    
    private var subscriptionButton: some View {
        CustomButtonRow(
            icon: .system.subscription,
            title: vm.subscriptionTitle,
            isLink: true,
            action: { showPayWall.toggle() }
        )
    }
    
    private var reviewButton: some View {
        CustomButtonRow(
            icon: .system.reviewLike,
            title: vm.reviewTitle,
            action: { vm.rateApp() }
        )
    }
    
    private var screenshotProtectionToggle: some View {
        CustomToggleRow(
            isOn: $vm.isScreenshotProtectionOn,
            icon: .system.eyeSlash,
            title: vm.screenshotProtectionTitle
        )
        .premiumOption($showPayWall)
    }
    
    private var styleButton: some View {
        CustomButtonRow(
            icon: .system.paintpalette,
            title: vm.styleTitle,
            isLink: true,
            action: { showStyleView.toggle() }
        )
    }
    
    private var appIconButton: some View {
        CustomButtonRow(
            icon: .system.appIcon,
            title: vm.appIconTitle,
            isLink: true,
            action: { showAppIconView.toggle() }
        )
    }
    
    private var termsOfUseButton: some View {
        CustomButtonRow(
            icon: .system.termsOfUse,
            title: vm.termsOfUseTitle,
            action: { vm.showTermsOfUse() }
        )
    }
    
    private var privacyPolicyButton: some View {
        CustomButtonRow(
            icon: .system.privacyPolicy,
            title: vm.privacyPolicyTitle,
            action: { vm.showPrivacyPolicy() }
        )
    }
    
    private var projectButton: some View {
        CustomButtonRow(
            icon: .system.developerTool,
            title: vm.projectTitle,
            isLink: true,
            action: { projectViewPresented.toggle() }
        )
    }
    
    private var clearDataButton: some View {
        CustomButtonRow(
            icon: .system.trash,
            title: vm.clearDataTitle,
            subtitle: vm.storageSize,
            action: { showClearDataAlert.toggle() }
        )
    }
    
    private var clearDataAlertActions: some View {
        Group {
            Button(vm.clearDataAlertActionTitle, role: .destructive) {
                vm.clearStorage()
            }
            Button(vm.alertCancelTitle, role: .cancel) {}
        }
    }
    
    private var resetSettingsButton: some View {
        CustomButtonRow(
            icon: .system.reset,
            title: vm.resetSettingsTitle,
            action: { showResetSettingsAlert.toggle() }
        )
    }
    
    private var resetSettingsAlertActions: some View {
        Group {
            Button(vm.resetSettingsAlertActionTitle, role: .destructive) {
                vm.resetUserDefaults(store: store)
            }
            Button(vm.alertCancelTitle, role: .cancel) {}
        }
    }
}
