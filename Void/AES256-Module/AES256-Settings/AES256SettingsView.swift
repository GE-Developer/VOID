//
//  AES256SettingsView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct AES256SettingsView: View {
    @StateObject private var vm: AES256SettingsViewModel
    
    init(vm: AES256EncryptionViewModel) {
        _vm = StateObject(wrappedValue: AES256SettingsViewModel(mainVM: vm))
    }
    
    var body: some View {
        settingsView
            .onDisappear(perform: vm.commitChanges)
    }
}

// MARK: - Builder
extension AES256SettingsView {
    private var settingsView: some View {
        CustomScrollView(headerHight: 150) { isLarge in
            CustomNavigationBar(
                title: vm.title,
                subTitle: vm.subTitle,
                isLarge: isLarge
            )
            Spacer()
        } headerView: { minY in
            passwordForm
                .offset(y: min(minY, 0))
        } scrollView: {
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
            CustomSecureFieldRow(
                password: $vm.parameters.password,
                placeholder: vm.passwordPlaceholder
            )
            Divider()
                .padding(.leading, 50)
            
            CustomButtonRow(
                icon: .system.key,
                title: vm.voidTitle,
                subtitle: vm.voidSubtitle,
                additionalTitle: "#51",
                destination: ContentView1()
            )
        }
    }
    
    private var dividerMessage: some View {
        VStack {
            Text(vm.dividerMessage)
                .foregroundStyle(Color.main.secondaryText)
                .font(.headline)
                .fontDesign(.rounded)
                .textCase(.uppercase)
                .minimumScaleFactor(0.5)
            Divider()
        }
        .padding(.horizontal)
    }
    
    private var saltForm: some View {
        CustomForm(headerText: vm.saltTitle) {
            CustomFormContentText(vm.saltDescription)
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
            CustomFormContentText("\(vm.parameters.iterations)")
        } content: {
            CustomSliderRow(
                value: $vm.parameters.iterations,
                availableValues: vm.iterationsValues,
                labels: vm.iterationsLabels
            )
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.iterationsInstructions)
        }
    }
    
    private var memoryForm: some View {
        CustomForm(headerText: vm.memoryTitle) {
            CustomFormContentText(vm.memoryDescription)
        } content: {
            CustomSliderRow(
                value: $vm.parameters.memory,
                availableValues: vm.memoryValues,
                labels: vm.memoryLabels
            )
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.memoryInstructions)
        }
    }
    
    private var parallelismForm: some View {
        CustomForm(headerText: vm.parallelismTitle) {
            CustomFormContentText("\(vm.parameters.parallelism)")
        } content: {
            CustomSliderRow(
                value: $vm.parameters.parallelism,
                availableValues: vm.parallelismValues,
                labels: vm.parallelismLabels
            )
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.parallelismInstructions)
        }
    }
    
    private var keyLengthForm: some View {
        CustomForm(headerText: vm.keyLengthTitle) {
            CustomFormContentText(vm.keyLengthDescription)
        } content: {
            CustomSliderRow(
                value: $vm.parameters.keyLength,
                availableValues: vm.keyLengthValues,
                labels: vm.keyLenghtLabels
            )
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.keyLengthInstructions)
        }
    }
    
    private var layersForm: some View {
        CustomForm(headerText: vm.layersTitle) {
            CustomFormContentText("\(vm.parameters.actualLayers)")
        } content: {
            HStack(spacing: 8) {
                CustomTextRow(vm.layersSubtitle)
                Spacer()
                Stepper("", value: $vm.parameters.layers, in: vm.layersRange)
                    .padding(.trailing)
            }
            Divider()
                .padding(.horizontal)
            CustomTextRow(vm.layersInstructions)
        }
    }
    
    private var timerForm: some View {
        CustomForm(headerText: vm.timerTitle) {
            CustomToggleRow(
                isOff: $vm.parameters.dateInactive,
                icon: .system.timer,
                title: vm.timerSubtitle
            )
            
            if !vm.parameters.dateInactive {
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
}
