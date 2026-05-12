//
//  QRPixelStyle.swift
//  VOID
//
//  Created by GE-Developer
//

import QRCode

enum QRPixelStyle: String, CaseIterable, Codable {
    case square
    case circle
    case roundedRect
    case squircle
    case roundedPath
    case curvePixel
    case blob
    case star
    case donut
    case diamond
    case pointy
    case vortex
    case sharp
    case shiny
    case flower
    case heart
    case gear
    case spikyCircle
    case arrow
    case wave
    case leaf
    case circuit
    case stitch
    case hexagon
    case hexa
    case wex
    case koala
    case abstract
    case razor
    case roundedEndIndent
    case roundedTriangle
    case flame
    case grid2x2
    case grid3x3
    case grid4x4
    case vertical
    case horizontal
    case diagonal
    case diagonalStripes
    case crosshatch
    case dripVertical
    case dripHorizontal
    case crt
    
    var generator: any QRCodePixelShapeGenerator {
        switch self {
        case .square:
            QRCode.PixelShape.Square()
        case .circle:
            QRCode.PixelShape.Circle()
        case .roundedRect:
            QRCode.PixelShape.RoundedRect()
        case .squircle:
            QRCode.PixelShape.Squircle()
        case .roundedPath:
            QRCode.PixelShape.RoundedPath()
        case .curvePixel:
            QRCode.PixelShape.CurvePixel()
        case .blob:
            QRCode.PixelShape.Blob()
        case .star:
            QRCode.PixelShape.Star()
        case .donut:
            QRCode.PixelShape.Donut()
        case .diamond:
            QRCode.PixelShape.Diamond()
        case .pointy:
            QRCode.PixelShape.Pointy()
        case .vortex:
            QRCode.PixelShape.Vortex()
        case .sharp:
            QRCode.PixelShape.Sharp()
        case .shiny:
            QRCode.PixelShape.Shiny()
        case .flower:
            QRCode.PixelShape.Flower()
        case .heart:
            QRCode.PixelShape.Heart()
        case .gear:
            QRCode.PixelShape.Gear()
        case .spikyCircle:
            QRCode.PixelShape.SpikyCircle()
        case .arrow:
            QRCode.PixelShape.Arrow()
        case .wave:
            QRCode.PixelShape.Wave()
        case .leaf:
            QRCode.PixelShape.Leaf()
        case .circuit:
            QRCode.PixelShape.Circuit()
        case .stitch:
            QRCode.PixelShape.Stitch()
        case .hexagon:
            QRCode.PixelShape.Hexagon()
        case .hexa:
            QRCode.PixelShape.Hexa()
        case .wex:
            QRCode.PixelShape.Wex()
        case .koala:
            QRCode.PixelShape.Koala()
        case .abstract:
            QRCode.PixelShape.Abstract()
        case .razor:
            QRCode.PixelShape.Razor()
        case .roundedEndIndent:
            QRCode.PixelShape.RoundedEndIndent()
        case .roundedTriangle:
            QRCode.PixelShape.RoundedTriangle()
        case .flame:
            QRCode.PixelShape.Flame()
        case .grid2x2:
            QRCode.PixelShape.Grid2x2()
        case .grid3x3:
            QRCode.PixelShape.Grid3x3()
        case .grid4x4:
            QRCode.PixelShape.Grid4x4()
        case .vertical:
            QRCode.PixelShape.Vertical()
        case .horizontal:
            QRCode.PixelShape.Horizontal()
        case .diagonal:
            QRCode.PixelShape.Diagonal()
        case .diagonalStripes:
            QRCode.PixelShape.DiagonalStripes()
        case .crosshatch:
            QRCode.PixelShape.Crosshatch()
        case .dripVertical:
            QRCode.PixelShape.DripVertical()
        case .dripHorizontal:
            QRCode.PixelShape.DripHorizontal()
        case .crt:
            QRCode.PixelShape.CRT()
        }
    }
    
    var name: String {
        switch self {
        case .square:
            L10n("QR.Style.square")
        case .circle:
            L10n("QR.Style.circle")
        case .roundedRect:
            L10n("QR.Style.roundedRect")
        case .squircle:
            L10n("QR.Style.squircle")
        case .roundedPath:
            L10n("QR.Style.roundedPath")
        case .curvePixel:
            L10n("QR.Style.curvePixel")
        case .blob:
            L10n("QR.Style.blob")
        case .star:
            L10n("QR.Style.star")
        case .donut:
            L10n("QR.Style.donut")
        case .diamond:
            L10n("QR.Style.diamond")
        case .pointy:
            L10n("QR.Style.pointy")
        case .vortex:
            L10n("QR.Style.vortex")
        case .sharp:
            L10n("QR.Style.sharp")
        case .shiny:
            L10n("QR.Style.shiny")
        case .flower:
            L10n("QR.Style.flower")
        case .heart:
            L10n("QR.Style.heart")
        case .gear:
            L10n("QR.Style.gear")
        case .spikyCircle:
            L10n("QR.Style.spikyCircle")
        case .arrow:
            L10n("QR.Style.arrow")
        case .wave:
            L10n("QR.Style.wave")
        case .leaf:
            L10n("QR.Style.leaf")
        case .circuit:
            L10n("QR.Style.circuit")
        case .stitch:
            L10n("QR.Style.stitch")
        case .hexagon:
            L10n("QR.Style.hexagon")
        case .hexa:
            L10n("QR.Style.hexa")
        case .wex:
            L10n("QR.Style.wex")
        case .koala:
            L10n("QR.Style.koala")
        case .abstract:
            L10n("QR.Style.abstract")
        case .razor:
            L10n("QR.Style.razor")
        case .roundedEndIndent:
            L10n("QR.Style.roundedEndIndent")
        case .roundedTriangle:
            L10n("QR.Style.roundedTriangle")
        case .flame:
            L10n("QR.Style.flame")
        case .grid2x2:
            L10n("QR.Style.grid2x2")
        case .grid3x3:
            L10n("QR.Style.grid3x3")
        case .grid4x4:
            L10n("QR.Style.grid4x4")
        case .vertical:
            L10n("QR.Style.vertical")
        case .horizontal:
            L10n("QR.Style.horizontal")
        case .diagonal:
            L10n("QR.Style.diagonal")
        case .diagonalStripes:
            L10n("QR.Style.diagonalStripes")
        case .crosshatch:
            L10n("QR.Style.crosshatch")
        case .dripVertical:
            L10n("QR.Style.dripVertical")
        case .dripHorizontal:
            L10n("QR.Style.dripHorizontal")
        case .crt:
            L10n("QR.Style.crt")
        }
    }
    
    static var title: String { L10n("QR.PixelStyle.title") }
}
