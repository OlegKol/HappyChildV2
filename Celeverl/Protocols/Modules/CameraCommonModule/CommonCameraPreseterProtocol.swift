//
//  CommonCameraPreseterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol CommonCameraPresenterProtcol: class {
    
    var viewer: CommonCameraViewerProtocol? { get set}
    func updateCameraList(_ list: [BaseModel])
    func updateDocument( _ documents: [DocumentModel])
}
