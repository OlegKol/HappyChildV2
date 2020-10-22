//
//  AcceptRotuerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol AcceptRouterProtocol: class {
    
    var dataSource: BaseDataSourceProtocol? {get set}
    var viewer: (AcceptViewerProtocol & UIViewController)? {get set}
    
    func goToCommonView()
    func backToView()
}
