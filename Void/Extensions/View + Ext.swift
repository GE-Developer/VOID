//
//  View + Ext.swift
//  Void
//
//  Created by Mikhail Bukhrashvili on 13.09.25.
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
