//
//  ReminderPresenter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public class ReminderPresenter: ReminderPresenterProtocol {
    
    public var viewer: ReminderViewerProtocol?
    
    public func updateView(_ state: Bool) {
        self.viewer?.updateView(state)
    }
    
    public func updateSettings(_ settings: ReminderModel) {
        self.viewer?.updateSettings(settings)
    }
    
    public func setDataForPicker(_ data: [String], _ index: Int) {
        self.viewer?.setDataForPicker(data,index)
    }
    
}
