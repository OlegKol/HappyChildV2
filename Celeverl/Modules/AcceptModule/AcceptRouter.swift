//
//  AcceptRouter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class AcceptRouter: AcceptRouterProtocol {
    
    public var dataSource: BaseDataSourceProtocol?
    public var viewer: (AcceptViewerProtocol & UIViewController)?
    
    public func goToCommonView() {
        DispatchQueue.main.async {
            let viewer = ContainerViewer()
            let router = ContainerRouter()
            let presneter = ContainerPresenter()
            let worker = ContainerWorker()
            let interactor = ContainerInteractor()
            interactor.setCustomData(source: self.dataSource!)
            
            ContainerBuilder.createcreateBudiler(viewer: viewer, interactor: interactor, worker: worker, router: router, presenter: presneter)
            
            viewer.modalPresentationStyle = .fullScreen
            UIApplication.shared.keyWindow?.rootViewController = viewer
        }
    }
    
    public func backToView(){
        self.viewer?.dismiss(animated: true, completion: nil)
    }
    
}
