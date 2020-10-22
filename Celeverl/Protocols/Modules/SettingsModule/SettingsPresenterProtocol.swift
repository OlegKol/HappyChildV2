//
//  AcceptPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol SettingsPresenterProtocol : class {
    
    var viewer: SettingsViewerProtocol? {get set}
    
    func showError(error: String)
    func changedBusyState(_ state: Bool)
    func hideError()
    func updateView(account: SettingsModel?)
}
