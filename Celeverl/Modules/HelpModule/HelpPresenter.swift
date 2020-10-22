//
//  HelpPresenter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/29/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class HelpPresenter: HelpPresenterProtocol {
    
    public var viewer: HelpViewerProtocol?
    
    public func updatePage(_ data: HelpModel) {
        self.viewer?.updatePage(data)
    }
    
    public func updatePageState(_ state: Bool) {
        self.viewer?.updatePageState(state)
    }
    
}
