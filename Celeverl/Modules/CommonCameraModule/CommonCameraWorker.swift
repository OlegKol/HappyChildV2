//
//  CommonCameraWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public class CommonCameraWorker: CommonCameraWorkerProtocol {
    
    
    public func getCameraList(userId: String) throws -> [CameraModel] {
        
        var camerasList: [CameraModel] = []
        var urlComponent = URLComponents(string: AppConstants.APP_USER_SETTING_URL)
        urlComponent?.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]
        
        let response = NetworkService.getAsync(urlComponent!)
        if response.error != nil {
            throw CustomError.invalid(message: response.error!.localizedDescription)
        }
        if let data = response.data {
            do{
                let json = try JSONSerialization.jsonObject(with:data, options: []) as! [String: Any]
                if let list = json["CameraConnections"] as? [Any] {
                    for item in list {
                        //let model = CameraModel(dic: item as! [String : Any])
                        //camerasList.append(model)
                    }
                }
                else {
                    throw CustomError.invalid(message: json["message"] as! String)
                }
              }
            catch let parsingError {
                throw parsingError
            }
        }
        return camerasList
    }
    
    public func getDayliDocuments(userId: String) throws -> [DocumentModel] {
        
        var documentsList: [DocumentModel] = []
        var urlComponent = URLComponents(string: "https://happychild.tech/api/MobileAppDailyReportInfo")
        urlComponent?.queryItems = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "isTest", value: "true")
        ]

        let response = NetworkService.getAsync(urlComponent!)
        if response.error != nil {
            throw CustomError.invalid(message: response.error!.localizedDescription)
        }
        if let data = response.data {
            do{
                if let json = try JSONSerialization.jsonObject(with:data, options: []) as? [String: Any] {
                    let document = DocumentModel(dictionary: json)
                    documentsList.append(document)
                }
             }
            catch let parsingError {
               throw parsingError
            }
        }
        return documentsList
    }
    
}
