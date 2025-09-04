//
//  CustomSliderRow.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 30.07.25.
//

import SwiftUI

struct CustomSliderRow<T: BinaryInteger>: View {
    @Binding var value: T

    let availableValues: [T]
    let labels: [String]

    // Колбек для коммита изменений
//    var onEditingChanged: (() -> Void)?

    private var currentIndex: Int {
        availableValues.firstIndex(of: value) ?? 0
    }

    @State private var committedValue: T = .zero

    var body: some View {
        VStack(spacing: 6) {
            Slider(
                value: Binding(
                    get: { Double(currentIndex) },
                    set: { newValue in
                        let index = Int(round(newValue))
                        if availableValues.indices.contains(index) {
                            let newSelected = availableValues[index]
                            value = newSelected
                        }
                    }
                ),
                in: 0...Double(availableValues.count - 1),
                step: 1
            )
            .tint(Gradient.accentGragient)

            HStack {
                ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                    Text(label)
                        .font(.caption2)
                        .fontWeight(.light)
                        .fontDesign(.monospaced)
                        .foregroundStyle(Color.main.secondaryText)

                    if index != labels.count - 1 {
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 7)
        .onAppear {
            committedValue = value
        }
    }
}
