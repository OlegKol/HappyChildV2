//
//  MenuInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/15/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class MenuInteractor: MenuInteractorProtocol {
    
    public var worker: MenuWorkerProtocol?
    public var presenter: MenuPresenterProtocol?
    public var menutItemsList: [MenuModel] = []
    
    public var currentMenuItem: MenuModel? {
        didSet{
            self.presenter?.changedMenuItem(item: self.currentMenuItem!)
        }
    }
    
    public func changeMenuItem(item: MenuModel) {
        self.currentMenuItem = item
    }
    
    public func loadDefaultData() {
        self.menutItemsList = self.worker?.getMenuItemsList() ?? []
        self.currentMenuItem = self.menutItemsList[0]
        self.presenter?.getListMenuItems(self.menutItemsList)
    }
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
     public func setCustomData(source: BaseDataSourceProtocol) {
           
     }
    
    public func logOut() {
        AccountService.shared.LogOut()
        if let window = UIApplication.shared.keyWindow {
            let mainController = MainViewer()
            MainBuilder.createBudiler(viewer: mainController)
            window.rootViewController = mainController
            window.makeKeyAndVisible()
        }
    }
}
