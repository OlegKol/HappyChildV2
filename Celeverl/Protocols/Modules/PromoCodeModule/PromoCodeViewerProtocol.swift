//
//  NotifyViewer.swift
//  Celeverl
//
//  Created by Евгений on 2/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol PromoCodeViewerProtocol: class {
    
    var interactor: PromoCodeInteractorProtocol? { get set }
    var router: PromoCodeRouterProtocol? { get set }
    
    func showError(_ error: String)
    func showMessage(_ message: String)
    func hideError()
    func changedBusyState(_ state: Bool)
    
}
