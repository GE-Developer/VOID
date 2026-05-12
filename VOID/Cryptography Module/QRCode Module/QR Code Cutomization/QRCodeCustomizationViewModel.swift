//
//  QRCodeCustomizationViewModel.swift
//  VOID
//
//  Created by GE-Developer
//

import CoreGraphics
import Foundation

@Observable
final class QRCodeCustomizationViewModel {
    
    var pixelStyle: QRPixelStyle {
        didSet { mainVM.configuration.style.pixelStyle = pixelStyle }
    }
    
    var foregroundFillType: FillType {
        didSet { mainVM.configuration.style.foregroundFillType = foregroundFillType }
    }
    
    var foregroundColor: CGColor {
        didSet { mainVM.configuration.style.foregroundColor = foregroundColor }
    }
    
    var foregroundGradientColor: CGColor {
        didSet { mainVM.configuration.style.foregroundGradientColor = foregroundGradientColor }
    }
    
    var eyeStyle: QREyeStyle {
        didSet { mainVM.configuration.style.eyeStyle = eyeStyle }
    }
    
    var isEyeColorCustom: Bool {
        didSet { mainVM.configuration.style.eyeColor = isEyeColorCustom ? eyeColor : nil }
    }
    
    var eyeColor: CGColor {
        didSet {
            if isEyeColorCustom {
                mainVM.configuration.style.eyeColor = eyeColor
            }
        }
    }
    
    var isEyeBackgroundColorCustom: Bool {
        didSet { mainVM.configuration.style.eyeBackgroundColor = isEyeBackgroundColorCustom ? eyeBackgroundColor : nil }
    }
    
    var eyeBackgroundColor: CGColor {
        didSet {
            if isEyeBackgroundColorCustom {
                mainVM.configuration.style.eyeBackgroundColor = eyeBackgroundColor
            }
        }
    }
    
    var pupilStyle: QRPupilStyle {
        didSet { mainVM.configuration.style.pupilStyle = pupilStyle }
    }
    
    var isPupilColorCustom: Bool {
        didSet { mainVM.configuration.style.pupilColor = isPupilColorCustom ? pupilColor : nil }
    }
    
    var pupilColor: CGColor {
        didSet {
            if isPupilColorCustom {
                mainVM.configuration.style.pupilColor = pupilColor
            }
        }
    }
    
    var backgroundFillType: FillType {
        didSet { mainVM.configuration.style.backgroundFillType = backgroundFillType }
    }
    
    var backgroundColor: CGColor {
        didSet { mainVM.configuration.style.backgroundColor = backgroundColor }
    }
    
    var backgroundGradientColor: CGColor {
        didSet { mainVM.configuration.style.backgroundGradientColor = backgroundGradientColor }
    }
    
    var backgroundCornerRadius: CGFloat {
        didSet { mainVM.configuration.style.backgroundCornerRadius = backgroundCornerRadius }
    }
    
    var offPixelStyle: QRPixelStyle {
        didSet { mainVM.configuration.style.offPixelStyle = offPixelStyle }
    }
    
    var offPixelsFillType: FillType {
        didSet { mainVM.configuration.style.offPixelsFillType = offPixelsFillType }
    }
    
    var offPixelsColor: CGColor {
        didSet { mainVM.configuration.style.offPixelsColor = offPixelsColor }
    }
    
    var offPixelsGradientColor: CGColor {
        didSet { mainVM.configuration.style.offPixelsGradientColor = offPixelsGradientColor }
    }
    
    var negatedOnPixelsOnly: Bool {
        didSet { mainVM.configuration.style.negatedOnPixelsOnly = negatedOnPixelsOnly }
    }
    
    var qrImage: CGImage? { mainVM.qrImage }
    
    var quality: QRScanQuality { mainVM.qrQuality }
    
    var qualityTitle: String { mainVM.qrQuality.description }
    
    let title = L10n("QRCode.Customization.title")
    let subTitle = L10n("QRCode.title")
    let pixelStyleHeader = QRPixelStyle.title
    let eyeStyleHeader = QREyeStyle.title
    let pupilStyleHeader = QRPupilStyle.title
    let colorRowTitle = L10n("QRCode.Customization.primaryColor")
    let gradientColorRowTitle = L10n("QRCode.Customization.gradientColor")
    let customColorToggleTitle = L10n("QRCode.Customization.customColor")
    let backgroundHeader = L10n("QRCode.Customization.background")
    let offPixelsHeader = L10n("QRCode.Customization.offPixels")
    let cornerRadiusHeader = L10n("QRCode.Customization.cornerRadius")
    let negatedToggleTitle = L10n("QRCode.Customization.negated")
    let eyeBackgroundTitle = L10n("QRCode.Customization.backgroundColor")
    
    @ObservationIgnored private let mainVM: QRCodeGeneratorViewModel
    
    init(mainVM: QRCodeGeneratorViewModel) {
        self.mainVM = mainVM
        let style = mainVM.configuration.style
        
        self.pixelStyle = style.pixelStyle
        self.foregroundFillType = style.foregroundFillType
        self.foregroundColor = style.foregroundColor
        self.foregroundGradientColor = style.foregroundGradientColor
        self.eyeStyle = style.eyeStyle
        self.isEyeColorCustom = style.eyeColor != nil
        self.eyeColor = style.eyeColor ?? style.foregroundColor
        self.isEyeBackgroundColorCustom = style.eyeBackgroundColor != nil
        self.eyeBackgroundColor = style.eyeBackgroundColor ?? style.backgroundColor
        self.pupilStyle = style.pupilStyle
        self.isPupilColorCustom = style.pupilColor != nil
        self.pupilColor = style.pupilColor ?? style.foregroundColor
        self.backgroundFillType = style.backgroundFillType
        self.backgroundColor = style.backgroundColor
        self.backgroundGradientColor = style.backgroundGradientColor
        self.backgroundCornerRadius = style.backgroundCornerRadius
        self.offPixelStyle = style.offPixelStyle
        self.offPixelsFillType = style.offPixelsFillType
        self.offPixelsColor = style.offPixelsColor
        self.offPixelsGradientColor = style.offPixelsGradientColor
        self.negatedOnPixelsOnly = style.negatedOnPixelsOnly
    }
}
