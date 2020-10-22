//
//  CommonCameraRouter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class CommonCameraRouter: CommonCameraRouterProtocol {
    
    public var viewer: (UIViewController & CommonCameraViewerProtocol)?
    public var interactor: CommonCameraInteractorProtocol?
    
    
    public func goToFullVideo() {
        let viewer = VideoFullViewer()
        let interactor = VideoFullInteractor()
        let router = FullVideoRouter()
        let presenter = FullVideoPresenter()
        let worker = FullVideoWorker()
        
        if self.interactor != nil {
            interactor.setCustomData(source: self.interactor!)
        }
        
        viewer.modalPresentationStyle = .fullScreen
        VideoFullBuilder.CreateBuilder(viewer, interactor, router, presenter, worker)
        
        self.viewer?.present(viewer, animated: true, completion: nil)
       }
}
