//
//  VoidNumbersView.swift
//  Void
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
            Rectangle().opacity(0.2)
                .frame(height: 40)
                .offset(y: min($0, 0))
        } scrollView: { proxy in
            CustomForm(headerText: vm.voidSubtitle) {
                voidList
            }
            .padding(.top)
        }
    }
    
    private var voidList: some View {
        ForEach(0..<1000, id: \.self) { voidIndex in
            CustomButtonRow(
                icon: Image(systemName: "number"),
                title: "\(voidIndex)",
                withCheckmark: voidIndex == vm.parameters.voidIndex,
                action: { vm.parameters.voidIndex = UInt16(voidIndex) }
            )
            
            if voidIndex < 1000 - 1 {
                Divider()
                    .padding(.leading, 20)
            }
            
        }
    }
}

// MARK: - Logic
extension VoidNumbersView {
    private func scrollTo(_ proxy: ScrollViewProxy) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            proxy.scrollTo(vm.parameters.voidIndex, anchor: .center)
        }
    }
}
