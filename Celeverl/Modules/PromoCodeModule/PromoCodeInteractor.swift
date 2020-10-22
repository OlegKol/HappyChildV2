//
//  SettingsInteractor.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class PromoCodeInteractor: PromoCodeInteractorProtocol {
    
    public var presenter: PromoCodePresenterProtocol?
    public var worker: PromoCodeWorkerProtocol?
    public var router: PromoCodeRouterProtocol?
    
    public var isBusy: Bool = false {
        didSet {
            self.presenter?.changedBusyState(self.isBusy)
        }
    }
    
    public var Code: String = ""
    
    public func back() {
        self.router?.backToView()
    }
    
    public func changeCode(_ code: String) {
        self.Code = code
    }
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        
    }
    
    public func checkCode() {
        self.isBusy = true
        DispatchQueue.global().async {
            do {
                if let account = AccountService.shared.currentAccount {
                    guard let result = try self.worker?.checkCode(account.Id, self.Code) else { self.isBusy = false; return}
                    result.succses ? self.presenter?.showMessage(result.message) : self.presenter?.showError(result.message)
                    
                }
            }
            catch _ {
                
            }
            self.isBusy = false
        }
        
    }
   
}
