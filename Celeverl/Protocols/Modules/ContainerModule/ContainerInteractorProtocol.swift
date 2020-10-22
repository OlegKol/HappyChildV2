//
//  ContainerInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/9/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol ContainerInteractorProtocol: BaseDataSourceProtocol {
    var router: ContainerRouterProtocol? {get set}
    var presenter: ContainerPresenterProtocol? { get set}
    var worker: ContainerWorkerProtocol? { get set}
    
    var currentMenuItem: MenuModel? {get set}
    var userModel: UserModel? { get set}
    
    func loadDefaultData()
    
    func goToNotificationPage()
}
