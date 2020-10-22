//
//  Error.swift
//  HappyChild (mobile)
//
//  Created by Anna on 03.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public struct HCCustomError: Error {
    let message: String
}

extension HCCustomError: LocalizedError {
    public var errorDescription: String? {
        return String.localize(message)
    }
}
