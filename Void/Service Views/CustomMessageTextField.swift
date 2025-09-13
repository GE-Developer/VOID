//
//  CustomMessageTextField.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomMessageTextField: View {
    @Binding var text: String
    @Binding var disabled: Bool
    @FocusState private var focus: Bool
    private let placeholder: String
    
    var buttonDisabled: Bool {
        text.isEmpty || disabled
    }
    
    private let sendAction: () -> Void
    
    init(text: Binding<String>,
         placeholder: String,
         disabled: Binding<Bool> = .constant(false),
         _ sendAction: @escaping () -> Void) {
        _text = text
        self.placeholder = placeholder
        _disabled = disabled
        self.sendAction = sendAction
    }
    
    var body: some View {
        customMessageTextField
    }
}

// MARK: - Builder
extension CustomMessageTextField {
    private var customMessageTextField: some View {
        HStack {
            HStack(spacing: 0) {
                field
                deleteButton
            }
            .background { background }
            .onTapGesture { focus = true }
            
            sendButton
        }
        .disabled(disabled)
        .shadow(color: Color.main.background.opacity(0.5), radius: 1)
        .animation(.easeInOut, value: focus)
        .onChange(of: disabled) { oldValue, newValue in
            if newValue {
                text = ""
            }
        }
    }
    
    private var field: some View {
        TextField(placeholder, text: $text)
            .focused($focus)
            .autocorrectionDisabled(true)
            .padding(10)
            .foregroundStyle(Color.main.textFieldText)
            .fontDesign(.rounded)
            .fontWeight(.light)
    }
    
    private var deleteButton: some View {
        Button(action: deleteButtonPressed) {
            Image.system.xmark
                .font(.title3)
                .fontWeight(.ultraLight)
                .foregroundStyle(Color.navigation.secondaryTitle)
                .padding(.trailing, 10)
        }
        .opacity(text.isEmpty ? 0 : 1)
    }
    
    private var sendButton: some View {
        Button {
            sendAction()
            focus = false
        } label: {
            ZStack {
                Circle()
                    .foregroundStyle(
                        buttonDisabled
                        ? Gradient.basicSubscriptionGradiaent
                        : Gradient.accentGragient
                    )
                    .frame(height: 40)
                Image.system.send
                    .foregroundStyle(Color.main.text)
            }
            .opacity(buttonDisabled ? 0.6 : 1)
        }
        .disabled(buttonDisabled)
        .animation(.easeInOut, value: buttonDisabled)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.navigation.textFieldBackground)
            .shadow(color: Color.main.viewShadow, radius: 4)
            .frame(height: 35)
    }
}

// MARK: - Methods
extension CustomMessageTextField {
    private func deleteButtonPressed() {
        text = ""
    }
}
