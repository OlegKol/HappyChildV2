//
//  AcceprPrenseter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class AcceptPrenseter: AcceptPresenterProtocol {
    
    public var viewer: AcceptViewerProtocol?
    
    public func showError(error: String) {
        viewer?.showError(error: error)
    }
    
    public func hideError() {
        viewer?.hideError()
    }
    
    public func showResentCodeButton() {
        viewer?.showResentCodeButton()
    }
    
    public func hideResentCodeButton() {
        viewer?.hideResentCodeButton()
    }
    
    public func showBusyViewer() {
        
    }
    
    public func hideBusyViewer() {
        
    }
    
    public func changedBusyState(_ state: Bool){
           self.viewer?.changedBusyState(state)
    }
    
}
