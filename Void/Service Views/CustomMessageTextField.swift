//
//  CustomMessageTextField.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomMessageTextField: View {
    @Binding private var text: String
    @Binding private var isDisabled: Bool
    
    @FocusState private var focus: Bool
    
    private var buttonDisabled: Bool {
        text.isEmpty || isDisabled
    }
    
    private let placeholder: String
    private let sendAction: () -> Void
    
    init(
        text: Binding<String>,
        isDisabled: Binding<Bool>,
        placeholder: String,
        _ sendAction: @escaping () -> Void
    ) {
        self._text = text
        self._isDisabled = isDisabled
        self.placeholder = placeholder
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
                textField
                deleteButton
            }
            .background { background }
            .onTapGesture { focus = true }
            
            sendButton
        }
        .disabled(isDisabled)
        .animation(.easeInOut, value: focus)
        .onChange(of: isDisabled) {
            if isDisabled {
                text = ""
            }
        }
    }
    
    private var textField: some View {
        TextField(placeholder, text: $text)
            .focused($focus)
            .autocorrectionDisabled(true)
            .padding(10)
            .foregroundStyle(Color.void.mainText)
            .fontDesign(.rounded)
            .fontWeight(.light)
            .shadow(color: Color.void.viewShadow, radius: 2)
    }
    
    private var deleteButton: some View {
        Button(action: deleteButtonPressed) {
            Image.system.xmark
                .font(.title3)
                .fontWeight(.ultraLight)
                .foregroundStyle(Color.void.secondaryTextNEW)
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
                        ? Gradient.gray
                        : Gradient.accent
                    )
                    .frame(height: 40)
                Image.system.send
                    .foregroundStyle(Color.void.secondaryTextNEW)
            }
            .opacity(buttonDisabled ? 0.6 : 1)
        }
        .disabled(buttonDisabled)
        .animation(.easeInOut, value: buttonDisabled)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.void.textFieldBackground)
            .shadow(color: Color.void.viewShadow, radius: 4)
            .frame(height: 35)
    }
}

// MARK: - Methods
extension CustomMessageTextField {
    private func deleteButtonPressed() {
        text = ""
    }
}
