//
//  ReminderRouter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class ReminderRouter: ReminderRouterProtocol {
    
    public var viewer: (UIViewController & ReminderViewerProtocol)?
    public var dataSource: BaseDataSourceProtocol?
    
    
}
