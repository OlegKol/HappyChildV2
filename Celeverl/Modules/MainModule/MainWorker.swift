//
//  MainWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/28/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class MainWorker:MainWorkerProtocol {
    
    public func getListCountryCodes() -> [CountryCodeModel] {
        let list = [
            CountryCodeModel(id: "0", title: "Belarus", code: 375),
            CountryCodeModel(id: "1", title: "Russia", code: 7),
            CountryCodeModel(id: "2", title: "USA", code: 1),
            CountryCodeModel(id: "3", title: "Canada", code: 2),
            CountryCodeModel(id: "4", title: "Armenia", code: 374)
        ]
        return list
    }
    
    
    public func checkCorrectMobilePhone(mobile: String) -> Bool {
        return true
    }
    
    public func firstRegistrationUser(mobile: String) throws -> Bool {
        
        var result: Bool = false
        
        var urlComponent = URLComponents(string: AppConstants.APP_REGISTER_PHONE_URL)
        urlComponent?.queryItems = [URLQueryItem(name: "number", value: mobile)]
        
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
                        result = true
                    }
                }
              }
            catch let parsingError {
                throw parsingError
            }
        }
        return result
    }
}
