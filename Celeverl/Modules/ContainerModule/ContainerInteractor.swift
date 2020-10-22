//
//  ContainerInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/9/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

//MARK: - ContainerInteractor
public class ContainerInteractor: ContainerInteractorProtocol {
    
    
    //MARK: - ContainerInteractorProtocol implementation
    
    public var router: ContainerRouterProtocol?
    public var presenter: ContainerPresenterProtocol?
    public var worker: ContainerWorkerProtocol?
    
    public var userModel: UserModel?
    public var currentMenuItem: MenuModel?
    
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
    
    public func loadDefaultData() {
        do{
            if self.userModel != nil {
                let result = try self.worker?.loadUserSttings(user: self.userModel!)
                self.userModel = result
            }
        }
        catch let error {
            print("Some error in ContainerViewer \(error.localizedDescription)")
        }
    }
    
    public func goToNotificationPage() {
        self.router?.goToNotificationPage()
    }
}
