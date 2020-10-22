//
//  DocumentBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/27/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class HelpBuilder {
    
    public static func createBuilder(_ viewer: HelpViewerProtocol) {
        
        let router = HelpRouter()
        let presenter = HelpPresenter()
        let interactor = HelpInteractor()
        let worker = HelpWorker()
        
        viewer.interactor = interactor
        
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.router = router
        
        router.viewer = viewer as? (UIViewController & HelpViewerProtocol)
        presenter.viewer = viewer
    }
}
