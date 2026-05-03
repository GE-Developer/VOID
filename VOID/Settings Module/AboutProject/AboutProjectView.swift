//
//  AboutProjectView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct AboutProjectView: View {
    private let vm = AboutProjectViewModel()
    
    var body: some View {
        aboutProjectView
    }
}

// MARK: - Builder
extension AboutProjectView {
    private var aboutProjectView: some View {
        CustomScrollView(title: vm.title) {
            EmptyView()
        } content: { _ in
            VStack(spacing: 25) {
                sourceCodeForm
                aboutProjectForm
                developerMichaelForm
            }
        }
    }
    
    private var aboutProjectForm: some View {
        CustomForm(headerText: vm.aboutProjectTitle) {
            CustomTextRow(vm.aboutProjectDescription)
        }
    }
    
    private var sourceCodeForm: some View {
        CustomForm(headerText: vm.sourseCodeTitle) {
            CustomButtonRow(
                circleImage: Image.other.gitHub,
                title: vm.gitHubButtonTitle,
                subtitle: vm.gitHubButtonSubtitle,
                action: { vm.gitHubButtonPressed() }
            )
        }
    }
    
    private var developerMichaelForm: some View {
        CustomForm(headerText: vm.developersTitle) {
            CustomButtonRow(
                circleImage: Image.other.iosDeveloperMichael,
                title: vm.developerMichaelButtonTitle,
                subtitle: vm.developerMichaelButtonSubtitle,
                action: { vm.developerMichaelButtonPressed() }
            )
            Divider().padding(.horizontal)
            CustomTextRow(vm.otherInfo)
        }
    }
}
