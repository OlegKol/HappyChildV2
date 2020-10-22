//
//  BalanceBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class BalanceBuilder {
    
    public static func createBuilder(_ viewer: BalanceViewerProtocol) {
        
        let router = BalanceRouter()
        let presenter = BalancePresenter()
        let interactor = BalanceInteractor()
        let worker = BalanceWorker()
        
        viewer.interactor = interactor
        
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.router = router
        
        router.viewer = viewer as? (UIViewController & BalanceViewerProtocol)
        router.dataSource = interactor
        presenter.viewer = viewer
    }
    
}
