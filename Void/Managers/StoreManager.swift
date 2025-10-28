//
//  StoreManager.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation
import StoreKit

@MainActor
final class StoreManager: ObservableObject {
    var isPremium: Bool {
        devTest
    }
    
    @Published var devTest = false
    
    init(devTest: Bool = false) {
        self.devTest = devTest
    }
}
