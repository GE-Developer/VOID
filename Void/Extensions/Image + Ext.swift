//
//  Image + Ext.swift
//  Void
//
//  Created by GE-Developer
//

import SwiftUI

extension Image {
    static let system = SystemImage()
    static let background = BackgroundImage()
    static let content = ContentImage()
}

struct SystemImage {
    let back = Image(systemName: "chevron.left")
    let chevron = Image(systemName: "chevron.right")
    let lock = Image(systemName: "lock.fill")
    let timer = Image(systemName: "timer")
    let send = Image(systemName: "arrow.up")
    let xmark = Image(systemName: "xmark")
    let cryptoSettings = Image(systemName: "slider.horizontal.3")
    let number = Image(systemName: "number")
    let info = Image(systemName: "info.circle")
    
    let chechmark = Image(systemName: "checkmark.circle.fill")
    let darkMode = Image(systemName: "moon.fill")
    let language = Image(systemName: "globe")
    let vibration = Image(systemName: "iphone.radiowaves.left.and.right")
    let sound = Image(systemName: "speaker.wave.2.fill")
    let subscription = Image(systemName: "star")
    let restorePurchases = Image(systemName: "arrow.clockwise")
    let reviewLike = Image(systemName: "hand.thumbsup.fill")
    let rectangle = Image(systemName: "app.fill")
    let termsOfUse = Image(systemName: "doc.plaintext")
    let privacyPolicy = Image(systemName: "lock.doc.fill")
    let developerTool = Image(systemName: "hammer.fill")
    let gear = Image(systemName: "gear")
    
    func key(_ isFilled: Bool = false) -> Image {
        isFilled ? Image(systemName: "key.fill") : Image(systemName: "key")
    }
}

struct BackgroundImage {
    let aes256Argon2idVOID = Image("AES256+Argon2id+VOID")
}

struct ContentImage {
    let voidAES256Argon2id = Image("VOID+AES256+Argon2id")
}
