//
//  NetworkService.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/24/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public class NetworkService{
    
    public static func getAsync(_ urlComponent: URLComponents) -> (data:Data?,resposne:URLResponse?, error:Error?) {
        var result:(Data?,URLResponse?, Error?)?
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: urlComponent.url!, completionHandler: {(Data,Response,Error) in
            result = (Data,Response,Error)
            semaphore.signal()
         }).resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return result!
    }
    
    public static func postAsync(_ url: URL, _ data: Data?) -> (data:Data?,resposne:URLResponse?, error:Error?) {
        
        var result:(Data?,URLResponse?, Error?)?
        let semaphore = DispatchSemaphore(value: 0)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if data != nil {
            request.httpBody = data
        }
        
        
        URLSession.shared.dataTask(with: request, completionHandler: {(Data,Response,Error) in
            result = (Data,Response,Error)
            semaphore.signal()
         }).resume()
        _ = semaphore.wait(timeout: .distantFuture)
        return result!
    }
}


public enum CustomError: Error {
    case invalid(message:String)
}
