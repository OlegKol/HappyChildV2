//
//  ReminderPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol ReminderPresenterProtocol: class {
    
    var viewer: ReminderViewerProtocol? { get set}
    
    func updateView(_ state: Bool)
    
    func updateSettings(_ settings: ReminderModel)
    
    func setDataForPicker(_ data: [String], _ index: Int)
}
