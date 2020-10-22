//
//  ContaierViewerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/9/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol ContainerViewerProtocol: class {
    var interactor: ContainerInteractorProtocol? { get set }
    var router: ContainerRouterProtocol? {get set}
    
    var IsOpenMenu: Bool { get set}
}
