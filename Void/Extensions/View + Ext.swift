//
//  View + Ext.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

extension View {
    var isFaceIDPhone: Bool {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else {
            return false
        }
        return window.safeAreaInsets.bottom > 0
    }
    
    func getHeight(_ height: Binding<Double>) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { height.wrappedValue = geo.size.height }
            }
        )
    }
}
