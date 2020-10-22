//
//  AcceptInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol NotifyInteractorProtocol: BaseDataSourceProtocol {
    
    var presenter: NotifyPresenterProtocol? {get set}
    var worker: NotifyWorkerProtocol? {get set}
    var router: NotifyRouterProtocol? {get set}
    
    var isBusy: Bool { get set}
    var userModel:UserModel? { get set}
    var currentCode: String? { get set}
    var notifications: [NotificationModel] { get set}
    
    func back()
    func getNotifications()
}
