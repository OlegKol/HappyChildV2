//
//  NotifyViewer.swift
//  Celeverl
//
//  Created by Евгений on 2/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol NotifyViewerProtocol: class {
    
    var interactor: NotifyInteractorProtocol? { get set }
    var router: NotifyRouterProtocol? { get set }
    
    var notifications: [NotificationModel] { get set}
    
    func updateNotifications(_ notification: [NotificationModel])
    func showError(error: String)
    func hideError()
    func changedBusyState(_ state: Bool)
    
}
