//
//  DocumentPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol HelpPresenterProtocol: class {
    
    var viewer: HelpViewerProtocol? { get set}
    
    func updatePage(_ data: HelpModel)
    
    func updatePageState(_ state: Bool)
}
