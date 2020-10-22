//
//  BalancePresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public protocol BalancePresenterProtocol: class {
    
    var viewer: BalanceViewerProtocol? { get set}
    
    func changedStatePage(_ state: Bool)
    func updateView(_ data: BalanceModel)
}
