//
//  ContainerBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/9/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class ContainerBuilder {
    
    class func createcreateBudiler(viewer: ContainerViewerProtocol, interactor: ContainerInteractorProtocol, worker: ContainerWorkerProtocol, router: ContainerRouterProtocol, presenter: ContainerPresenterProtocol) {
        
            viewer.interactor = interactor
            viewer.router = router
            
            interactor.presenter = presenter
            interactor.worker = worker
            interactor.router = router
            
            presenter.viewer = viewer
        
            router.viewer = viewer as? (UIViewController & ContainerViewerProtocol)
            router.interactor = interactor
    }
}
