//
//  SettingsBuilder.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class PromoBuilder{
    
   class func createBuilder(viewer: PromoCodeViewerProtocol){
        
        let router = PromoCodeRouter()
        let worker = PromoCodeWorker()
        let presenter = PromoCodePresenter()
        let interactor = PromoCodeInteractor()
    
        interactor.worker = worker
        interactor.presenter = presenter
        interactor.router = router
        
        presenter.viewer = viewer
        viewer.interactor = interactor
        
        router.viewer = viewer  as? (UIViewController & PromoCodeViewerProtocol)
    }
}
