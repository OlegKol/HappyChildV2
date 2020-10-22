//
//  BalanceWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public protocol BalanceWorkerProtocol: class {
    
    func loadBalanceData(_ userId: String) throws -> BalanceModel?
}
