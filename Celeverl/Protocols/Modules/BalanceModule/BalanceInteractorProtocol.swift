//
//  BalanceInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public protocol BalanceInteractorProtocol: BaseDataSourceProtocol {
    
    var router: BalanceRouterProtocol? { get set }
    var worker: BalanceWorkerProtocol? { get set }
    var presenter: BalancePresenterProtocol? { get set }
    
    var IsBusy: Bool { get set}
    var balanceData: BalanceModel? { get set }
    
    func loadBalanceData()
}
