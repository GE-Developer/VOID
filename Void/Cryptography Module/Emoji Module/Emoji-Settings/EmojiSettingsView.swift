//
//  EmojiSettingsView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct EmojiSettingsView: View {
    @EnvironmentObject private var store: StoreManager
    
    @ObservedObject var vm: EmojiCodingViewModel
    
    @State private var showInfo = false
    @State private var showPayWall = false
    
    var body: some View {
        emojiSettingsView
            .navigationDestination(isPresented: $showInfo) {
                NavigationLazyView(AboutEncryptionView(vm: AboutEmojiViewModel(), 10))
            }
            .navigationDestination(isPresented: $showPayWall) {
                NavigationLazyView(PayWallView())
            }
    }
}

// MARK: - Builder
extension EmojiSettingsView {
    private var emojiSettingsView: some View {
        CustomScrollView {
            CustomNavigationTitle(
                title: vm.settingsTitle,
                subTitle: vm.emojiCodecTitle,
                isLargeNavBar: $0
            )
            Spacer()
            NavigationToolButton(.system.info) {
                showInfo = true
            }
        } scrollView: { _ in
            VStack {
                CustomForm(headerText: vm.emojiFormTitle) {
                    CustomTextRow(vm.emojiFormDescription)
                    Divider()
                        .padding(.horizontal)
                    emojiSelectors
                }
            }
        }
    }
    
    private var emojiSelectors: some View {
        Grid(alignment: .center, horizontalSpacing: 20, verticalSpacing: 20) {
            GridRow {
                moodButton(for: .positive)
                moodButton(for: .negative)
                    .premiumOption($showPayWall)
                    .overlay(premiumOverlay)
            }
            GridRow {
                moodButton(for: .people)
                    .premiumOption($showPayWall)
                    .overlay(premiumOverlay)
                moodButton(for: .animals)
                    .premiumOption($showPayWall)
                    .overlay(premiumOverlay)
            }
            GridRow {
                moodButton(for: .food)
                    .premiumOption($showPayWall)
                    .overlay(premiumOverlay)
                moodButton(for: .loveStory)
                    .premiumOption($showPayWall)
                    .overlay(premiumOverlay)
            }
            GridRow {
                moodButton(for: .flags)
                    .premiumOption($showPayWall)
                    .overlay(premiumOverlay)
                moodButton(for: .symbols)
                    .premiumOption($showPayWall)
                    .overlay(premiumOverlay)
            }
        }
        .padding()
    }
    
    private var premiumOverlay: some View {
        VStack {
            HStack {
                Spacer()
                PremiumView(.star)
                    .padding(10)
                    .background {
                        Circle()
                            .foregroundStyle(Color(.secondarySystemGroupedBackground))
                    }
                    .offset(x: 16, y: -16)
            }
            Spacer()
        }
    }
    
    private func moodButton(for mood: EmojiMood) -> some View {
        Button {
            guard vm.currentMood != mood else { return }
            vm.currentMood = mood
        } label: {
            VStack(spacing: 16) {
                Text(String(mood.padding))
                    .font(.system(size: 55))
                Text(mood.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .foregroundStyle(
                        vm.currentMood == mood
                        ? Color.void.mainText
                        : Color.void.secondaryText
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(width: 130, height: 130)
            .background(buttonBackground(for: mood))
            .overlay(buttonStroke(for: mood))
        }
        .buttonStyle(.plain)
    }
    
    private func buttonBackground(for mood: EmojiMood) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                vm.currentMood == mood
                ? Gradient.accent.opacity(0.2)
                : Gradient.gray.opacity(0.1)
            )
    }
    
    private func buttonStroke(for mood: EmojiMood) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                vm.currentMood == mood
                ? Color.void.accentDark
                : Color.clear, lineWidth: 2
            )
    }
}
