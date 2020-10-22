//
//  TimeZone.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/25/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

extension TimeZone {
    
    func offsetInHours() -> String
    {
        let hours = secondsFromGMT() / 3600
        let result = hours > 0 ? "+\(hours)" : "\(hours)"
        return result
    }
}
