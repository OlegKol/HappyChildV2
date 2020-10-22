//
//  CameraWorker.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class CameraWorker: CameraWorkerProtocol {
    
    public func getCameraList(userId: String) throws -> [CameraModel]? {
        
        var cameraList: [CameraModel]? = []
        
        var urlComponent = URLComponents(string: AppConstants.APP_GET_CAMERAS_LIST_URL)
        urlComponent?.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]
        
        let response = NetworkService.getAsync(urlComponent!)
        if let error = response.error {
           print("Error in sending request to Notification center: \(error)")
        }
        else if let data = response.data {
            do {
                let json = try JSONSerialization.jsonObject(with:data, options: []) as! [String: Any]
                if let data = json["data"] as? [[String:Any]] {
                    for element in data {
                        cameraList?.append(CameraModel(dic: element))
                    }
                }
//                cameraList = try ConvertService.converTo(data)
            }
            catch let error {
                print(error)
            }
        }
        return cameraList
    }
    
    public func addCamera(cameraId: String) throws -> Bool {
        return false
    }
}
