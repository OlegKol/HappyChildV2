//
//  LocalPlayerProtocol.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol LocalPlayerProtocol:BasePlayerProtocol {
    
    func Next(seconds: Int)
    func Prev(seconds: Int)
    
    var currentTime: Date { get set }
    var allTime: Date { get set }
}
