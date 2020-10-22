//
//  ReminderInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol ReminderInteractorProtocol: BaseDataSourceProtocol {
    
    var worker: ReminderWorkerProtocol? { get set}
    var presenter: ReminderPresenterProtocol? { get set}
    var router: ReminderRouterProtocol? { get set}
    
    var userSettings: ReminderModel? { get set}
    var isBusy:Bool { get set}
    
    func loadData()
    func updateSettings()
    
    func getValueToProperty(_ propertyName: String)
    func selectValue(_ value: Any)
    func changedBoolValue( _ propName: String, _ value: Any)
    
    func updateValue()
}
