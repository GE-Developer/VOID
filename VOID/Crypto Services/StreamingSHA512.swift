//
//  StreamingSHA512.swift
//  VOID
//
//  Created by GE-Developer
//

import Foundation
import CryptoKit

final class StreamingSHA512 {
    private var hasher = SHA512()

    func update(_ data: Data) {
        hasher.update(data: data)
    }

    func finalize() -> Data {
        Data(hasher.finalize())
    }
}
