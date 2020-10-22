//
//  ReminderRouterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol ReminderRouterProtocol: class {
    
    var viewer: (ReminderViewerProtocol & UIViewController)? { get set}
    var dataSource: BaseDataSourceProtocol? { get set}
}
