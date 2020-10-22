//
//  CodeAccpetBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class AcceptBuilder {
    
    class func createBuilder(viewer: AcceptViewerProtocol, interactor: AcceptInteractorProtocol, router: AcceptRouterProtocol, worker: AcceptWorkerProtocol, presenter: AcceptPresenterProtocol){
        
        viewer.interactor = interactor
        viewer.router = router
        
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.router = router
        
        presenter.viewer = viewer
    
        router.viewer = viewer as? (UIViewController & AcceptViewerProtocol)
        router.dataSource = interactor
    }
}
