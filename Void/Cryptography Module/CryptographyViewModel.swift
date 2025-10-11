//
//  CryptographyViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

final class CryptographyViewModel: ObservableObject {
    let title = L10n("Cryptography.title")
    
    let symmetricEncryptionTitle = "Симметричные алгоритмы"
    let symmetricEncryptionSubtitle = "Одинаковый ключ на обеих сторонах процесса шифрования."
    
    let encodingTitle = "Кодирование"
    let encodingDescription = "Смена формата данных без скрытия информацию."
    
    let aes256Argon2idTitle = L10n("Cryptography.AES-256")
    let aes256Argon2idSubitle = "Argon2id + VOID"
    
    let aes256EmojiTitle = L10n("Emoji")
}
