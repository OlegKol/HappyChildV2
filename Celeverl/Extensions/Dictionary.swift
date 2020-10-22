//
//  Dictionary.swift
//  HappyChild (mobile)
//
//  Created by Anna on 02.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}
