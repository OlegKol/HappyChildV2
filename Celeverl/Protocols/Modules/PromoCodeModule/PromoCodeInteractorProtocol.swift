//
//  AcceptInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol PromoCodeInteractorProtocol: BaseDataSourceProtocol {
    
    var presenter: PromoCodePresenterProtocol? {get set}
    var worker: PromoCodeWorkerProtocol? {get set}
    var router: PromoCodeRouterProtocol? {get set}
    
    var isBusy: Bool { get set}
    var Code: String { get set}
    
    func back()
    func changeCode(_ code:String)
    func checkCode()
}
