//
//  HCTaskModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 05.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

enum HCTaskType: String, CaseIterable {
    case sleep = "Уложить спать"
    case goForWalk = "Сходить на прогулку"
    case read = "Почитать ребенку"
    case play = "Поиграть дома"
}

public class HCTaskModel: NSObject {
    var taskId: Int?
    var startHour: Int?
    var endHour: Int?
    var type: HCTaskType?
    
    var taskDuration: Int {
        var duration = 0
        if let start = self.startHour, let end = self.endHour {
            duration = end - start
        }
        return duration
    }
}
