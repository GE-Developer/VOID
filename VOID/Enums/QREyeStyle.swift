//
//  QREyeStyle.swift
//  VOID
//
//  Created by GE-Developer
//

import QRCode

enum QREyeStyle: String, CaseIterable, Codable {
    case original
    
    case square
    case circle
    case roundedRect
    case squircle
    case spikyCircle
    case leaf
    case flame
    case diagonalStripes
    case crt
    case roundedOuter
    case teardrop
    case fireball
    case shield
    case eye
    case peacock
    case roundedPointingIn
    case roundedPointingOut
    case squarePeg
    case pinch
    case edges
    case pixels
    case corneredPixels
    case headlight
    case barsVertical
    case barsHorizontal
    case surroundingBars
    case ufo
    case ufoRounded
    case cloud
    case cloudCircle
    case dotDragHorizontal
    case dotDragVertical
    case explode
    case holePunch
    case fabricScissors
    case arc
    
    var generator: any QRCodeEyeShapeGenerator {
        switch self {
        case .original:
            QRCode.EyeShape.UsePixelShape()
        case .square:
            QRCode.EyeShape.Square()
        case .circle:
            QRCode.EyeShape.Circle()
        case .roundedRect:
            QRCode.EyeShape.RoundedRect()
        case .squircle:
            QRCode.EyeShape.Squircle()
        case .spikyCircle:
            QRCode.EyeShape.SpikyCircle()
        case .leaf:
            QRCode.EyeShape.Leaf()
        case .flame:
            QRCode.EyeShape.Flame()
        case .diagonalStripes:
            QRCode.EyeShape.DiagonalStripes()
        case .crt:
            QRCode.EyeShape.CRT()
        case .roundedOuter:
            QRCode.EyeShape.RoundedOuter()
        case .teardrop:
            QRCode.EyeShape.Teardrop()
        case .fireball:
            QRCode.EyeShape.Fireball()
        case .shield:
            QRCode.EyeShape.Shield()
        case .eye:
            QRCode.EyeShape.Eye()
        case .peacock:
            QRCode.EyeShape.Peacock()
        case .roundedPointingIn:
            QRCode.EyeShape.RoundedPointingIn()
        case .roundedPointingOut:
            QRCode.EyeShape.RoundedPointingOut()
        case .squarePeg:
            QRCode.EyeShape.SquarePeg()
        case .pinch:
            QRCode.EyeShape.Pinch()
        case .edges:
            QRCode.EyeShape.Edges()
        case .pixels:
            QRCode.EyeShape.Pixels()
        case .corneredPixels:
            QRCode.EyeShape.CorneredPixels()
        case .headlight:
            QRCode.EyeShape.Headlight()
        case .barsVertical:
            QRCode.EyeShape.BarsVertical()
        case .barsHorizontal:
            QRCode.EyeShape.BarsHorizontal()
        case .surroundingBars:
            QRCode.EyeShape.SurroundingBars()
        case .ufo:
            QRCode.EyeShape.UFO()
        case .ufoRounded:
            QRCode.EyeShape.UFORounded()
        case .cloud:
            QRCode.EyeShape.Cloud()
        case .cloudCircle:
            QRCode.EyeShape.CloudCircle()
        case .dotDragHorizontal:
            QRCode.EyeShape.DotDragHorizontal()
        case .dotDragVertical:
            QRCode.EyeShape.DotDragVertical()
        case .explode:
            QRCode.EyeShape.Explode()
        case .holePunch:
            QRCode.EyeShape.HolePunch()
        case .fabricScissors:
            QRCode.EyeShape.FabricScissors()
        case .arc:
            QRCode.EyeShape.Arc()
        }
    }
    
    var name: String {
        switch self {
        case .original:
            L10n("QR.Style.default")
        case .square:
            L10n("QR.Style.square")
        case .circle:
            L10n("QR.Style.circle")
        case .roundedRect:
            L10n("QR.Style.roundedRect")
        case .squircle:
            L10n("QR.Style.squircle")
        case .spikyCircle:
            L10n("QR.Style.spikyCircle")
        case .leaf:
            L10n("QR.Style.leaf")
        case .flame:
            L10n("QR.Style.flame")
        case .diagonalStripes:
            L10n("QR.Style.diagonalStripes")
        case .crt:
            L10n("QR.Style.crt")
        case .roundedOuter:
            L10n("QR.Style.roundedOuter")
        case .teardrop:
            L10n("QR.Style.teardrop")
        case .fireball:
            L10n("QR.Style.fireball")
        case .shield:
            L10n("QR.Style.shield")
        case .eye:
            L10n("QR.Style.eye")
        case .peacock:
            L10n("QR.Style.peacock")
        case .roundedPointingIn:
            L10n("QR.Style.roundedPointingIn")
        case .roundedPointingOut:
            L10n("QR.Style.roundedPointingOut")
        case .squarePeg:
            L10n("QR.Style.squarePeg")
        case .pinch:
            L10n("QR.Style.pinch")
        case .edges:
            L10n("QR.Style.edges")
        case .pixels:
            L10n("QR.Style.pixels")
        case .corneredPixels:
            L10n("QR.Style.corneredPixels")
        case .headlight:
            L10n("QR.Style.headlight")
        case .barsVertical:
            L10n("QR.Style.barsVertical")
        case .barsHorizontal:
            L10n("QR.Style.barsHorizontal")
        case .surroundingBars:
            L10n("QR.Style.surroundingBars")
        case .ufo:
            L10n("QR.Style.ufo")
        case .ufoRounded:
            L10n("QR.Style.ufoRounded")
        case .cloud:
            L10n("QR.Style.cloud")
        case .cloudCircle:
            L10n("QR.Style.cloudCircle")
        case .dotDragHorizontal:
            L10n("QR.Style.dotDragHorizontal")
        case .dotDragVertical:
            L10n("QR.Style.dotDragVertical")
        case .explode:
            L10n("QR.Style.explode")
        case .holePunch:
            L10n("QR.Style.holePunch")
        case .fabricScissors:
            L10n("QR.Style.fabricScissors")
        case .arc:
            L10n("QR.Style.arc")
        }
    }
    
    static var title: String { L10n("QR.EyeStyle.title") }
}
