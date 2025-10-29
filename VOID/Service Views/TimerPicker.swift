//
//  TimerPicker.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

struct TimerPicker: View {
    @Binding private var selectedHours: Int
    @Binding private var selectedMinutes: Int
    
    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    
    init(selectedHours: Binding<Int>, selectedMinutes: Binding<Int>) {
        self._selectedHours = selectedHours
        self._selectedMinutes = selectedMinutes
    }
    
    var body: some View {
        timerPicker
    }
}

// MARK: - Builder
extension TimerPicker {
    private var timerPicker: some View {
        HStack {
            picker(selection: $selectedHours) {
                ForEach(hours, id: \.self) { hour in
                    Text(L10n("Timer.hour \(hour)"))
                        .tag(hour)
                }
            }
            
            picker(selection: $selectedMinutes) {
                ForEach(minutes, id: \.self) { minute in
                    Text(L10n("Timer.minute \(minute)"))
                        .tag(minute)
                }
            }
        }
        .frame(height: 120)
        .padding(.horizontal)
    }
    
    private func picker<Content: View>(
        selection: Binding<Int>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        Picker(selection: selection, label: EmptyView()) {
            content()
        }
        .pickerStyle(.wheel)
        .frame(width: 100)
        .clipped()
    }
}
