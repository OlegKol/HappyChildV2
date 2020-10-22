//
//  AcceptRotuerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol PromoCodeRouterProtocol: class {
    
    var dataSource: BaseDataSourceProtocol? {get set}
    var viewer: (PromoCodeViewerProtocol & UIViewController)? {get set}
    
    func backToView()
}
