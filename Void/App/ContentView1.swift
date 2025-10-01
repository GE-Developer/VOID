//
//  ContentView1.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI
 
final class ContentView1ViewModel {
    let text = "Экран"
    let subText = "Тестовый"
}

struct ContentView1: View {
    private let vm = ContentView1ViewModel()
    @State private var writtenText = ""
    
    var body: some View {
        ZStack {
            // Фон всегда статичен
            Image.background.aes256
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.keyboard) // не реагирует на клавиатуру
            
            VStack {
                ScrollView {
                    VStack {
                        Rectangle().frame(height: 80)
                        Rectangle().frame(height: 80)
                        Rectangle().frame(height: 80)
                        Rectangle().frame(height: 80)
                        Rectangle().frame(height: 80)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                TextField(vm.subText, text: $writtenText)
                    .textFieldStyle(.roundedBorder)
                    .background(Color(.systemBackground))
            }
        }
    }
}

