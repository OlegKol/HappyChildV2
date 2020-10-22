//
//  MainWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/27/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol MainWorkerProtocol: class {
    
    func checkCorrectMobilePhone(mobile: String) -> Bool
    
    func firstRegistrationUser(mobile: String) throws -> Bool
    
    func getListCountryCodes() -> [CountryCodeModel]
}
