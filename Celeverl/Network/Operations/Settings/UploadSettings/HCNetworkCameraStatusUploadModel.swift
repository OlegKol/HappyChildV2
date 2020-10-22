//
//  HCNetworkCameraStatusUploadModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 15.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCNetworkCameraStatusUploadModel {
    var userId = ""
    var needActivate: Bool?
}

extension HCNetworkCameraStatusUploadModel: HCNetworkBaseRequestModel {
    
    var requestParameters: [String : Any] {
        var params = [String : Any]()
        params["userId"] = userId
        params["needActivate"] = "\(needActivate!)"
        
        return params
    }
    
    var requestPath: String {
        return kNetworkUploadCameraStatus
    }
    
    var requestMethod: HCHttpMethod {
        return .POST
    }

    var shouldSendParametrsInBody: Bool {
        return true
    }
}

