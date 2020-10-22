//
//  HCNetworkCodeCorfirmModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 03.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCNetworkCodeCorfirmModel {
    var phoneNumber = ""
    var code = ""
    var lang = ""
    var timeZoneOffset = ""
}

extension HCNetworkCodeCorfirmModel: HCNetworkBaseRequestModel {
    
    var requestParameters: [String : Any] {
        var params = [String : Any]()
        
        params["number"] = phoneNumber
        params["code"] = code
        params["timeZoneOffset"] = timeZoneOffset
        params["lang"] = lang
        
        return params
    }
    
    var requestPath: String {
        return kNetworkRegisterByPhoneUrl
    }
    
    var requestMethod: HCHttpMethod {
        return .GET
    }
    
    var shouldSendParametrsInBody: Bool {
        return false
    }

}
