//
//  HCNetworkService + Login.swift
//  HappyChild (mobile)
//
//  Created by Anna on 03.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

extension HCNetworkService {
    
    func checkPhoneNumber(_ phoneNumber: String, _ completion: @escaping HCNetworkPhoneNumberCheckHandler) {
        
        let requestModel = HCNetworkPhoneCheckModel()
        requestModel.phoneNumber = phoneNumber
        
        performRequest(model: requestModel, success: { (response) in
            
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
    
    func checkCode(_ code: String, forPhoneNumber number: String, _ completion: @escaping HCNetworkCodeConfirmHandler) {
        let requestModel = HCNetworkCodeCorfirmModel()
        
        requestModel.code = code
        requestModel.phoneNumber = number
        requestModel.lang = NSLocale.preferredLanguages[0]
        requestModel.timeZoneOffset = String(TimeZone.current.abbreviation()!.dropFirst(3))
        
        performRequest(model: requestModel, success: { (response) in
            
            let userId = response["userId"] as? String
            
            guard userId != nil, !userId!.isEmpty else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(nil, e)
                return
            }
            
            completion(userId, nil)
        }) { (error) in
            guard let _ = error else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(nil, e)
                return
            }
            
            completion(nil, error)
        }
    }
}
