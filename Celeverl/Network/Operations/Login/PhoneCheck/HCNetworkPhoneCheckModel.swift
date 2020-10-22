//
//  HCNetworkPhoneCheckModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 03.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

class HCNetworkPhoneCheckModel {
    var phoneNumber = ""
}

extension HCNetworkPhoneCheckModel: HCNetworkBaseRequestModel {
    
    var requestParameters: [String : Any] {
        var params = [String : Any]()
        params["number"] = phoneNumber
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
