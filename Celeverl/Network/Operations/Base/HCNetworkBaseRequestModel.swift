//
//  HCNetworkBaseRequestModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 03.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public enum HCHttpMethod: String {
    case GET
    case POST
}

protocol HCNetworkBaseRequestModel {
    
    var requestMethod: HCHttpMethod { get }
    var requestPath: String { get }
    var requestParameters: [String : Any] { get }
    var shouldSendParametrsInBody: Bool { get }
}
