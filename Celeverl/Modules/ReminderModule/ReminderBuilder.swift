//
//  ReminderBuilder.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class ReminderBuilder {
    
    class func createBudiler(viewer: ReminderViewerProtocol) {
       
           let router = ReminderRouter()
           let presenter = ReminderPresenter()
           let interactor = ReminderInteractor()
           let worker = ReminderWorker()
           
           viewer.interactor = interactor
           
           interactor.presenter = presenter
           interactor.worker = worker
           interactor.router = router
           
           router.viewer = viewer as? (UIViewController & ReminderViewerProtocol)
           router.dataSource = interactor
           presenter.viewer = viewer
       }
}
