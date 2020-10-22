//
//  VideoFullBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/18/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class VideoFullBuilder {
    
    public class func CreateBuilder(_ viewer: FullVideoViewerProtocol, _ interactor: FullVideoInteractorProtocol, _ router: FullVideoRouterProtocol, _ presenter: FullVideoPresenterProtocol, _ worker: FullVideoWorkerProtocol) {
        
        viewer.interactor = interactor
        
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.router = router
        
        presenter.viewer = viewer
        
        router.interactor = interactor
        router.viewer = viewer as? (UIViewController & FullVideoViewerProtocol)
        
    }
}
