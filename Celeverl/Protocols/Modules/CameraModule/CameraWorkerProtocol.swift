//
//  CameraWorkerProtocol.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol CameraWorkerProtocol:class {
    
    func getCameraList(userId: String) throws -> [CameraModel]?
    
    func addCamera(cameraId: String) throws -> Bool
}
