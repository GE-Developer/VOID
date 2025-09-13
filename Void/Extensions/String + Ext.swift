//
//  String + Ext.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

// " \nText" - Один перенос
// " \n\nText" - Два переноса
// "**Text**" - Жирный
// "_Text_" - Зачёркнутый
// "~~Text~~" - Курсив

extension String {
    var asMarkdown: AttributedString {
        (try? AttributedString(markdown: self)) ?? AttributedString(self)
    }
}
