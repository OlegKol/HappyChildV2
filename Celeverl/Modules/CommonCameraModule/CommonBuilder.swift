//
//  CommonBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class CommonBuilder {
    
    class func createBuilder(viewer: CommonCameraViewerProtocol, router: CommonCameraRouterProtocol, interactor: CommonCameraInteractorProtocol, worker: CommonCameraWorkerProtocol, presenter: CommonCameraPresenterProtcol){
        
        interactor.worker = worker
        interactor.presenter = presenter
        interactor.router = router
        
        presenter.viewer = viewer
        
        viewer.interactor = interactor
        
        router.viewer = viewer as? (UIViewController & CommonCameraViewerProtocol)
        router.interactor = interactor
    }
}
