//
//  AboutEncryptionProtocol.swift
//  VOID
//
//  Created by GE-Developer
//

protocol AboutEncryptionProtocol {
    var title: String { get }
    var subtitle: String { get }
    
    var firstTitle: String { get }
    var firstDescription: String { get }
    
    var secondTitle: String? { get }
    var secondDescription: String? { get }
    
    var thirdTitle: String? { get }
    var thirdDescription: String? { get }
    
    var fourthTitle: String? { get }
    var fourthDescription: String? { get }
    
    var fifthTitle: String? { get }
    var fifthDescription: String? { get }
    
    var letterType: LetterType { get }
}
