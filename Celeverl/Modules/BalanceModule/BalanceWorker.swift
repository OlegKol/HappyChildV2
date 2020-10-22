//
//  BalanceWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation



public class BalanceWorker: BalanceWorkerProtocol {
    
    public func loadBalanceData(_ userId: String) throws -> BalanceModel? {
        
        var model: BalanceModel? = nil
        var url = URLComponents(string: AppConstants.APP_GETTING_USER_BALANCE_URL)
        
        url?.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]
        
        guard let urlComponent = url else { return model }
        let response = NetworkService.getAsync(urlComponent)
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
    
}
