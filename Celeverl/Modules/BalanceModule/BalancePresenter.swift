//
//  BalancePresenter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class BalancePresenter: BalancePresenterProtocol {
    
    
    public var viewer: BalanceViewerProtocol?
    
    public func changedStatePage(_ state: Bool) {
        self.viewer?.changedStatePage(state)
    }
    
    public func updateView(_ data: BalanceModel) {
        self.viewer?.updateView(data)
    }
}
