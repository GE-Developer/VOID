//
//  CustomSecureFieldRow.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomSecureFieldRow: View {
    @Binding var password: String
    private let placeholder: String
    
    init(password: Binding<String>, placeholder: String) {
        self._password = password
        self.placeholder = placeholder
    }
    
    var body: some View {
        customSecureFieldRow
    }
}

// MARK: - Builder
extension CustomSecureFieldRow {
    private var customSecureFieldRow: some View {
        HStack(spacing: 0) {
            Group {
                CustomNavigationTextField(
                    text: $password,
                    placeholder: placeholder,
                    deleteAction: { password = "" }
                )
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
        }
    }
}


struct CustomNavigationTextField: View {
    @Binding var text: String
    
    @FocusState private var focus: Bool
    
    private let placeholder: String
    
    private let deleteAction: () -> Void
    
    init(text: Binding<String>,
         placeholder: String,
         deleteAction: @escaping () -> Void) {
        _text = text
        self.placeholder = placeholder
        self.deleteAction = deleteAction
    }
    
    var body: some View {
        customNavigationTextField
    }
}

// MARK: - Builder
extension CustomNavigationTextField {
    private var customNavigationTextField: some View {
        HStack {
            HStack(spacing: 0) {
                searchImage
                searchField
                deleteButton
            }
            .background { background }
            .onTapGesture { focus = true }
        }
        .animation(.easeInOut, value: focus)
    }
    
    private var searchImage: some View {
        Image.system.lock
            .font(.title3)
            .fontWeight(.ultraLight)
            .padding(.leading, 10)
            .foregroundStyle(
                focus ? Color.navigation.focusedMagnifying : Color.navigation.magnifying
            )
    }
    
    private var searchField: some View {
        SecureField(placeholder, text: $text)
            .focused($focus)
            .autocorrectionDisabled(true)
            .padding(10)
            .foregroundStyle(Color.main.textFieldText)
            .fontDesign(.rounded)
            .fontWeight(.light)
    }
    
    private var deleteButton: some View {
        Button(action: deleteAction) {
            Image.system.xmark
                .font(.title3)
                .fontWeight(.ultraLight)
                .foregroundStyle(Color.navigation.secondaryTitle)
                .padding(.trailing, 10)
        }
        .opacity(text.isEmpty ? 0 : 1)
        .animation(.default, value: text)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.navigation.textFieldBackground)
            .shadow(color: Color.main.viewShadow, radius: 4)
            .frame(height: 35)
    }
}
