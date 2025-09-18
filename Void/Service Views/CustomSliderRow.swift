//
//  CustomSliderRow.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CustomSliderRow<T: BinaryInteger>: View {
    @State private var committedValue: T = .zero
    @Binding private var value: T
    
    private var currentIndex: Int {
        availableValues.firstIndex(of: value) ?? 0
    }
    
    private let availableValues: [T]
    private let labels: [String]
    
    init(
        value: Binding<T>,
        availableValues: [T],
        labels: [String]
    ) {
        self._value = value
        self.availableValues = availableValues
        self.labels = labels
    }
    
    var body: some View {
        customSliderRow
            .onAppear { committedValue = value }
    }
}

// MARK: - Builder
extension CustomSliderRow {
    private var customSliderRow: some View {
        VStack(spacing: 6) {
            slider
            labelsView
        }
        .padding(.horizontal)
        .padding(.vertical, 7)
        
    }
    
    private var slider: some View {
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
        .tint(Gradient.accent)
    }
    
    private var labelsView: some View {
        HStack {
            ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                Text(label)
                    .font(.caption2)
                    .fontWeight(.light)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Color.void.mainText)
                
                if index != labels.count - 1 {
                    Spacer()
                }
            }
        }
    }
}
