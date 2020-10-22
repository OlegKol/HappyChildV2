//
//  SettingsWorker.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class SettingsWorker: SettingsWorkerProtocol {
    
    
    public func loadAccountSettings(userId: String) throws -> SettingsModel? {
        var userSettings: SettingsModel?
        let url = URLComponents(string: "https://happychild.tech/api/MobileAppProfile/GetUserProfileData")
        guard var urlComponent = url else { return userSettings }
        
        urlComponent.queryItems = [URLQueryItem(name: "userId", value: userId)]
        
        let response = NetworkService.getAsync(urlComponent)
        if let error = response.error {
           print("Error in sending request to Notification center: \(error)")
        }
        else if let data = response.data {
            do {
                userSettings = try ConvertService.converTo(data)
            }
            catch let error {
                print(error)
            }
        }
        return userSettings
    }
    
    public func updateTimeZone(userId: String, timezone: String) throws -> Bool {
        var result = false
        let url = URLComponents(string: "https://happychild.tech/api/MobileAppProfile/SaveUtsOffset")
        guard let urlComponent = url else { return result }
        
        let parameters = [
           "userId": userId,
           "offset" : timezone
        ]
        let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        let response = NetworkService.postAsync(urlComponent.url!, data)
        
        if let error = response.error {
           print("Error in sending request to Notification center: \(error)")
        }
        else if let data = response.data {
            do {
                result = true
            }
            catch let error {
                print(error)
            }
        }
        return result
    }
    
    public func updateCameraStatus(userId: String, status: Bool) throws -> Bool {
        var result = false
        let urlComponent = URLComponents(string: "https://happychild.tech/api/MobileAppCameraStatus")
        guard let component = urlComponent else { return result }
        
        let url = component.url!
        
        let parameters = [
            "userId": userId,
            "needActivate" : String(status)
        ]
        let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          
        let response = NetworkService.postAsync(url, data)
        if let error = response.error {
            print("Error in sending request to Notification center: \(error)")
        }
        else if let data = response.data {
            do {
              result = true
            }
            catch let error {
              print(error)
            }
        }
        return result
    }
    
    
    public func updateSetings(userId: String, settings: SettingsModel) throws -> Bool {
        
        var result = false
        let urlComponent = URLComponents(string: "https://happychild.tech/api/MobileAppCameraSettings")
        guard let component = urlComponent, let cameraConnection = settings.CameraConnections.first else { return result }
        
        let url = component.url!
        
        let parameters = [
            "userId": userId,
            "Type" : "\(cameraConnection.type)",
            "StartHour" : "\(cameraConnection.StartHour)",
            "EndHour" : "\(cameraConnection.EndHour)",
            "SelectedDays" : cameraConnection.SelectedDays ?? "nil",
            "DateStart" : cameraConnection.DateStartStr,
            "DateEnd" : cameraConnection.DateEndStr
        ]
        let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
          
        let response = NetworkService.postAsync(url, data)
        if let error = response.error {
            print("Error in sending request to Notification center: \(error)")
        }
        else if let data = response.data {
            do {
              result = true
            }
            catch let error {
              print(error)
            }
        }
        return result
    }
    
    
}
