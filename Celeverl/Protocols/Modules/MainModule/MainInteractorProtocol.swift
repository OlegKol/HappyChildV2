//
//  MainIteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/27/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol MainInteractorProtocol: BaseDataSourceProtocol {
    
    var worker: MainWorkerProtocol? {get set}
    var presenter: MainPresenterProtocol? {get set}
    var router: MainRouterProtocol? { get set}
    
    var listCountryCodes: [CountryCodeModel]? {get set}
    var currentCountryCode: CountryCodeModel? {get set}
    var isBusy: Bool {get set}
    var userModel: UserModel? { get set}
    
    func sendCode()
    func checkPhone()
    func changePhoneFeild(string: String)
    func loadDefaultData()
    func changeCodeCountry()
    func changeCountry(_ country: CountryCodeModel)
    func openAgreement()
    
}
