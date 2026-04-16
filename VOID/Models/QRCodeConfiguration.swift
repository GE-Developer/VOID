//
//  QRCodeConfiguration.swift
//  VOID
//
//  Created by GE-Developer
//

import CoreGraphics

struct QRCodeConfiguration {
    // MARK: - Shapes
    var pixelStyle: QRPixelStyle = .square
    var eyeStyle: QREyeStyle = .square
    var pupilStyle: QRPupilStyle = .original

    // MARK: - Off-Pixels
    var offPixelStyle: QRPixelStyle? = nil
    var negatedOnPixelsOnly: Bool = false

    // MARK: - Foreground (Pixels)
    var foregroundFillType: FillType = .solid
    var foregroundColor: CGColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    var foregroundGradientColor: CGColor = CGColor(red: 0, green: 0, blue: 0.5, alpha: 1)

    // MARK: - Off-Pixels Colors
    var offPixelsFillType: FillType = .solid
    var offPixelsColor: CGColor = CGColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    var offPixelsGradientColor: CGColor = CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)

    // MARK: - Background
    var backgroundFillType: FillType = .solid
    var backgroundColor: CGColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
    var backgroundGradientColor: CGColor = CGColor(red: 0.9, green: 0.9, blue: 1, alpha: 1)
    var backgroundCornerRadius: CGFloat = 0

    // MARK: - Eye & Pupil Colors
    var eyeColor: CGColor? = nil
    var pupilColor: CGColor? = nil
    var eyeBackgroundColor: CGColor? = nil

    // MARK: - Other
    var errorCorrection: QRErrorCorrection = .medium
    var logoImage: CGImage? = nil
    var quietZone: Int = 2
    var additionalQuietZonePixels: UInt = 0
}
