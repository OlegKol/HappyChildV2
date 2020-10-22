//
//  MainRouterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/28/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol MainRouterProtocol: class {
    
    var viewer: (MainViewerProtocol & UIViewController)? {get set}
    var dataSource: BaseDataSourceProtocol? {get set}
    
    func goToCodeViewer()
    func goToCommonViewer()
    func goToAgreementViewer()
}
