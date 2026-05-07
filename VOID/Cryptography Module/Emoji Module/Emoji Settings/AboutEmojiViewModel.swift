//
//  AboutEmojiViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

struct AboutEmojiViewModel: DetailedInformationProtocol {
    let title = L10n("About.information")
    let subtitle = L10n("Emoji")
    
    let firstTitle: String = L10n("AboutEmoji.aboutTitle")
    let firstDescription: String = L10n("AboutEmoji.aboutDescription")
    
    let secondTitle: String? = L10n("AboutEmoji.howDoesItWorkTitle")
    let secondDescription: String? = L10n("AboutEmoji.howDoesItWorkDescription")
    
    let thirdTitle: String? = L10n("AboutEmoji.tipsTitle")
    let thirdDescription: String? = L10n("AboutEmoji.tipsDescription")
    
    let fourthTitle: String? = nil
    let fourthDescription: String? = nil
    let fifthTitle: String? = nil
    let fifthDescription: String? = nil
    
    let letterType: LetterType = .emoji
}
