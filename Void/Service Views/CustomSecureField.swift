//
//  CustomSecureField.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomSecureField: View {
    @FocusState private var focus: Bool
    
    @Binding private var password: String
    
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
extension CustomSecureField {
    private var customSecureFieldRow: some View {
        HStack(spacing: 0) {
            image
            secureField
            deleteButton
        }
        .background { background }
        .onTapGesture { focus = true }
        .animation(.easeInOut, value: focus)
        .padding(.vertical, 15)
        .padding(.horizontal, 10)
    }
    
    private var image: some View {
        Image.system.lock
            .font(.title3)
            .fontWeight(.ultraLight)
            .padding(.leading, 8)
            .foregroundStyle(
                focus
                ? Gradient.accent
                : Gradient.gray
            )
    }
    
    private var secureField: some View {
        SecureField(placeholder, text: $password)
            .focused($focus)
            .autocorrectionDisabled(true)
            .padding(.horizontal, 8)
            .foregroundStyle(Color.void.mainText)
            .fontDesign(.rounded)
            .fontWeight(.light)
    }
    
    private var deleteButton: some View {
        Button(action: deleteAction) {
            Image.system.xmark
                .font(.title3)
                .fontWeight(.ultraLight)
                .foregroundStyle(Color.void.secondaryTextNEW)
                .padding(.trailing, 10)
        }
        .opacity(password.isEmpty ? 0 : 1)
        .animation(.default, value: password)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.void.textFieldBackground)
            .shadow(color: Color.void.viewShadow, radius: 2)
            .frame(height: 35)
    }
}

// MARK: - Methods
extension CustomSecureField {
    private func deleteAction() {
        password = ""
    }
}
