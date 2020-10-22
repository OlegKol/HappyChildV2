//
//  MainViewerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/27/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol MainViewerProtocol: class {
    
    var interactor: MainInteractorProtocol? { get set }
    var router: MainRouterProtocol? { get set }
    
    func showError(error: String)
    
    func hideError()
    
    func changePhoneField(mobile: String)
    
    func changeCodeCountry(_ code: String)
    
    func changedBusyState(_ state: Bool)
    
    func updateCountryData(_ data: [CountryCodeModel])
    
    func setCurrentCountryData(_ country: CountryCodeModel)
}
