//
//  SettingsPresenter.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class SettingsPresenter: SettingsPresenterProtocol {
   
    public var viewer: SettingsViewerProtocol?
    
    public func showError(error: String) {
        
    }
    
    public func changedBusyState(_ state: Bool) {
        self.viewer?.changedBusyState(state)
    }
    
    public func hideError() {
        
    }
    
    public func updateView(account: SettingsModel?) {
        self.viewer?.updateView(account: account)
    }
    
}
