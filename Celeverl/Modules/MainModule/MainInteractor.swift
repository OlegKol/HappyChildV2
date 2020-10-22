//
//  MainInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/28/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class MainInteractor: MainInteractorProtocol {
    
    public var router: MainRouterProtocol?
    public var worker: MainWorkerProtocol?
    public var presenter: MainPresenterProtocol?
    
    public var listCountryCodes: [CountryCodeModel]?
    public var currentCountryCode: CountryCodeModel?
    
    public var userModel: UserModel? = UserModel()
    
    public var isBusy: Bool  = false {
        didSet{
            self.toggleBusy()
        }
    }
    
    public func loadDefaultData() {
        self.isBusy = true
        DispatchQueue.global(qos: .default).async {
            self.listCountryCodes = self.worker?.getListCountryCodes()
            if let list = self.listCountryCodes {
                self.presenter?.updateCountryData(list)
                let result = list.first(where: { $0.Code == 7 })
                self.updateCurrentCode(result)
            }
            if RealmService.shared.hasAccount() {
                self.userModel = RealmService.shared.getAccount()
                do{
                    try AccountService.shared.writeAccount(self.userModel!)
                    NotificationCenter.default.post(name: Notification.Name.didRecieveStartListenLocalNotification, object: nil)
                    self.router?.goToCommonViewer()
                }
                catch _ {
                    
                }
            }
            self.isBusy = false
        }
    }
    
    
    public func getDataSource() -> [String : Any] {
        var dictionary = [String:Any]()
        dictionary[AppConstants.USER_PARAMETER] = self.userModel
        return dictionary
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        
    }
    
    public func sendPhone() {
       
    }
    
    public func sendCode() {
        
    }
    
   public func checkPhone() {
        DispatchQueue.global().async {
            self.isBusy = true
            do {
                let phone = self.userModel?.PhoneNumber ?? ""
                let result = try self.worker?.firstRegistrationUser(mobile: phone)
                guard result == true else { return }
                self.router?.goToCodeViewer()
            }
            catch let error as CustomError {
                switch error {
                case .invalid(let message):
                    self.presenter?.showError(message)
                }
            }
            catch {
                
            }
            self.isBusy = false
        }
   }
   
   public func changePhoneFeild(string: String) {
        self.userModel?.PhoneNumber = String(self.currentCountryCode!.Code) + string
        self.presenter?.hideError()
   }
    
    private func updateCurrentCode(_ country: CountryCodeModel?){
        if let code = country {
            self.currentCountryCode = code
            self.presenter?.setCurrentCountryData(code)
            //self.changeCodeCountry()
        }
    }
    
    public func changeCountry(_ country: CountryCodeModel) {
        self.currentCountryCode = country
    }
    
    public func changeCodeCountry() {
        let code = "+\(self.currentCountryCode!.Code)"
        self.presenter?.changeCodeCountry(code)
    }
    
    private func toggleBusy(){
        self.presenter?.changedBusyState(self.isBusy)
    }
    
    public func openAgreement() {
        self.router?.goToAgreementViewer()
    }
}
