//
//  AcceptPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol AcceptPresenterProtocol : class {
    
    var viewer: AcceptViewerProtocol? {get set}
    
    func showError(error: String)
    
    func changedBusyState(_ state: Bool)
    
    func hideError()
    
    func showResentCodeButton()
    
    func hideResentCodeButton()
    
    func showBusyViewer()
    
    func hideBusyViewer()
}
