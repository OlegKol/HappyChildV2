//
//  HelpInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/29/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class HelpInteractor:HelpInteractorProtocol {
    
    
    public var router: HelpRouterProtocol?
    
    public var worker: HelpWorkerProtocol?
    
    public var presenter: HelpPresenterProtocol?
    
    public var IsBusy: Bool = false {
        didSet{
            self.presenter?.updatePageState(self.IsBusy)
        }
    }
    
    public var helpModel: HelpModel? = nil
    
    public func loadData() {
        self.IsBusy = true
        DispatchQueue.global(qos: .background).async {
            do {
                guard let user = AccountService.shared.currentAccount else { self.IsBusy = false; return }
                let result = try self.worker?.loadHelpPage(user.Id)
                if let model = result {
                    self.helpModel = model
                    self.updatePage(model)
                }
            }
            catch let _ {
                
            }
        }
    }
    
    public func updatePage(_ data: HelpModel) {
        self.presenter?.updatePage(data)
    }
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        
    }
    
}
