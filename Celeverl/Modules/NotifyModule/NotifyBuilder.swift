//
//  CommonBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class NotifyBuilder {
    
    class func createBuilder(viewer: NotifyViewerProtocol, router: NotifyRouterProtocol, interactor: NotifyInteractorProtocol, worker: NotifyWorkerProtocol, presenter: NotifyPresenterProtocol){
        
        interactor.worker = worker
        interactor.presenter = presenter
        interactor.router = router
        
        presenter.viewer = viewer
        viewer.interactor = interactor
        
        router.viewer = viewer as? (UIViewController & NotifyViewerProtocol)
    }
}
