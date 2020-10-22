//
//  HCNetworkTaskListLoadModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 05.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

class HCNetworkTaskListLoadModel {
    var userId = ""
}

extension HCNetworkTaskListLoadModel: HCNetworkBaseRequestModel {
    
    var requestParameters: [String : Any] {
        var params = [String : Any]()
        params["userId"] = userId
        return params
    }
    
    var requestPath: String {
        return kNetworkGetTaskList
    }
    
    var requestMethod: HCHttpMethod {
        return .GET
    }

    var shouldSendParametrsInBody: Bool {
        return false
    }
}
