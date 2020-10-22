//
//  NotifyPresenter.swift
//  Celeverl
//
//  Created by Евгений on 2/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class NotifyPresenter: NotifyPresenterProtocol {
    
    public var viewer: NotifyViewerProtocol?
    
    public func showError(error: String) {
        self.viewer?.showError(error: error)
    }
    
    public func changedBusyState(_ state: Bool) {
        self.viewer?.changedBusyState(state)
    }
    
    public func hideError() {
        self.viewer?.hideError()
    }
    
    public func updateNotifications(_ notification: [NotificationModel]) {
        self.viewer?.updateNotifications(notification)
    }
    
}
