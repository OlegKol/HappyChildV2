//
//  SettingsInteractor.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class SettingsInteractor: SettingsInteractorProtocol {
   
    public var presenter: SettingsPresenterProtocol?
    public var worker: SettingsWorkerProtocol?
    public var router: SettingsRouterProtocol?
    
    public var isBusy: Bool = false{
        didSet {
            self.presenter?.changedBusyState(self.isBusy)
        }
    }
    
    public var cameraTypesWork: [CameraTypeWork] = [
        CameraTypeWork(title: "На выбранный интервал", Id: 1),
        //CameraTypeWork(title: "Определенные дни недели", Id: 2),
        CameraTypeWork(title: "Выходные дни", Id: 4),
        CameraTypeWork(title: "Рабочие дни", Id: 3),
        CameraTypeWork(title: "Каждый день", Id: 5)
    ]
    
    public var arrayDays: [DayModel] = [
        DayModel(Id: 1, title: "Понедельник", IsSelected: false),
        DayModel(Id: 2, title: "Вторник", IsSelected: false),
        DayModel(Id: 3, title: "Среда", IsSelected: false),
        DayModel(Id: 4, title: "Четверг", IsSelected: false),
        DayModel(Id: 5, title: "Пятница", IsSelected: false),
        DayModel(Id: 6, title: "Суббота", IsSelected: false),
        DayModel(Id: 0, title: "Воскресенье", IsSelected: false),
    ]
    
    public var accountSettings: SettingsModel?
    
    public func back() {
        
    }
    
    public func getNotifications() {
        
    }
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        
    }
    
    public func loadAccountSettings(){
        self.updateSettingsData()
    }
    
    public func updateTimeZone(timeZone: Int){
        self.isBusy = true
        DispatchQueue.global(qos: .background).sync {
           do {
            if let user = AccountService.shared.currentAccount {
                let time = timeZone > 0 ? "+\(timeZone)" : "\(timeZone)"
                _ = try self.worker?.updateTimeZone(userId: user.Id, timezone: time)
                //self.updateSettingsData()
            }
           } catch  {
               
           }
        }
    }
    
    
    private func updateSettingsData(){
        self.isBusy = true
        do {
        if let user = AccountService.shared.currentAccount {
            self.accountSettings = try self.worker?.loadAccountSettings(userId: user.Id)
            self.presenter?.updateView(account: self.accountSettings)
        }
        } catch  {

        }
        self.isBusy = false
    }
    
    public func updateCameraStatus(status: Bool) {
        self.isBusy = true
        do {
            if let user = AccountService.shared.currentAccount {
                _ = try self.worker?.updateCameraStatus(userId: user.Id, status: status)
               // self.updateSettingsData()
            }
        } catch {
          
        }
        self.isBusy = false
    }
    
    public func updatePipeSettings(settings: SettingsModel){
        self.isBusy = true
        do {
            if let user = AccountService.shared.currentAccount {
                _ = try self.worker?.updateSetings(userId: user.Id, settings: settings)
                self.updateSettingsData()
            }
        } catch  {
          
        }
        self.isBusy = false
    }
    
    public func updateDays(settings: SettingsModel) {
        self.isBusy = true
        let result = self.arrayDays.filter { $0.IsSelected }.map{String($0.Id)}.joined(separator:",")
        settings.CameraConnections.first?.SelectedDays = result
        do {
          if let user = AccountService.shared.currentAccount {
              _ = try self.worker?.updateSetings(userId: user.Id, settings: settings)
              self.updateSettingsData()
          }
        } catch  {

        }
        self.isBusy = false
    }
}
