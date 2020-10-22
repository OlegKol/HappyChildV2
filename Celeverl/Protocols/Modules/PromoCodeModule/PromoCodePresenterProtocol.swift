//
//  AcceptPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol PromoCodePresenterProtocol : class {
    
    var viewer: PromoCodeViewerProtocol? { get set }
    
    func showError(_ error: String)
    func showMessage(_ message: String)
    func changedBusyState(_ state: Bool)
    func hideError()
}
