//
//  HCNetworkCameraSettingsUploadModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 19.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCNetworkCameraSettingsUploadModel {
    var userId = ""
    var type: Int?
    var startHour: Int?
    var endHour: Int?
    var selectedDays: [Int]?
    var dateStart: String?
    var dateEnd: String?
}

extension HCNetworkCameraSettingsUploadModel: HCNetworkBaseRequestModel {
    
    var requestParameters: [String : Any] {
        var params = [String : Any]()
        params["userId"] = userId
        params["Type"] = type ?? 0
        params["StartHour"] = startHour ?? 0
        params["EndHour"] = endHour ?? 24
        
       
        let stringArray = selectedDays?.map { String($0) }
        let string = stringArray?.joined(separator: ", ") ?? "null"
        
        params["SelectedDays"] = string
        params["DateStart"] = dateStart != nil ? "\(dateStart!)" : nil
        params["DateEnd"] = dateEnd != nil ? "\(dateEnd!)" : nil
        
        return params
    }
    
    var requestPath: String {
        return kNetworkUploadCameraSettings
    }
    
    var requestMethod: HCHttpMethod {
        return .POST
    }

    var shouldSendParametrsInBody: Bool {
        return true
    }
}
