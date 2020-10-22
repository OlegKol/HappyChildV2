//
//  DocumentBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/27/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class DocumentBuilder {
    
    public static func createBuilder(_ viewer: DocumentViewerProtocol) {
        
        let router = DocumentRouter()
        let presenter = DocumentPresenter()
        let interactor = DocumentInteractor()
        let worker = DocumentWorker()
        
        viewer.interactor = interactor
        
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.router = router
        
        router.viewer = viewer as? (UIViewController & DocumentViewerProtocol)
        presenter.viewer = viewer
    }
    
}
