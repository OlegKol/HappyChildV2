//
//  CharacterSet.swift
//  HappyChild (mobile)
//
//  Created by Anna on 02.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
