//
//  HCNetworkSettingsLoadModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 15.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

class HCNetworkSettingsLoadModel {
    var userId = ""
}

extension HCNetworkSettingsLoadModel: HCNetworkBaseRequestModel {
    
    var requestParameters: [String : Any] {
        var params = [String : Any]()
        params["userId"] = userId
        return params
    }
    
    var requestPath: String {
        return kNetworkGetSettings
    }
    
    var requestMethod: HCHttpMethod {
        return .GET
    }
    
    var shouldSendParametrsInBody: Bool {
        return false
    }

}
