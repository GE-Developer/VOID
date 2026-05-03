//
//  CustomTextField.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomTextField: View {
    @Binding private var text: String
    @Binding private var isDisabled: Bool
    
    @FocusState private var focus: Bool
    
    private var buttonDisabled: Bool {
        text.isEmpty || isDisabled
    }
    
    private let height: CGFloat = 40
    private let keyboard: UIKeyboardType
    private let placeholder: String
    private let icon: Image?
    private let isMultilined: Bool
    private let error: Bool
    private let sendAction: (() -> Void)?
    
    init(
        text: Binding<String>,
        isDisabled: Binding<Bool> = .constant(false),
        keyboard: UIKeyboardType = .default,
        placeholder: String,
        icon: Image? = nil,
        isMultilined: Bool = false,
        error: Bool = false,
        sendAction: (() -> Void)? = nil
    ) {
        self._text = text
        self._isDisabled = isDisabled
        self.keyboard = keyboard
        self.placeholder = placeholder
        self.icon = icon
        self.isMultilined = isMultilined
        self.error = error
        self.sendAction = sendAction
    }
    
    var body: some View {
        customMessageTextField
    }
}

// MARK: - Builder
extension CustomTextField {
    private var customMessageTextField: some View {
        HStack(alignment: .bottom) {
            HStack(spacing: 0) {
                fieldImage
                textField
                deleteButton
            }
            .background { background }

            sendButton
        }
        .disabled(isDisabled)
        .onChange(of: isDisabled) {
            if isDisabled {
                text = ""
            }
        }
    }

    @ViewBuilder
    private var fieldImage: some View {
        if let icon {
            icon
                .font(.title3)
                .fontWeight(.ultraLight)
                .padding(.leading, 12)
                .foregroundStyle(
                    focus
                    ? Gradient.accent
                    : Gradient.gray
                )
                .contentShape(Rectangle())
                .onTapGesture { focus = true }
        }
    }
    
    private var textField: some View {
        TextField(placeholder, text: $text, axis: isMultilined ? .vertical : .horizontal)
            .focused($focus)
            .keyboardType(keyboard)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .frame(minHeight: height)
            .lineLimit(isMultilined ? 4 : 1)
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
                .foregroundStyle(Color.void.secondaryText)
                .padding(.trailing, 10)
        }
        .opacity(text.isEmpty ? 0 : 1)
    }
    
    
    @ViewBuilder
    private var sendButton: some View {
        if let sendAction {
            ZStack {
                Circle()
                    .foregroundStyle(
                        buttonDisabled
                        ? Gradient.gray
                        : Gradient.accent
                    )
                Image.system.send
                    .foregroundStyle(Color.void.secondaryText)
            }
            .opacity(buttonDisabled ? 0.6 : 1)
            .frame(width: height, height: height)
            .animation(.easeIn.speed(2), value: buttonDisabled)
            .onTapGesture {
                if !buttonDisabled {
                    focus = false
                    sendAction()
                }
            }
        }
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(Color.void.textFieldBackground)
            .overlay(
                RoundedRectangle(cornerRadius: height / 2)
                    .stroke(
                        error ? Color.void.errorRed.opacity(0.6) : Color.clear,
                        lineWidth: 2
                    )
            )
            .animation(.easeInOut, value: error)
            .shadow(color: Color.void.viewShadow, radius: 4)
    }
}

// MARK: - Methods
extension CustomTextField {
    private func deleteButtonPressed() {
        text = ""
    }
}
