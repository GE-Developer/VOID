//
//  EmojiSettingsView.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

struct EmojiSettingsView: View {
    @ObservedObject var vm: EmojiCodingViewModel
    
    var body: some View {
        emojiSettingsView
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
            }
            GridRow {
                moodButton(for: .people)
                moodButton(for: .animals)
            }
            GridRow {
                moodButton(for: .food)
                moodButton(for: .loveStory)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func moodButton(for mood: EmojiMood) -> some View {
        Button {
            guard vm.currentMood != mood else { return }
            vm.currentMood = mood
        } label: {
            VStack {
                Text(String(mood.padding))
                    .font(.system(size: 55))
                Text(mood.title)
                    .font(.caption)
                    .foregroundStyle(
                        vm.currentMood == mood
                        ? Color.void.mainText
                        : Color.void.secondaryText
                    )
            }
            .frame(width: 130, height: 130)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(vm.currentMood == mood ? Gradient.accent.opacity(0.2) : Gradient.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(vm.currentMood == mood ? Color.void.accentDark : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
