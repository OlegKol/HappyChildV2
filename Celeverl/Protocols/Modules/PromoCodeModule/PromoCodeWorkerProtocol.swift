//
//  AcceptWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol PromoCodeWorkerProtocol: class {
    
    func checkCode(_ userId: String, _ code: String) throws -> (succses: Bool,message: String)
}
