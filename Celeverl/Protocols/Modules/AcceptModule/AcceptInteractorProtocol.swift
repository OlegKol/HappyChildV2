//
//  AcceptInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol AcceptInteractorProtocol: BaseDataSourceProtocol {
    
    var presenter: AcceptPresenterProtocol? {get set}
    var worker: AcceptWorkerProtocol? {get set}
    var router: AcceptRouterProtocol? {get set}
    
    var isBusy: Bool { get set}
    var userModel:UserModel? { get set}
    var currentCode: String? { get set}
    
    func back()
    func changeCodeField(code: String)
    func checkCode()
    
}
