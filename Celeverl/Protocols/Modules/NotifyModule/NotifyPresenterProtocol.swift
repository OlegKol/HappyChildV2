//
//  AcceptPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol NotifyPresenterProtocol : class {
    
    var viewer: NotifyViewerProtocol? {get set}
    
    func showError(error: String)
    func changedBusyState(_ state: Bool)
    func hideError()
    func updateNotifications(_ notification: [NotificationModel])
    
}
