//
//  MessageView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct MessageView: View {
    @State private var isPressing = false
    
    private var backgroundColor: Color {
        switch message.encryptionMode {
        case .encrypt:
            return isPressing ? .void.greenDark : .void.accent
        case .decrypt:
            return isPressing ? .void.greenDark : .void.grayDark
        }
    }
    
    private var transitionEdge: Edge {
        message.encryptionMode == .encrypt ? .trailing : .leading
    }
    
    private let message: Message
    
    private let pressAction: () -> Void
    
    init(message: Message, pressAction: @escaping () -> Void) {
        self.message = message
        self.pressAction = pressAction
    }
    
    var body: some View {
        messageView
    }
}

// MARK: - Builder
extension MessageView {
    private var messageView: some View {
        HStack() {
            if message.encryptionMode == .encrypt {
                Spacer()
            }
            
            WrappingLabel(text: message.resultText)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(backgroundColor)
                        .shadow(color: Color.void.navBarShadow, radius: 2)
                }
                .onLongPressGesture(
                    minimumDuration: 0.5,
                    maximumDistance: 0.5,
                    perform: pressAction,
                    onPressingChanged: { pressing in
                        withAnimation(.spring(response: 0.8)) { isPressing = pressing }
                    }
                )
            
            if message.encryptionMode == .decrypt {
                Spacer()
            }
        }
        .padding(.leading, message.encryptionMode == .encrypt ? 50 : 0)
        .padding(.trailing, message.encryptionMode == .decrypt ? 50 : 0)
        .transition(
            .asymmetric(
                insertion: .move(edge: transitionEdge).combined(with: .opacity),
                removal: .opacity
            )
        )
    }
}

// MARK: - WrappingLabel
private struct WrappingLabel: UIViewRepresentable {
    let text: String
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.adjustsFontForContentSizeCategory = true
        label.font = Self.font
        label.textColor = UIColor(Color.void.mainText)
        label.backgroundColor = .clear
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UILabel, context: Context) -> CGSize? {
        guard let width = proposal.width, width.isFinite else { return nil }
        return uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    }
    
    private static let font: UIFont = {
        let base = UIFont.preferredFont(forTextStyle: .caption1)
        if let descriptor = base.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: 0)
        }
        return base
    }()
}
