//
//  HomeView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI


final class HomeViewModel: ObservableObject {
    var cryptoOneTitle: String { L10n("Cryptography.AES-256") }
    var settingsTitle: String { L10n("Settings.title") }
}

struct HomeView: View {
    enum RootTab: Int, CaseIterable, Identifiable {
        case cryptography
        case settings
        
        var id: Int { rawValue }
        
        var title: String {
            switch self {
            case .cryptography: "Crypto"
            case .settings: "Settings"
            }
        }
        
        var icon: String {
            switch self {
            case .cryptography: "lock.shield.fill"
            case .settings: "gearshape.fill"
            }
        }
    }
    
    @StateObject private var vm = HomeViewModel()
    @State private var selectedTab: RootTab = .cryptography
    
    
    var body: some View {
        Group {
            switch selectedTab {
            case .cryptography:
                NavigationStack {
                    CryptographyView()
                }
            case .settings:
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomTabBar(selected: $selectedTab)
        }
    }
}
// UIScrollView.appearance().delaysContentTouches = false

struct CustomTabBar: View {
    @Binding var selected: HomeView.RootTab
    
    var body: some View {
        HStack {
            ForEach(HomeView.RootTab.allCases) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(selected == tab ? .accentColor : .gray)
                    
                    Text(tab.title)
                        .font(.caption2)
                        .foregroundColor(selected == tab ? .accentColor : .gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        selected = tab
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            BlurView(style: .systemUltraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(radius: 4)
        )
        .padding(.horizontal)
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
