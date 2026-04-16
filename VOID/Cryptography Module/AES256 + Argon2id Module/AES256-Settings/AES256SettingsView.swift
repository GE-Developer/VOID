//
//  AES256SettingsView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct AES256SettingsView: View {
    @StateObject private var vm: AES256SettingsViewModel
    @State private var showVoid = false
    @State private var showInfo = false
    @State private var showPayWall = false
    
    @State var premiumAnimation = false
    
    @EnvironmentObject private var store: StoreManager
    
    init(vm: AES256EncryptionViewModel) {
        _vm = StateObject(wrappedValue: AES256SettingsViewModel(mainVM: vm))
    }
    
    var body: some View {
        settingsView
            .onChange(of: vm.parameters) {
                vm.commitChanges()
            }
            .navigationDestination(isPresented: $showVoid) {
                NavigationLazyView(VoidNumbersView(vm: vm))
            }
            .navigationDestination(isPresented: $showInfo) {
                NavigationLazyView(AboutEncryptionView(vm: AboutAES256ViewModel()))
            }
            .fullScreenCover(isPresented: $showPayWall) {
                NavigationLazyView(PayWallView(store))
            }
    }
}

// MARK: - Builder
extension AES256SettingsView {
    private var settingsView: some View {
        CustomScrollView(withTarget: true) {
            CustomNavigationTitle(
                title: vm.title,
                subTitle: vm.subTitle,
                isLargeNavBar: $0
            )
            Spacer()
            NavigationToolButton(.system.info) {
                showInfo = true
            }
        } headerView: {
            passwordForm
                .offset(y: min($0, 0))
        } scrollView: { _ in
            VStack(spacing: 25) {
                dividerMessage
                saltForm
                iterationsForm
                memoryForm
                parallelismForm
                keyLengthForm
                layersForm
                timerForm
            }
        }
    }
    
    private var passwordForm: some View {
        CustomForm(headerText: vm.secutityTitle) {
            CustomSecureField(
                password: $vm.parameters.password,
                placeholder: vm.passwordPlaceholder
            )
            Divider()
                .padding(.leading, 50)
            
            CustomButtonRow(
                icon: .system.key(),
                title: vm.voidTitle,
                subtitle: vm.voidSubtitle,
                additionalTitle: "#\(vm.parameters.voidIndex)",
                isLink: true,
                action: { showVoid = true }
            )
        }
    }
    
    private var dividerMessage: some View {
        VStack {
            Text(vm.dividerMessage)
                .foregroundStyle(Color.void.secondaryText)
                .font(.headline)
                .fontDesign(.rounded)
                .textCase(.uppercase)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            Divider()
        }
        .padding(.horizontal)
    }
    
    private var saltForm: some View {
        CustomForm(headerText: vm.saltTitle) {
            formHeaderView(vm.saltDescription, isPremium: false)
        } content: {
            CustomSliderRow(
                value: $vm.parameters.salt,
                availableValues: vm.saltValues,
                labels: vm.saltLabels
            )
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.saltInstructions)
        }
    }
    
    private var iterationsForm: some View {
        CustomForm(headerText: vm.iterationsTitle) {
            formHeaderView(vm.parameters.iterations)
        } content: {
            CustomSliderRow(
                value: $vm.parameters.iterations,
                availableValues: vm.iterationsValues,
                labels: vm.iterationsLabels
            )
            .premiumOption($showPayWall, swipable: true)
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.iterationsInstructions)
        }
    }
    
    private var memoryForm: some View {
        CustomForm(headerText: vm.memoryTitle) {
            formHeaderView(vm.memoryDescription)
        } content: {
            CustomSliderRow(
                value: $vm.parameters.memory,
                availableValues: vm.memoryValues,
                labels: vm.memoryLabels
            )
            .premiumOption($showPayWall, swipable: true)
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.memoryInstructions)
        }
    }
    
    private var parallelismForm: some View {
        CustomForm(headerText: vm.parallelismTitle) {
            formHeaderView(vm.parameters.parallelism)
        } content: {
            CustomSliderRow(
                value: $vm.parameters.parallelism,
                availableValues: vm.parallelismValues,
                labels: vm.parallelismLabels
            )
            .premiumOption($showPayWall, swipable: true)
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.parallelismInstructions)
        }
    }
    
    private var keyLengthForm: some View {
        CustomForm(headerText: vm.keyLengthTitle) {
            formHeaderView(vm.keyLengthDescription)
        } content: {
            CustomSliderRow(
                value: $vm.parameters.keyLength,
                availableValues: vm.keyLengthValues,
                labels: vm.keyLenghtLabels
            )
            .premiumOption($showPayWall, swipable: true)
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.keyLengthInstructions)
        }
    }
    
    private var layersForm: some View {
        CustomForm(headerText: vm.layersTitle) {
            formHeaderView(vm.parameters.actualLayers)
        } content: {
            HStack(spacing: 8) {
                CustomTextRow(vm.layersSubtitle)
                Stepper("", value: $vm.parameters.layers, in: vm.layersRange)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .premiumOption($showPayWall)
            }
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.layersInstructions)
        }
    }
    
    private var timerForm: some View {
        CustomForm(headerText: vm.timerTitle) {
            PremiumView(.textAndStar)
                .onTapGesture {
                    showPayWall = true
                }
        } content: {
            CustomToggleRow(
                isOn: $vm.parameters.isTimerEnabled,
                icon: .system.timer,
                title: vm.timerSubtitle
            )
            .premiumOption($showPayWall)

            if vm.parameters.isTimerEnabled {
                Divider()
                    .padding(.leading, 50)
                
                TimerPicker(
                    selectedHours: $vm.parameters.selectedHours,
                    selectedMinutes: $vm.parameters.selectedMinutes
                )
                .padding(.vertical)
            }
            
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.timerInstuctions)
        }
    }
    
    private func formHeaderView(_ description: Any, isPremium: Bool = true) -> some View {
        HStack {
            if isPremium {
                PremiumView(.textAndStar)
                    .onTapGesture {
                        showPayWall = true
                    }
            }
            if store.isPremium || !isPremium {
                FormHeaderContent("\(description)")
            }
        }
    }
}
