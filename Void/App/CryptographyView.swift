//
//  CryptographyView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct CryptographyView: View {
    @State private var showAES256View = false
    
    var body: some View {
        CustomScrollView(withBackButton: false) {
            CustomNavigationTitle(title: L10n("Cryptography.title"), isLargeNavBar: $0)
            Spacer()
        } scrollView: { _ in
            VStack {
                Button {
                    showAES256View = true
                } label: {
                    Rectangle().frame(height: 50)
                }
            }
        }
        .navigationDestination(isPresented: $showAES256View) {
            NavigationLazyView(AES256EncryptionView())
        }
    }
}
