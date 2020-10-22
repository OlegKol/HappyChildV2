//
//  ReminderWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class ReminderWorker: ReminderWorkerProtocol {
   
    public func getSettingUser(_ userId: String) throws -> ReminderModel? {
        
        var model: ReminderModel?
        
        var urlComponent = URLComponents(string: AppConstants.APP_REMINDER_SETTING_URL)
        urlComponent?.queryItems = [URLQueryItem(name: "userId", value: userId)]

        let response = NetworkService.getAsync(urlComponent!)

        if response.error != nil {
           throw CustomError.invalid(message: response.error!.localizedDescription)
        }
        if let data = response.data {
           do{
            model = try ConvertService.converTo(data)
           }
           catch let parsingError {
               throw parsingError
           }
        }
        return model
    }
    
    public func updateSettingUser(_ userId: String, _ settings: ReminderModel) throws -> Bool {
        
        var result: Bool = false
        let urlComponent = URLComponents(string: AppConstants.APP_REMINDER_SETTING_URL)
        guard let url = urlComponent?.url else { fatalError() }
        
        do{
            
            let model = NetworkSettingModel()
            model.userId = userId
            model.settings = settings
            
            let settingData = try! JSONEncoder().encode(model)
            let response = try NetworkService.postAsync(url, settingData)
            
            if let convert = try JSONSerialization.jsonObject(with:response.data!, options: []) as? [String:Any] {
                if let success = convert["success"] as? Bool, success == true {
                    result = true
                }
            }
        }
        catch let error {
            throw error
        }
        
        return result
    }
}
