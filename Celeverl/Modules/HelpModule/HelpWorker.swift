//
//  HelpWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/29/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class HelpWorker:HelpWorkerProtocol {
    
    public func loadHelpPage(_ userId: String) throws -> HelpModel? {
        
        var documents: HelpModel? = nil
        let urlComponent = URLComponents(string: AppConstants.APP_GET_HELP_INFO_URL)
        
        let response = NetworkService.getAsync(urlComponent!)
        if response.error != nil {
            throw CustomError.invalid(message: response.error!.localizedDescription)
        }
        if let data = response.data {
            do{
                if let json = try JSONSerialization.jsonObject(with:data, options: []) as? [String: Any]{
                    documents = HelpModel(json)
                }
              }
            catch let parsingError {
                throw parsingError
            }
        }
        return documents
    }
    
    
}
