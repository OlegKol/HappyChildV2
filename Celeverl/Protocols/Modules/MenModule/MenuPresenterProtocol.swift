//
//  MenuPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/15/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol MenuPresenterProtocol:class {
    
    var viewer: MenuViewerProtocol? {get set}
    
    func changedMenuItem(item: MenuModel)
    func getListMenuItems(_ list: [MenuModel])
}
