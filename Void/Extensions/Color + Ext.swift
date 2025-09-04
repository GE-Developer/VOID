//
//  Color + Extension.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

extension Color {
    static let main = MainTheme()
    static let navigation = NavigationTheme()
    static let subscription = SubscriptionStatusTheme()
}

struct MainTheme {
    let viewShadow = Color("View Shadow")
    let background = Color("Background")
    let textFieldText = Color("Text Field Text")
    let titleText = Color("Title Text")
    let text = Color("Text")
    let secondaryText = Color("Secondary Text")
}

struct NavigationTheme {
    let navBarShadow = Color("NavBarShadow")
    
    let title = Color("Title")
    let secondaryTitle = Color("Secondary Title")
    let backButton = Color("Back Button")
    let buttonBackground = Color("Like Button Background")
    let accentOne = Color("Heart One")
    let accentTwo = Color("Heart Two")
    let magnifying = Color("Magnifying")
    let focusedMagnifying = Color("Focused Magnifying")
    let textFieldBackground = Color("Text Field Background")
}

struct SubscriptionStatusTheme {
    let bannerText = Color("Subscribtion Banner Text")
    let premiumOne = Color("PremiumSubscriptionOne")
    let premiumTwo = Color("PremiumSubscriptionTwo")
    let basicOne = Color("BasicSubscriptionOne")
    let basicTwo = Color("BasicSubscriptionTwo")
}
