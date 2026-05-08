//
//  AboutAES256ViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

struct AboutAES256ViewModel: DetailedInformationProtocol {
    let title = L10n("About.information")
    let subtitle = L10n("Cryptography.AES-256")
    
    let firstTitle = L10n("AboutAES256.firstTitle")
    let firstDescription = L10n("AboutAES256.firstDescription")
    
    let secondTitle: String? = L10n("AboutAES256.secondTitle")
    let secondDescription: String? = L10n("AboutAES256.secondDescription")
    
    let thirdTitle: String? = L10n("AboutAES256.thirdTitle")
    let thirdDescription: String? = L10n("AboutAES256.thirdDescription")
    
    let fourthTitle: String? = L10n("AboutAES256.fourthTitle")
    let fourthDescription: String? = L10n("AboutAES256.fourthDescription")
    
    let fifthTitle: String? = L10n("About.tipsTitle")
    let fifthDescription: String? = L10n("AboutAES256.fifthDescription")
    
    var letterType: LetterType = .eas256
}
