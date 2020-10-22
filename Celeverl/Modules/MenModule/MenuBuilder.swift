//
//  MenuBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/15/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class MenuBuilder {
    
    class func createBuilder(viewer: MenuViewerProtocol){
        
        let worker = MenuWorker()
        let presenter = MenuPresenter()
        let interactor = MenuInteractor()
        
        viewer.interactor = interactor
        
        interactor.worker = worker
        interactor.presenter = presenter
        
        presenter.viewer = viewer
    }
}
