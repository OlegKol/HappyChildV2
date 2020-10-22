//
//  BalanceInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class BalanceInteractor: BalanceInteractorProtocol {
   
    public var router: BalanceRouterProtocol?
    public var worker: BalanceWorkerProtocol?
    public var presenter: BalancePresenterProtocol?
    
    public var balanceData: BalanceModel?
    public var IsBusy: Bool = false {
        didSet {
            self.presenter?.changedStatePage(self.IsBusy)
        }
    }
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }

    public func setCustomData(source: BaseDataSourceProtocol) {
       
    }
    
    public func loadBalanceData() {
        self.IsBusy = true
        DispatchQueue.global(qos: .background).async {
            do{
                if let userId = AccountService.shared.currentAccount?.Id {
                    self.balanceData = try self.worker?.loadBalanceData(userId)
                    self.presenter?.updateView(self.balanceData!)
                }
            }
            catch let _ {
                
            }
            self.IsBusy = false
        }
    }
    
}
