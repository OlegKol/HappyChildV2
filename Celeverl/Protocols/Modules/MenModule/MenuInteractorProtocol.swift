//
//  MenuInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/15/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol MenuInteractorProtocol: BaseDataSourceProtocol {
    
    var presenter: MenuPresenterProtocol? {get set}
    var worker: MenuWorkerProtocol? {get set}
    
    var menutItemsList: [MenuModel] { get set}
    var currentMenuItem: MenuModel? { get set}
    
    func changeMenuItem(item: MenuModel)
    func loadDefaultData()
    
    func logOut()
}
