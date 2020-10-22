//
//  HCNetworkServiceProtocol.swift
//  HappyChild (mobile)
//
//  Created by Anna on 03.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

public typealias HCNetworkPhoneNumberCheckHandler = (_ success: Bool, _ error: Error?) -> Void
public typealias HCNetworkCodeConfirmHandler = (_ userId: String?, _ error: Error?) -> Void
public typealias HCNetworkTaskListHandler = (_ list: [HCTaskModel]?, _ error: Error?) -> Void
public typealias HCNetworkUploadTaskListHandler = (_ success: Bool, _ error: Error?) -> Void
public typealias HCNetworkSettingstHandler = (_ settings: HCSettingsModel?, _ error: Error?) -> Void
public typealias HCNetworkUploadTimeZoneHandler = (_ success: Bool, _ error: Error?) -> Void
public typealias HCNetworkUploadCameraStatusHandler = (_ success: Bool, _ error: Error?) -> Void
public typealias HCNetworkUploadCameraSettingsHandler = (_ success: Bool, _ error: Error?) -> Void



protocol HCNetworkServiceProtocol {
    
    func checkPhoneNumber(_ phoneNumber: String, _ completion: @escaping HCNetworkPhoneNumberCheckHandler)
    
    func checkCode(_ code: String, forPhoneNumber number: String, _ completion: @escaping HCNetworkCodeConfirmHandler)
    
    func loadTaskListForUser(_ userId: String, completion: @escaping HCNetworkTaskListHandler)
    
    func uploadTaskListForUser(_ userId: String, tasks: [HCTaskModel]?, completion: @escaping HCNetworkUploadTaskListHandler)
    
    func loadSettingsForUser(_ userId: String, completion: @escaping HCNetworkSettingstHandler)
    
    func uploadTimeZoneForUser(_ userId: String, timeZone: Int, completion: @escaping HCNetworkUploadTimeZoneHandler)
    
    func uploadCameraStatusForUser(_ userId: String, status: Bool, completion: @escaping HCNetworkUploadCameraStatusHandler)

    func uploadCameraSettingsForUser(_ userId: String, settings: HCCameraSettingsModel, completion: @escaping HCNetworkUploadCameraSettingsHandler)
}
