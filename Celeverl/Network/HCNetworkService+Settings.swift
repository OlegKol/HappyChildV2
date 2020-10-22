//
//  HCNetworkService + Settings.swift
//  HappyChild (mobile)
//
//  Created by Anna on 15.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

extension HCNetworkService {
    
    func loadSettingsForUser(_ userId: String, completion: @escaping HCNetworkSettingstHandler) {
        let model = HCNetworkSettingsLoadModel()
        
        model.userId = userId
        
        performRequest(model: model, success: { (response) in
            
            let settings = HCSettingsModel()
            
            if let timeOffset = response["TimeZoneOffsetInHours"] as? Int {
                settings.timeZone = timeOffset
            }
            
            if let balance = response["Balance"] as? Dictionary<String, Any> {
                if let changeHistory = balance["ChangeHistory"] as? Array<Any> {
                    settings.balance = changeHistory.first as? Int ?? 0
                }
            }
            
            if let camera = (response["CameraConnections"] as! Array<Dictionary<String, Any>>).first {
                settings.camera = HCCameraSettingsModel()
                
                settings.camera!.isActive = camera["IsActive"] as? Bool
                settings.camera!.isForWholeDay = camera["IsForWholeDay"] as? Bool
                
                settings.camera!.endDate = camera["DateEndStr"] as! String == "null" ? nil : Date.dateFromString(camera["DateEndStr"] as! String)
                settings.camera!.startDate = camera["DateStartStr"] as! String == "null" ? nil : Date.dateFromString(camera["DateStartStr"] as! String)
                
                settings.camera!.startHour = camera["StartHour"] as? Int
                settings.camera!.endHour = camera["EndHour"] as? Int
                
                if (camera["SelectedDays"] as? String != nil && (camera["SelectedDays"] as! String) != "null") {
                    
                    let string: [String] = (camera["SelectedDays"] as! String).map { String($0) }
                    let selectedDays = string.filter { $0 != "," && $0 != " " }
                    settings.camera!.selectedDays = [Int]()
                    for day in selectedDays {
                        settings.camera!.selectedDays?.append(Int(day)!)
                    }
                }
                
                if let id = camera["Type"] as? Int, id < HCCameraMode.allCases.count {
                    settings.camera!.type = HCCameraMode.allCases[id]
                }
                else {
                    settings.camera!.type = HCCameraMode.allCases[0]
                }
            }
            
            completion(settings, nil)
            
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func uploadTimeZoneForUser(_ userId: String, timeZone: Int, completion: @escaping HCNetworkUploadTimeZoneHandler) {
        let model = HCNetworkTimeZoneUploadModel()
        
        model.userId = userId
        model.timeZone = timeZone
        
        performRequest(model: model, success: { (response) in
            let successResult = response["success"]
            
            guard successResult != nil, (successResult as? Bool) == true else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(false, e)
                return
            }
            completion(true, nil)
            
        }) { (error) in
            guard let _ = error else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(false, e)
                return
            }
            completion(false, error)
        }
    }
    
    func uploadCameraStatusForUser(_ userId: String, status: Bool, completion: @escaping HCNetworkUploadCameraStatusHandler) {
        let model = HCNetworkCameraStatusUploadModel()
        
        model.userId = userId
        model.needActivate = status
        
        performRequest(model: model, success: { (response) in
            let successResult = response["success"]
            
            guard successResult != nil, (successResult as? Bool) == true else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(false, e)
                return
            }
            completion(true, nil)
            
        }) { (error) in
            guard let _ = error else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(false, e)
                return
            }
            completion(false, error)
        }
    }
    
    func uploadCameraSettingsForUser(_ userId: String, settings: HCCameraSettingsModel, completion: @escaping HCNetworkUploadCameraSettingsHandler) {
        let model = HCNetworkCameraSettingsUploadModel()
        
        model.userId = userId
        model.dateEnd = settings.endDate?.stringFromDate()
        model.dateStart = settings.startDate?.stringFromDate()
        model.endHour = settings.endHour
        model.startHour = settings.startHour
        model.type = HCCameraMode.allCases.lastIndex(of: settings.type!)
        model.selectedDays = settings.selectedDays
        
        performRequest(model: model, success: { (response) in
            let successResult = response["success"]
            
            guard successResult != nil, (successResult as? Bool) == true else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(false, e)
                return
            }
            completion(true, nil)
            
        }) { (error) in
            guard let _ = error else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(false, e)
                return
            }
            completion(false, error)
        }
    }
}
