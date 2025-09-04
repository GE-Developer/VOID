//
//  SettingsView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()

    init() {
        UIScrollView.appearance().delaysContentTouches = false
    }
        
    var body: some View {
        settingsView
    }
}

// MARK: - BUILDER
extension SettingsView {
    private var settingsView: some View {
        CustomScrollView { isLarge in
            CustomNavigationBar(title: vm.title, isLarge: isLarge)
            Spacer()
        } scrollView: {
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
                    EmptyView()
                } content: {
                    subscriptionButton
                    Divider().padding(.leading, 50)
                    purchasesButton
                    Divider().padding(.leading, 50)
                    reviewButton
                }

                CustomForm(headerText: vm.aboutAppTitle) {
                    termsOfUseButton
                    Divider().padding(.leading, 50)
                    privacyPolicyButton
                    Divider().padding(.leading, 50)
                    projectButton
                }
                
                appVersionView
            }
        }
    }
    
    private var themeToggle: some View {
        CustomToggleRow(
            isOff: $vm.isThemeLight,
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
                    destination: LanguageView()
                )
            } else {
                CustomButtonRow(
                    icon: .system.language,
                    title: vm.languageTitle,
                    subtitle: vm.languageSubtitle,
                    additionalTitle: vm.language,
                    destination: LanguageView()
                )
            }
        }
    }
    
    private var vibrationToggle: some View {
        CustomToggleRow(
            isOff: $vm.isHapticsOff,
            icon: .system.vibration,
            title: vm.hapticsTitle
        )
    }
    
    private var soundToggle: some View {
        CustomToggleRow(
            isOff: $vm.isSoundOff,
            icon: .system.sound,
            title: vm.soundTitle
        )
    }
    
    private var subscriptionButton: some View {
        CustomButtonRow(
            icon: .system.subscription,
            title: vm.subscriptionTitle,
            destination: ContentView1()
        )
    }
    
    private var purchasesButton: some View {
        CustomButtonRow(
            icon: .system.restorePurchases,
            title: vm.restorePurchasesTitle,
            action: { }
        )
    }
    
    private var reviewButton: some View {
        CustomButtonRow(
            icon: .system.reviewLike,
            title: vm.reviewTitle,
            action: { }
            )
    }
    
    private var termsOfUseButton: some View {
        CustomButtonRow(
            icon: .system.termsOfUse,
            title: vm.termsOfUseTitle,
            action: { }
        )
    }
    
    private var privacyPolicyButton: some View {
        CustomButtonRow(
            icon: .system.privacyPolicy,
            title: vm.privacyPolicyTitle,
            action: { }
        )
    }
    
    private var projectButton: some View {
        CustomButtonRow(
            icon: .system.developerTool,
            title: vm.projectTitle,
            destination: ContentView1()
        )
    }
    
    private var appVersionView: some View {
        VStack {
            Text(vm.appVersionTitle)
            Text(vm.appVersion)
        }
        .foregroundStyle(Color.main.secondaryText)
        .font(.caption)
        .fontDesign(.monospaced)
        .padding(.horizontal, 6)
        .onTapGesture(count: 1) {
//            SoundManager.shared.playSound()
        }
    }
}
