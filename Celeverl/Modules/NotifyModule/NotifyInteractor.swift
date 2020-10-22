//
//  NotifyInteractor.swift
//  Celeverl
//
//  Created by Евгений on 2/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class NotifyInteractor: NotifyInteractorProtocol {
    
    public var presenter: NotifyPresenterProtocol?
    public var worker: NotifyWorkerProtocol?
    public var router: NotifyRouterProtocol?
    
    public var isBusy: Bool = false {
        didSet {
            self.presenter?.changedBusyState(self.isBusy)
        }
    }
    
    public var userModel: UserModel?
    public var notifications: [NotificationModel] = [] {
        didSet {
            self.presenter?.updateNotifications(self.notifications)
        }
    }
    public var currentCode: String?
    
    public func back() {
        self.router?.backToView()
    }
    
    public func getNotifications() {
        self.isBusy = true
        DispatchQueue.global(qos: .utility).async {
            do {
                guard let user = AccountService.shared.currentAccount else { self.isBusy = false; return }
                self.notifications = try self.worker?.getNotification(userId: user.Id) ?? []
            }
            catch  let error {
                
            }
            self.isBusy = false
        }
    }
    
    
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        
    }
    
}
