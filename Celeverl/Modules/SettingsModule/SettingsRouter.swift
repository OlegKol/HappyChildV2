//
//  SettingsRouter.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class SettingsRouter: SettingsRouterProtocol {
    
    public var dataSource: BaseDataSourceProtocol?
    
    public var viewer: (UIViewController & SettingsViewerProtocol)?
    
    public func backToView() {
        
    }
    
    
}
