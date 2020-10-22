//
//  CommonCameraWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol CommonCameraWorkerProtocol: class {
    
    func getCameraList(userId: String) throws -> [CameraModel]
    
    func getDayliDocuments(userId: String) throws -> [DocumentModel]
}
