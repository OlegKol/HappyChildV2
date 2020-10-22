//
//  NotifyViewer.swift
//  Celeverl
//
//  Created by Евгений on 2/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol SettingsViewerProtocol: class {
    
    var interactor: SettingsInteractorProtocol? { get set }
    var router: SettingsRouterProtocol? { get set }
    
    func showError(error: String)
    func hideError()
    func changedBusyState(_ state: Bool)
    func updateView(account: SettingsModel?)
    
}
