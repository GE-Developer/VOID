//
//  Color + Ext.swift
//  VOID
//
//  Created by GE-Developer
//

import SwiftUI

extension Color {
    static let void = VoidColor()
}

struct VoidColor {
    var accent: Color {
        AccentColorManager.shared.currentColor.color
    }
    
    let background = Color("Background")
    let blackAndWhite = Color("Black And White")
    let secondaryText = Color("Secondary Text")
    let goldLight = Color("Gold Light")
    let goldDark = Color("Gold Dark")
    let grayLight = Color("Gray Light")
    let grayDark = Color("Gray Dark")
    let navBarShadow = Color("NavBar Shadow")
    let viewShadow = Color("View Shadow")
    let textFieldBackground = Color("Text Field Background")
    let mainText = Color("Main Text")
    let greenDark = Color("Green Dark")
    let greenLight = Color("Green Light")
    let errorRed = Color("ErrorRed")
    let tangOrange = Color("TangOrange")
}
