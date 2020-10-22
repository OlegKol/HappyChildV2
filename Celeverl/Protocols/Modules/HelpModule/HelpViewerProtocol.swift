//
//  HelpViewerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/29/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol HelpViewerProtocol: class {
    
    var interactor: HelpInteractorProtocol? { get set}
    
    func updatePage(_ data: HelpModel)
    
    func updatePageState(_ state: Bool)
}
