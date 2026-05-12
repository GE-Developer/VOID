//
//  AboutQRCodeViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

struct AboutQRCodeViewModel: DetailedInformationProtocol {
    let title = L10n("About.information")
    let subtitle = L10n("QRCode.title")
    
    let firstTitle = L10n("AboutQRCode.firstTitle")
    let firstDescription = L10n("AboutQRCode.firstDescription")
    
    let secondTitle: String? = L10n("AboutQRCode.secondTitle")
    let secondDescription: String? = L10n("AboutQRCode.secondDescription")
    
    let thirdTitle: String? = L10n("QR.ErrorCorrection.title")
    let thirdDescription: String? = L10n("AboutQRCode.thirdDescription")
    
    let fourthTitle: String? = L10n("QRCode.Customization.title")
    let fourthDescription: String? = L10n("AboutQRCode.fourthDescription")
    
    let fifthTitle: String? = L10n("About.tipsTitle")
    let fifthDescription: String? = L10n("AboutQRCode.fifthDescription")
    
    let letterType: LetterType = .qrCode
}
