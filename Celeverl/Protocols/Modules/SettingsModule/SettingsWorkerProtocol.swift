//
//  AcceptWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol SettingsWorkerProtocol: class {
    
    func loadAccountSettings(userId: String) throws -> SettingsModel?
    func updateTimeZone(userId: String, timezone: String) throws -> Bool
    func updateCameraStatus(userId: String, status: Bool) throws -> Bool
    func updateSetings(userId: String, settings: SettingsModel) throws -> Bool
}
