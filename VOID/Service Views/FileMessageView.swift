//
//  FileMessageView.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct FileMessageView: View {
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

    private var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(message.fileSize))
    }

    private let message: FileMessage
    private let pressAction: () -> Void

    init(message: FileMessage, pressAction: @escaping () -> Void) {
        self.message = message
        self.pressAction = pressAction
    }

    var body: some View {
        fileMessageView
    }
}

// MARK: - Builder
extension FileMessageView {
    private var fileMessageView: some View {
        HStack {
            if message.encryptionMode == .encrypt {
                Spacer()
            }

            HStack(spacing: 10) {
                Image.system.document
                    .font(.title2)
                    .foregroundStyle(Color.void.mainText)

                VStack(alignment: .leading, spacing: 2) {
                    Text(message.originalFileName)
                        .font(.callout)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.void.mainText)
                        .lineLimit(2)
                        .truncationMode(.middle)

                    Text(formattedSize)
                        .font(.caption2)
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.void.secondaryText)
                }
            }
            .padding(10)
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
