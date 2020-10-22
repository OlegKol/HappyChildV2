//
//  AcceptRotuerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol NotifyRouterProtocol: class {
    
    var dataSource: BaseDataSourceProtocol? {get set}
    var viewer: (NotifyViewerProtocol & UIViewController)? {get set}
    
    func backToView()
}
