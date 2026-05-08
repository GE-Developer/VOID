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

    enum ContrastSeverity { case warning, critical }

    var pixelStyle: QRPixelStyle {
        get { mainVM.configuration.style.pixelStyle }
        set { mainVM.configuration.style.pixelStyle = newValue }
    }

    var foregroundFillType: FillType {
        get { mainVM.configuration.style.foregroundFillType }
        set { mainVM.configuration.style.foregroundFillType = newValue }
    }

    var foregroundColor: CGColor {
        get { mainVM.configuration.style.foregroundColor }
        set { mainVM.configuration.style.foregroundColor = newValue }
    }

    var foregroundGradientColor: CGColor {
        get { mainVM.configuration.style.foregroundGradientColor }
        set { mainVM.configuration.style.foregroundGradientColor = newValue }
    }

    var eyeStyle: QREyeStyle {
        get { mainVM.configuration.style.eyeStyle }
        set { mainVM.configuration.style.eyeStyle = newValue }
    }

    var isEyeColorCustom: Bool {
        get { mainVM.configuration.style.eyeColor != nil }
        set {
            mainVM.configuration.style.eyeColor = newValue
                ? mainVM.configuration.style.foregroundColor
                : nil
        }
    }

    var eyeColor: CGColor {
        get { mainVM.configuration.style.eyeColor ?? mainVM.configuration.style.foregroundColor }
        set { mainVM.configuration.style.eyeColor = newValue }
    }

    var isEyeBackgroundColorCustom: Bool {
        get { mainVM.configuration.style.eyeBackgroundColor != nil }
        set {
            mainVM.configuration.style.eyeBackgroundColor = newValue
                ? mainVM.configuration.style.backgroundColor
                : nil
        }
    }

    var eyeBackgroundColor: CGColor {
        get { mainVM.configuration.style.eyeBackgroundColor ?? mainVM.configuration.style.backgroundColor }
        set { mainVM.configuration.style.eyeBackgroundColor = newValue }
    }

    var pupilStyle: QRPupilStyle {
        get { mainVM.configuration.style.pupilStyle }
        set { mainVM.configuration.style.pupilStyle = newValue }
    }

    var isPupilColorCustom: Bool {
        get { mainVM.configuration.style.pupilColor != nil }
        set {
            mainVM.configuration.style.pupilColor = newValue
                ? mainVM.configuration.style.foregroundColor
                : nil
        }
    }

    var pupilColor: CGColor {
        get { mainVM.configuration.style.pupilColor ?? mainVM.configuration.style.foregroundColor }
        set { mainVM.configuration.style.pupilColor = newValue }
    }

    var backgroundFillType: FillType {
        get { mainVM.configuration.style.backgroundFillType }
        set { mainVM.configuration.style.backgroundFillType = newValue }
    }

    var backgroundColor: CGColor {
        get { mainVM.configuration.style.backgroundColor }
        set { mainVM.configuration.style.backgroundColor = newValue }
    }

    var backgroundGradientColor: CGColor {
        get { mainVM.configuration.style.backgroundGradientColor }
        set { mainVM.configuration.style.backgroundGradientColor = newValue }
    }

    var backgroundCornerRadius: CGFloat {
        get { mainVM.configuration.style.backgroundCornerRadius }
        set { mainVM.configuration.style.backgroundCornerRadius = newValue }
    }

    var offPixelStyle: QRPixelStyle {
        get { mainVM.configuration.style.offPixelStyle }
        set { mainVM.configuration.style.offPixelStyle = newValue }
    }

    var offPixelsFillType: FillType {
        get { mainVM.configuration.style.offPixelsFillType }
        set { mainVM.configuration.style.offPixelsFillType = newValue }
    }

    var offPixelsColor: CGColor {
        get { mainVM.configuration.style.offPixelsColor }
        set { mainVM.configuration.style.offPixelsColor = newValue }
    }

    var offPixelsGradientColor: CGColor {
        get { mainVM.configuration.style.offPixelsGradientColor }
        set { mainVM.configuration.style.offPixelsGradientColor = newValue }
    }

    var negatedOnPixelsOnly: Bool {
        get { mainVM.configuration.style.negatedOnPixelsOnly }
        set { mainVM.configuration.style.negatedOnPixelsOnly = newValue }
    }

    var qrImage: CGImage? { mainVM.qrImage } 

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
    }
}
