//
//  LanguageView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI


struct LanguageView: View {
//    @Environment(\.dismiss) private var dismiss
    @State private var isShowingAlert = false
    
    @StateObject private var vm = LanguageViewModel()
    
    init() {
        UIScrollView.appearance().delaysContentTouches = false
    }
        
    var body: some View {
        CustomScrollView() { isLarge in
            CustomNavigationBar(title: vm.title, isLarge: isLarge)
            Spacer()
        } scrollView: {
            CustomForm {
                    ForEach(Array(Language.allCases.enumerated()), id: \.element.id) { index, language in
                        VStack(spacing: 0) {
                            CustomButtonRow(
                                title: language.localizedName,
                                subtitle: language.englishName,
                                withCheckmark: vm.isWithCheckmark(language),
                                action: {
                                    isShowingAlert.toggle()
                                    vm.tappedLanguage = language
                                }
                            )
                            if index < Language.allCases.count - 1 {
                                Divider()
                                    .padding(.leading, 20)
                            }
                        }
                        .alert(
                            Text(vm.alertTitle),
                            isPresented: $isShowingAlert,
                            actions: {
                                Button(vm.alertActionTitle, role: .destructive) {
                                    vm.setNewLanguage()
                                }
                                Button(vm.alertCancelTitle, role: .cancel) {}
                            }, message: {
                                Text(vm.alertMessage)
                            }
                        )
                    }
                
            }
        }
    }
}
