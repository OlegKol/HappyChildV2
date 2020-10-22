//
//  ContainerRouter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/9/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

//MARK: - ContainerRouter

public class ContainerRouter: ContainerRouterProtocol {
    
    public var viewer: (UIViewController & ContainerViewerProtocol)?
    public var interactor: BaseDataSourceProtocol?
    
    public func goToHomePage() {
    }
    
    public func goToSettingsPage() {
    }
    
    public func goToProfilePage() {
    }
    
    public func goToCameraStreamPage() {
    }
    
    
    public func goToNotificationPage() {
        let viewer = NotifyViewer()
        let router = NotifyRouter()
        let interactor = NotifyInteractor()
        let presenter = NotifyPresenter()
        let worker = NotifyWorker()

        DispatchQueue.main.async {
            NotifyBuilder.createBuilder(viewer: viewer, router: router, interactor: interactor, worker: worker, presenter: presenter)
            
            self.viewer?.present(viewer, animated: true, completion: nil)
            
        }
    }
}
