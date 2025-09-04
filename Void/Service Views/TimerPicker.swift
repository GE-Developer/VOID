//
//  TimerPicker.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 31.07.25.
//

import SwiftUI

struct TimerPicker: View {
    @Binding var selectedHours: Int
    @Binding var selectedMinutes: Int

    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    
    var body: some View {
        HStack {
            Picker(
                selection: $selectedHours,
                label: EmptyView()) {
                    
                    ForEach(hours, id: \.self) { hour in
                        Text(L10n("Timer.hour \(hour)")).tag(hour)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                .clipped()
            
            Picker(
                selection: $selectedMinutes,
                label: EmptyView()) {
                    ForEach(minutes, id: \.self) { minute in
                        Text(L10n("Timer.minute \(minute)")).tag(minute)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 100)
                .clipped()
        }
        .frame(height: 120)
        .padding(.horizontal)
    }
}
