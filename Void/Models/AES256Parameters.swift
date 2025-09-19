//
//  AES256Parameters.swift
//  Void
//
//  Created by GE-Developer
//

import Foundation

struct AES256Parameters: Equatable {
    var password: String
    var salt: Int
    var iterations: UInt16
    var memory: UInt32
    var parallelism: UInt8
    var keyLength: UInt8
    var layers: UInt8
    var selectedHours: Int
    var selectedMinutes: Int
    var dateInactive: Bool
    
    var duration: UInt64 {
        let timeInterval = TimeInterval((selectedHours * 60 + selectedMinutes) * 60)
        
        return UInt64(
            self.dateInactive
            ? 0
            : (Date().timeIntervalSince1970 + timeInterval)
        )
    }
    
    var actualLayers: UInt8 {
        min(layers, keyLength / 32)
    }
}
