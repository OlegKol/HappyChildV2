//
//  WebServices.swift
//  WowVenue
//
//  Created by Sourabh Pal on 31/05/18.
//  Copyright © 2018 Kavya. All rights reserved.
//

import UIKit

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate




let cameraList = "https://happychild.tech/api/MobileAppCameraSettings/"
let cameraAdd = "https://happychild.tech/api/MobileAppIpEyeCameraAdd/"
let unreadPushCount = "https://happychild.tech/api/MobileAppUnreadPushCount"
