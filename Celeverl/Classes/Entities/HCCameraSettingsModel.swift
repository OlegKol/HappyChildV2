//
//  HCCameraSettingsModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 15.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

enum HCCameraMode: String, CaseIterable {
    case interval = "На выбранный интервал"
    case certainDays = "Определенные дни недели"
    case workDays = "Pабочие дни"
    case weekend = "Bыходные дни"
    case everyDay = "Kаждый день"
}

enum HCDays: String, CaseIterable {
    case sunday = "Воскресенье"
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
}

class HCCameraSettingsModel: NSObject {

    var isActive: Bool?
    var isForWholeDay: Bool?
    
    var endDate: Date?
    var startDate: Date?
    
    var startHour: Int?
    var endHour: Int?
    
    var selectedDays: [Int]?
    
    var type: HCCameraMode?
}
