//
//  BalanceRouter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class BalanceRouter: BalanceRouterProtocol {
    
    public var viewer: (UIViewController & BalanceViewerProtocol)?
    public var dataSource: BaseDataSourceProtocol?
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        
    }
    
    
}
