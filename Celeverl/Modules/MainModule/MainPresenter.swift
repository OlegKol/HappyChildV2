//
//  MainPresenter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/28/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class MainPresenter: MainPresenterProtocol {
    
    public var viewer: MainViewerProtocol?
    
    public func changeCodeCountry(_ code: String) {
        self.viewer?.changeCodeCountry(code)
    }
    
    public func changedBusyState(_ state: Bool){
        self.viewer?.changedBusyState(state)
    }
    
    public func showError(_ error: String) {
        self.viewer?.showError(error: error)
    }
    
    public func hideError() {
        self.viewer?.hideError()
    }
    
    public func updateCountryData(_ data: [CountryCodeModel]) {
        self.viewer?.updateCountryData(data)
    }
    
    public func setCurrentCountryData(_ country: CountryCodeModel) {
        self.viewer?.setCurrentCountryData(country)
    }
    
}
