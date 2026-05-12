//
//  Validator.swift
//  VOID
//
//  Created by Mikhail Bukhrashvili on 03.05.26.
//

import Foundation

enum Validator {
    enum Pattern {
        case email
        case phone
        case url
        
        var regex: String {
            switch self {
            case .email: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
            case .phone: #"^\+[0-9]{7,15}$"#
            case .url:   #"^[a-z0-9.-]+\.[a-z]{2,}(/.*)?$"#
            }
        }
    }
    
    static private let predicate = "SELF MATCHES %@"
    
    static func isValid(_ value: String, type: Pattern) -> Bool {
        NSPredicate(format: predicate, type.regex).evaluate(with: value)
    }
}
