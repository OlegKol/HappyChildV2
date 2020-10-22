//
//  StringExtension.swift
//  HappyChild (mobile)
//
//  Created by Anna on 02.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

extension String {

    public static func localize(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
     func substring(_ from: Int) -> String {
            let index = self.index(self.startIndex, offsetBy: from)
            return String(self[index...])
        }
        
        var length: Int {
            return self.count
        }

}

