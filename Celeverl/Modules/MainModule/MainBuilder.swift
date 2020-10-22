//
//  MainBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/27/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class MainBuilder {
    
    class func createBudiler(viewer: MainViewerProtocol) {
    
        let router = MainRouter()
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let worker = MainWorker()
        
        viewer.router = router
        viewer.interactor = interactor
        
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.router = router
        
        router.viewer = viewer as? (UIViewController & MainViewerProtocol)
        router.dataSource = interactor
        presenter.viewer = viewer
        
    }
}
