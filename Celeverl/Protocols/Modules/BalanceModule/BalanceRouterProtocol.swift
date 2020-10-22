//
//  BalanceRouterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol BalanceRouterProtocol: BaseDataSourceProtocol {
    
    var viewer: (BalanceViewerProtocol & UIViewController)? { get set}
    var dataSource: BaseDataSourceProtocol? { get set}
}
