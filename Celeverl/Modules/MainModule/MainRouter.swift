//
//  MainRouter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/28/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class MainRouter:MainRouterProtocol{
    
    public var viewer: (UIViewController & MainViewerProtocol)?
    public var dataSource: BaseDataSourceProtocol?
    
    var acceptController:AcceptViewer?
    
    public func goToCodeViewer() {
        DispatchQueue.main.async {
            
            let viewer = AcceptViewer()
            let interactor = AcceptInteractor()
            let router = AcceptRouter()
            let worker = AcceptWorker()
            let presenter = AcceptPrenseter()
            
            interactor.setCustomData(source: self.dataSource!)
            
            viewer.modalPresentationStyle = .fullScreen
            AcceptBuilder.createBuilder(viewer: viewer, interactor: interactor, router: router, worker: worker, presenter: presenter)
            
            self.viewer?.present(viewer, animated: true, completion: nil)
        }
    }
    
    public func goToCommonViewer() {
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
    
    public func goToAgreementViewer() {
        DispatchQueue.main.async {
            let str = "https://happychild.tech/PersonalData/IndexMobile"
            guard URL(string: str) != nil else { return }
            let webViewer = WebViewController()
            webViewer.url = str
            self.viewer?.present(webViewer, animated: true, completion: nil)
        }
    }
}
