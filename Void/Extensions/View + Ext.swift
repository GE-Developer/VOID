//
//  View + Ext.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

extension View {
    func getHeight(_ height: Binding<Double>) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { height.wrappedValue = geo.size.height }
            }
        )
    }
}
