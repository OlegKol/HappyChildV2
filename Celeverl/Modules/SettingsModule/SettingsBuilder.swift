//
//  SettingsBuilder.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class SettingsBuilder{
    
   class func createBuilder(viewer: SettingsViewerProtocol){
        
        let router = SettingsRouter()
        let worker = SettingsWorker()
        let presenter = SettingsPresenter()
        let interactor = SettingsInteractor()
    
        interactor.worker = worker
        interactor.presenter = presenter
        interactor.router = router
        
        presenter.viewer = viewer
        viewer.interactor = interactor
        
        router.viewer = viewer  as? (UIViewController & SettingsViewerProtocol)
    }
}
