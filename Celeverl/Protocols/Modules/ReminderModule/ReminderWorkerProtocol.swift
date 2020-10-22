//
//  ReminderWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public protocol ReminderWorkerProtocol: class {
    
    func getSettingUser(_ userId: String) throws -> ReminderModel?
    
    func updateSettingUser(_ userId: String, _ settings: ReminderModel) throws -> Bool
}
