//
//  CreateRouterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/9/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol ContainerRouterProtocol: class {
    
    var viewer:(ContainerViewerProtocol & UIViewController)? { get set}
    var interactor: BaseDataSourceProtocol? {get set}
    
    func goToHomePage()
    
    func goToSettingsPage()
    
    func goToProfilePage()
    
    func goToCameraStreamPage()
    
    func goToNotificationPage()
}
