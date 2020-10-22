//
//  CameraBuilder.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class CameraBuilder {
    
    public class func  createBuilder(viewer: CameraViewerProtocol, interactor: CameraInteractorProtocol, worker:CameraWorkerProtocol) {
        viewer.interactor = interactor;
        interactor.worker = worker
        interactor.viewer = viewer
    }
}
