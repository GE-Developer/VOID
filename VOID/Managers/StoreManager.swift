//
//  StoreManager.swift
//  VOID
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
    
    @Published var devTest: Bool
    
    init() {
        devTest = UserDefaults.standard.bool(forKey: AppStorageKey.devTest.key)
    }
}
