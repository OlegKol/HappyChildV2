//
//  AcceptViewerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol AcceptViewerProtocol: class {
    
    var interactor: AcceptInteractorProtocol? { get set }
    
    var router: AcceptRouterProtocol? { get set }
    
    func showError(error: String)
    
    func hideError()
    
    func showResentCodeButton()
    
    func hideResentCodeButton()
    
    func toggleBusyState(_ state: Bool)
    
    func changedBusyState(_ state: Bool)
}
