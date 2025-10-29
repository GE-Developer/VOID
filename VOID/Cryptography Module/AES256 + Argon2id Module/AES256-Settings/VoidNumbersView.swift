//
//  VoidNumbersView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct VoidNumbersView: View {
    @ObservedObject var vm: AES256SettingsViewModel
    
    var body: some View {
        voidNumbersView
    }
}

// MARK: - Builder
extension VoidNumbersView {
    private var voidNumbersView: some View {
        CustomScrollView(withTarget: true) {
            CustomNavigationTitle(
                title: vm.voidTitle,
                subTitle: vm.subTitle,
                isLargeNavBar: $0
            )
            Spacer()
        } headerView: {
            HeaderTextView(text: vm.voidInstructions, offsetY: min($0, 0))
        } scrollView: { proxy in
            CustomForm(headerText: vm.voidSubtitle) {
                LazyVStack(spacing: 0) {
                    voidList
                }
            }
            .padding(.top)
            .task { proxy.scrollTo(Int(vm.parameters.voidIndex), anchor: .center) }
        }
    }
    
    private var voidList: some View {
        ForEach(0..<vm.voidMaxNumber, id: \.self) { voidIndex in
            CustomButtonRow(
                icon: .system.number,
                title: "\(voidIndex)",
                withCheckmark: voidIndex == vm.parameters.voidIndex,
                action: { vm.parameters.voidIndex = UInt16(voidIndex) }
            )
            .id(voidIndex)
            
            if voidIndex < vm.voidMaxNumber - 1 {
                Divider().padding(.leading, 20)
            }
        }
    }
}
