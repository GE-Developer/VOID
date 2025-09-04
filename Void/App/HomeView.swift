//
//  HomeView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    var cryptoOneTitle: String {
        L10n("Cryptography.AES-256")
    }
    
    var settingsTitle: String {
        L10n("Settings.title")
    }
}

struct HomeView: View {
    @StateObject private var vm = HomeViewModel()

    var body: some View {
        VStack {
            NavigationLink {
                AES256EncryptionView()
            } label: {
                Text(vm.cryptoOneTitle)
            }
            NavigationLink {
                SettingsView()
            } label: {
                Text(vm.settingsTitle)
            }
        }
    }
}

// UIScrollView.appearance().delaysContentTouches = false
