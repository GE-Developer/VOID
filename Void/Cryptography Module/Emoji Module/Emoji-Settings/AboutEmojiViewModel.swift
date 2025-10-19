//
//  AboutEmojiViewModel.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

struct AboutEmojiViewModel: AboutEncryptionProtocol {
    let title = L10n("About.information")
    let subtitle = L10n("Emoji")
    
    let firstTitle: String = "О кодировании"
    let firstDescription: String = "Кодирование в эмоджи — это способ визуального представления данных, при котором текст преобразуется в последовательность эмоджи. Такое кодирование не является криптографическим и не обеспечивает защиту данных."
    
    let secondTitle: String? = "Как работает?"
    let secondDescription: String? = "Текст сначала переводится в UTF-8, затем кодируется в Base64, после чего каждый символ заменяется соответствующим эмоджи. Благодаря этому алгоритм поддерживает любые символы и языки."
    
    let thirdTitle: String? = L10n("AboutAES256.fifthTitle")
    let thirdDescription: String? = "Не используйте кодирование в эмоджи для защиты важной информации. Для безопасной передачи данных лучше сочетать его с шифрованием — например, сначала зашифровать текст, а затем преобразовать результат в эмоджи."
    
    let fourthTitle: String? = nil
    let fourthDescription: String? = nil
    let fifthTitle: String? = nil
    let fifthDescription: String? = nil
    
    let letterType: LetterType = .emoji
}
