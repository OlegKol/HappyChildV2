//
//  PromoCodeWorker.swift
//  Cleverl
//
//  Created by Евгений on 2/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class PromoCodeWorker: PromoCodeWorkerProtocol {
    
    public func checkCode(_ userId: String, _ code: String) throws -> (succses: Bool, message: String) {
        
        var message: String = ""
        var success: Bool = false
        
        var urlComponent = URLComponents(string: AppConstants.APP_GET_CHECK_PROMO_CODE_URL)
                   
        urlComponent?.queryItems = [
           URLQueryItem(name: "userId", value: userId),
           URLQueryItem(name: "promocode", value: code)]

        let response = NetworkService.getAsync(urlComponent!)
        if let error = response.error {
           print("Error in sending request to Notification center: \(error)")
        }
        else if let data = response.data {
           do{
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    message = jsonResponse["message"] as! String
                    success = jsonResponse["success"] as! Bool
                }
           }
           catch let anotherException {
              print("Another error in parse response from data Notification center: \(anotherException.localizedDescription)")
           }
        }
        
        return (success,message)
    }
    
    
}
