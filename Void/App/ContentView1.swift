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
    
    init() {
        print("INIT VM")
    }
    
    deinit {
        print("DEINIT VM")
    }
}

struct ContentView1: View {
    private let vm = ContentView1ViewModel()
    @State private var writtenText = ""
    
    init() {
        print("INIT")
    }
    
    var body: some View {
        CustomScrollView() { isLargeNavBar in
            CustomNavigationBar(title: vm.text, subTitle: vm.subText, isLargeNavBar: isLargeNavBar)
            Spacer()
        } headerView: { minY in
            Rectangle()
                .frame(height: 80)
                .offset(y: min(minY, 0))
        } scrollView: { proxy in
            VStack {
                ForEach(1..<100) { i in
                    Text("Number \(i)")
                        .id(i)
                }
            }
//            .onAppear {
//                proxy.scrollTo(90, anchor: .bottom)
//            }
        }
        .safeAreaInset(edge: .bottom) {
            TextField(vm.subText, text: $writtenText)
        }

    }
}

