//
//  ReminderInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class ReminderInteractor: ReminderInteractorProtocol {
   
    public var router: ReminderRouterProtocol?
    public var worker: ReminderWorkerProtocol?
    public var presenter: ReminderPresenterProtocol?
    
    public var userSettings: ReminderModel?
    public var isBusy: Bool = false {
        didSet {
            self.updateStatePage()
        }
    }
    
    public var currentPropertyName: String? = nil
    public var currentDataPropertyName: [Int] = []
    private var queue = DispatchQueue.global(qos: .background)
    
    public func loadData() {
        self.queue.async {
            self.isBusy = true
            do{
                if let user = AccountService.shared.currentAccount {
                    self.userSettings = try self.worker?.getSettingUser(user.Id)
                    self.updateSettings()
                }
            }
            catch let _ {
                
            }
            self.isBusy = false
        }
    }
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        
    }
    
    private func updateStatePage(){
        self.presenter?.updateView(self.isBusy)
    }
    
    public func updateSettings() {
        guard let settings = self.userSettings else { return }
        self.presenter?.updateSettings(settings)
    }
    
    public func getValueToProperty(_ propertyName: String) {
        var strings: [String] = []
        self.currentPropertyName = propertyName
        
        let currentProperty = self.userSettings?.getPropertiesList().first(where: { (i,prop,val) -> Bool in
            return propertyName == prop
        })
        let currentValue = currentProperty?.value as? Int ?? 0
        
        if propertyName == "WarningNotificationMinutes" || propertyName == "HappinessNotificationMinutes" || propertyName == "NormalSituationNotificationMinutes" {
            self.currentDataPropertyName = [10, 30, 60, 90, 120, 150, 180]
            strings = self.currentDataPropertyName.map { "\($0)мин." }
        }
        else if propertyName == "WarningEventsFrequencyForInterval" || propertyName == "HappinessEventsFrequencyForInterval" || propertyName == "NormalEventsFrequencyForInterval" {
            self.currentDataPropertyName = [10, 25, 50, 75, 100]
            strings = self.currentDataPropertyName.map { "\($0)%" }
        }
        let indexCurrentValue = self.currentDataPropertyName.firstIndex(of: currentValue) ?? 0
        self.presenter?.setDataForPicker(strings,indexCurrentValue)
    }
    
    
    public func selectValue(_ value: Any) {
        if let index = value as? Int, self.currentDataPropertyName.count > index {
            let newValue = self.currentDataPropertyName[index]
            self.userSettings?.setValue(newValue, forKey: self.currentPropertyName!)
        }
    }
    
    public func changedBoolValue( _ propName: String, _ value: Any){
        do {
            self.userSettings?.setValue(value, forKey: propName)
        }
        catch _ {
            
        }
    }
    
    public func updateValue() {
        self.isBusy = true
        self.queue.async {
            do {
                if let userId = AccountService.shared.currentAccount?.Id, let newModel = self.userSettings {
                    let data = try self.worker?.updateSettingUser(userId, newModel)
                    if data == true {
                        
                    }
                    else {
                        
                    }
                    
                }
            }
            catch _ {
                
            }
            self.isBusy = false
        }
    }
}
