//
//  HCNetworkService.swift
//  HappyChild (mobile)
//
//  Created by Anna on 03.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCNetworkService: HCNetworkServiceProtocol {
    
    typealias HCRequestCompletionSuccessBlock = ([String: Any]) -> Void
    typealias HCRequestCompletionErrorBlock = (Error?) -> Void

    
    func performRequest(model: HCNetworkBaseRequestModel, success: @escaping HCRequestCompletionSuccessBlock, failure: @escaping HCRequestCompletionErrorBlock) {
        
        var components = URLComponents(string: model.requestPath)!
        components.queryItems = model.requestParameters.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value as? String)
        }
        
        var request: URLRequest?
        if (!model.shouldSendParametrsInBody) {
            request = URLRequest(url: components.url!)
        } else {
            let url = URL(string: model.requestPath)!
            request = URLRequest(url: url)
            let  jsonData = try? JSONSerialization.data(withJSONObject: model.requestParameters, options: .prettyPrinted)
            request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request?.httpBody = jsonData//?.base64EncodedData()
        }
        request!.httpMethod = model.requestMethod.rawValue
        
        let task = URLSession.shared.dataTask(with: request!) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode, error == nil else {
                    failure(error)
                    return
            }

            if let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
                success(responseObject)
            } else {
                failure(nil)
            }
        }
        task.resume()
    }

    

}
