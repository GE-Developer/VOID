//
//  QRPupilStyle.swift
//  VOID
//
//  Created by GE-Developer
//

import QRCode

enum QRPupilStyle: String, CaseIterable, Codable {
    // MARK: - Default
    case original

    // MARK: - Shared with QRPixelStyle
    case square
    case circle
    case roundedRect
    case squircle
    case heart
    case gear
    case spikyCircle
    case arrow
    case leaf
    case koala
    case flame
    case diagonalStripes
    case crt

    // MARK: - Unique to PupilShape
    case roundedOuter
    case corneredPixels
    case teardrop
    case shield
    case cross
    case crossCurved
    case blobby
    case forest
    case hexagonLeaf
    case seal
    case blade
    case orbits
    case pixels
    case roundedPointingIn
    case roundedPointingOut
    case edges
    case explode
    case cloud
    case cloudCircle
    case arc
    case barsVertical
    case barsHorizontal
    case squareBarsHorizontal
    case squareBarsVertical
    case dotDragHorizontal
    case dotDragVertical
    case ufo
    case ufoRounded
    case pinch
    case fabricScissors

    var generator: any QRCodePupilShapeGenerator {
        switch self {
        case .original:
            QRCode.PupilShape.UsePixelShape()
        case .square:
            QRCode.PupilShape.Square()
        case .circle:
            QRCode.PupilShape.Circle()
        case .roundedRect:
            QRCode.PupilShape.RoundedRect()
        case .squircle:
            QRCode.PupilShape.Squircle()
        case .heart:
            QRCode.PupilShape.Heart()
        case .gear:
            QRCode.PupilShape.Gear()
        case .spikyCircle:
            QRCode.PupilShape.SpikyCircle()
        case .arrow:
            QRCode.PupilShape.Arrow()
        case .leaf:
            QRCode.PupilShape.Leaf()
        case .koala:
            QRCode.PupilShape.Koala()
        case .flame:
            QRCode.PupilShape.Flame()
        case .diagonalStripes:
            QRCode.PupilShape.DiagonalStripes()
        case .crt:
            QRCode.PupilShape.CRT()
        case .roundedOuter:
            QRCode.PupilShape.RoundedOuter()
        case .corneredPixels:
            QRCode.PupilShape.CorneredPixels()
        case .teardrop:
            QRCode.PupilShape.Teardrop()
        case .shield:
            QRCode.PupilShape.Shield()
        case .cross:
            QRCode.PupilShape.Cross()
        case .crossCurved:
            QRCode.PupilShape.CrossCurved()
        case .blobby:
            QRCode.PupilShape.Blobby()
        case .forest:
            QRCode.PupilShape.Forest()
        case .hexagonLeaf:
            QRCode.PupilShape.HexagonLeaf()
        case .seal:
            QRCode.PupilShape.Seal()
        case .blade:
            QRCode.PupilShape.Blade()
        case .orbits:
            QRCode.PupilShape.Orbits()
        case .pixels:
            QRCode.PupilShape.Pixels()
        case .roundedPointingIn:
            QRCode.PupilShape.RoundedPointingIn()
        case .roundedPointingOut:
            QRCode.PupilShape.RoundedPointingOut()
        case .edges:
            QRCode.PupilShape.Edges()
        case .explode:
            QRCode.PupilShape.Explode()
        case .cloud:
            QRCode.PupilShape.Cloud()
        case .cloudCircle:
            QRCode.PupilShape.CloudCircle()
        case .arc:
            QRCode.PupilShape.Arc()
        case .barsVertical:
            QRCode.PupilShape.BarsVertical()
        case .barsHorizontal:
            QRCode.PupilShape.BarsHorizontal()
        case .squareBarsHorizontal:
            QRCode.PupilShape.SquareBarsHorizontal()
        case .squareBarsVertical:
            QRCode.PupilShape.SquareBarsVertical()
        case .dotDragHorizontal:
            QRCode.PupilShape.DotDragHorizontal()
        case .dotDragVertical:
            QRCode.PupilShape.DotDragVertical()
        case .ufo:
            QRCode.PupilShape.UFO()
        case .ufoRounded:
            QRCode.PupilShape.UFORounded()
        case .pinch:
            QRCode.PupilShape.Pinch()
        case .fabricScissors:
            QRCode.PupilShape.FabricScissors()
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
        case .heart:
            L10n("QR.Style.heart")
        case .gear:
            L10n("QR.Style.gear")
        case .spikyCircle:
            L10n("QR.Style.spikyCircle")
        case .arrow:
            L10n("QR.Style.arrow")
        case .leaf:
            L10n("QR.Style.leaf")
        case .koala:
            L10n("QR.Style.koala")
        case .flame:
            L10n("QR.Style.flame")
        case .diagonalStripes:
            L10n("QR.Style.diagonalStripes")
        case .crt:
            L10n("QR.Style.crt")
        case .roundedOuter:
            L10n("QR.Style.roundedOuter")
        case .corneredPixels:
            L10n("QR.Style.corneredPixels")
        case .teardrop:
            L10n("QR.Style.teardrop")
        case .shield:
            L10n("QR.Style.shield")
        case .cross:
            L10n("QR.Style.cross")
        case .crossCurved:
            L10n("QR.Style.crossCurved")
        case .blobby:
            L10n("QR.Style.blobby")
        case .forest:
            L10n("QR.Style.forest")
        case .hexagonLeaf:
            L10n("QR.Style.hexagonLeaf")
        case .seal:
            L10n("QR.Style.seal")
        case .blade:
            L10n("QR.Style.blade")
        case .orbits:
            L10n("QR.Style.orbits")
        case .pixels:
            L10n("QR.Style.pixels")
        case .roundedPointingIn:
            L10n("QR.Style.roundedPointingIn")
        case .roundedPointingOut:
            L10n("QR.Style.roundedPointingOut")
        case .edges:
            L10n("QR.Style.edges")
        case .explode:
            L10n("QR.Style.explode")
        case .cloud:
            L10n("QR.Style.cloud")
        case .cloudCircle:
            L10n("QR.Style.cloudCircle")
        case .arc:
            L10n("QR.Style.arc")
        case .barsVertical:
            L10n("QR.Style.barsVertical")
        case .barsHorizontal:
            L10n("QR.Style.barsHorizontal")
        case .squareBarsHorizontal:
            L10n("QR.Style.squareBarsHorizontal")
        case .squareBarsVertical:
            L10n("QR.Style.squareBarsVertical")
        case .dotDragHorizontal:
            L10n("QR.Style.dotDragHorizontal")
        case .dotDragVertical:
            L10n("QR.Style.dotDragVertical")
        case .ufo:
            L10n("QR.Style.ufo")
        case .ufoRounded:
            L10n("QR.Style.ufoRounded")
        case .pinch:
            L10n("QR.Style.pinch")
        case .fabricScissors:
            L10n("QR.Style.fabricScissors")
        }
    }
}
