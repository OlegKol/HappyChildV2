//
//  CommonCameraViewerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol CommonCameraViewerProtocol: class {
    var interactor: CommonCameraInteractorProtocol? { get set}
    var documents: [DocumentModel] { get set }
    
    func updateCameraListView(_ list: [BaseModel])
    func updateDocument( _ documents: [DocumentModel])
}
