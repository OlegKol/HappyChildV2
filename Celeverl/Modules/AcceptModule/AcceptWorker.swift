//
//  AcceptWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/4/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public class AcceptWorker: AcceptWorkerProtocol {
    
    public func confirmUser(phone: String, code: String) throws -> UserModel? {
        
        var user: UserModel? = nil
        var urlComponent = URLComponents(string: AppConstants.APP_CONFIRM_OCDE_URL)
        let language = NSLocale.current.languageCode
        let timeZone = TimeZone.current.offsetInHours()
        
        urlComponent?.queryItems = [
            URLQueryItem(name: "number", value: phone),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "timeZoneOffset", value: timeZone),
            URLQueryItem(name: "lang", value: language),
            URLQueryItem(name: "deviceId", value: kAppDelegate.pushToken),
            URLQueryItem(name: "isClever", value: "false")
        ]
        
        let response = NetworkService.getAsync(urlComponent!)
        if response.error != nil {
            throw CustomError.invalid(message: response.error!.localizedDescription)
        }
        if let data = response.data {
            do{
                let json = try JSONSerialization.jsonObject(with:data, options: []) as! [String: Any]
                if let value = json["success"] as? Int {
                    if value == 0 {
                        throw CustomError.invalid(message: json["message"] as! String)
                    }
                    else if value == 1 {
                        user = UserModel()
                        user?.Id = json["userId"] as! String
                    }
                }
              }
            catch let parsingError {
                throw parsingError
            }
        }
        return user
    }
    
}
