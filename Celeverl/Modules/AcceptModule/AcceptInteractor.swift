//
//  AcceptInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class AcceptInteractor: AcceptInteractorProtocol {
    
    public var userModel: UserModel?
    public var router: AcceptRouterProtocol?
    public var worker: AcceptWorkerProtocol?
    public var presenter: AcceptPresenterProtocol?
    
    public var currentCode: String? = ""
    public var isBusy: Bool = false {
        didSet{
            self.toggleBusy()
        }
    }
    
    public func checkCode() {
        DispatchQueue.global().async {
            do{
                self.isBusy = true
                let phone = self.userModel?.PhoneNumber as! String
                let data = try self.worker?.confirmUser(phone: phone, code:self.currentCode!)
                guard let user = data else {
                    self.isBusy = false
                    return
                }
                self.userModel?.Id = user.Id
                try AccountService.shared.writeAccount(self.userModel!)
                RealmService.shared.deleteAllUsers()
                _ = RealmService.shared.writeUser(UserRM.contertToUserRM(self.userModel!))
                NotificationCenter.default.post(name: Notification.Name.didRecieveStartListenLocalNotification, object: nil)
                self.router?.goToCommonView()
            }
            catch let error {
                self.presenter?.showError(error: error.localizedDescription)
            }
            self.isBusy = false
        }
    }
    
    public func changeCodeField(code: String) {
        self.currentCode = code
        self.presenter?.hideError()
    }
    
    public func getDataSource() -> [String : Any] {
        var parameters =  [String: Any]()
        parameters[AppConstants.USER_PARAMETER] = self.userModel
        return parameters
    }
       
    public func setCustomData(source: BaseDataSourceProtocol) {
        let data = source.getDataSource()
        if data[AppConstants.USER_PARAMETER] != nil {
            self.userModel = data[AppConstants.USER_PARAMETER] as? UserModel
        }
    }
    
    public func back(){
        self.router?.backToView()
    }
    
    private func toggleBusy(){
        DispatchQueue.main.async{
            self.presenter?.changedBusyState(self.isBusy)
        }
    }
}
