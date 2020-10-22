//
//  MainPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/27/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol MainPresenterProtocol: class {
    
    var viewer: MainViewerProtocol? { get set }
    
    func changeCodeCountry(_ code: String)
    
    func changedBusyState(_ state: Bool)
    
    func showError(_ error: String)
    
    func hideError()
    
    func updateCountryData(_ data: [CountryCodeModel])
    
    func setCurrentCountryData(_ country: CountryCodeModel)
}
