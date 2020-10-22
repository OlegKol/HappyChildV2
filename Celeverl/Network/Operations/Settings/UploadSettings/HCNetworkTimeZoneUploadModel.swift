//
//  HCNetworkTimeZoneUploadModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 15.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCNetworkTimeZoneUploadModel {
    var userId = ""
    var timeZone: Int?
}

extension HCNetworkTimeZoneUploadModel: HCNetworkBaseRequestModel {
    
    var requestParameters: [String : Any] {
        var params = [String : Any]()
        params["userId"] = userId
        params["offset"] = "\(timeZone!)"
        
        return params
    }
    
    var requestPath: String {
        return kNetworkUploadTimeZone
    }
    
    var requestMethod: HCHttpMethod {
        return .POST
    }

    var shouldSendParametrsInBody: Bool {
        return true
    }
}
