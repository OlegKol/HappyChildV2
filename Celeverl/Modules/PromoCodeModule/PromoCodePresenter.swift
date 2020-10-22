//
//  PromoCodePresenter.swift
//  Cleverl
//
//  Created by Евгений on 2/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit


public class PromoCodePresenter: PromoCodePresenterProtocol {
    
    public var viewer: PromoCodeViewerProtocol?
    
    public func showError(_ error: String) {
        self.viewer?.showError(error)
    }
    
    public func changedBusyState(_ state: Bool) {
        self.viewer?.changedBusyState(state)
    }
    
    public func hideError() {
        self.viewer?.hideError()
    }
    
    public func showMessage(_ message: String) {
        self.viewer?.showMessage(message)
    }
    
    
}
