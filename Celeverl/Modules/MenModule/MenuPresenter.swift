//
//  MenuPresenter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/15/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public class MenuPresenter:MenuPresenterProtocol {
    
    public var viewer: MenuViewerProtocol?
    
    public func changedMenuItem(item: MenuModel) {
        self.viewer?.changedMenuItem(item: item)
    }
    
    public func getListMenuItems(_ list: [MenuModel]) {
        self.viewer?.getListMenuItems(list)
    }
}
