//
//  MenuViewerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/15/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol MenuViewerProtocol: class {
    
    var interactor: MenuInteractorProtocol? { get set }
    
    func changedMenuItem(item: MenuModel)
    func getListMenuItems(_ list: [MenuModel])
}
