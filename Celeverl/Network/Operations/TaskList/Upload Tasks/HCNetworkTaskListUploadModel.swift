//
//  HCNetworkTaskListUploadModel.swift
//  HappyChild (mobile)
//
//  Created by Anna on 05.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

class HCNetworkTaskListUploadModel {
    var userId = ""
    var tasks: [HCTaskModel]?
}

extension HCNetworkTaskListUploadModel: HCNetworkBaseRequestModel {
    
    var requestParameters: [String : Any] {
        var params = [String : Any]()
        params["userId"] = userId
        
        var tasksParams = [[String: Any]]()
        
        if let tasks = self.tasks, tasks.count > 0 {
            for task in tasks {
                var taskParams = [String: Any]()
                taskParams["StartHour"] = task.startHour
                taskParams["EndHour"] = task.endHour
                taskParams["TaskType"] = HCTaskType.allCases.firstIndex(of: task.type!)
                tasksParams.append(taskParams)
            }
            params["tasks"] = tasksParams
        }
        
        return params
    }
    
    var requestPath: String {
        return kNetworkUploadTaskList
    }
    
    var requestMethod: HCHttpMethod {
        return .POST
    }
    
    var shouldSendParametrsInBody: Bool {
        return true
    }

}
