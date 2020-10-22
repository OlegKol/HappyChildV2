//
//  BaseDataSource.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/5/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

//MARK: - BaseDataSource

public protocol BaseDataSourceProtocol: class {
    
    func getDataSource() -> [String:Any]
    func setCustomData(source: BaseDataSourceProtocol)
    
}
