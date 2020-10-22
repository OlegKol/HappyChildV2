//
//  AcceptWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol NotifyWorkerProtocol: class {
    
    func getNotification(userId: String) throws -> [NotificationModel]?
    
}
