//
//  FullScreenLoader.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct FullScreenLoader: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            CustomForm {
                VStack(spacing: 16) {
                    text
                        .foregroundStyle(Color(.secondarySystemGroupedBackground).opacity(0.95))
                        .shadow(color: Color.void.blackAndWhite, radius: 0.3, y: 0.7)
                        .frame(height: 90)
                        .overlay {
                            MatrixAnimationView(.eas256, color: Color.void.blackAndWhite, letterSize: 7, columnSpacing: 0, rowSpacing: 0, updateDelay: 300, speedRange: 1...6)
                                .mask(text)
                        }
                        
                    Divider()
                    
                    VStack(spacing: 16) {
                        Text("Идёт процесс…")
                            .font(.title3)
                            .foregroundStyle(Color.void.mainText)
                        Text("Пожалуйста, не закрывайте приложение до завершения.")
                            .foregroundStyle(Color.void.secondaryTextNEW)
                    }
                    .multilineTextAlignment(.center)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                }
                .padding()
            }
            .shadow(color: Color.void.viewShadow, radius: 10)
            .padding()
        }
    }
    
    private var text: some View {
        Text("VOID")
             .font(.system(size: 120, weight: .heavy, design: .rounded))
    }
}
