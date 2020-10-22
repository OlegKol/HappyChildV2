//
//  HCNetworkService + TaskList.swift
//  HappyChild (mobile)
//
//  Created by Anna on 05.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

extension HCNetworkService {
    
    func loadTaskListForUser(_ userId: String, completion: @escaping HCNetworkTaskListHandler) {
        let model = HCNetworkTaskListLoadModel()
        model.userId = userId
        
        performRequest(model: model, success: { (response) in
            var taskList = [HCTaskModel]()
            
            if let taskArray = response["TasksForNanny"] as? Array<Any> {
                for task in taskArray {
                    let model = HCTaskModel()
                    model.taskId = (task as! Dictionary<String, Any>)["Id"] as? Int
                    model.startHour = (task as! Dictionary<String, Any>)["StartHour"] as? Int
                    model.endHour = (task as! Dictionary<String, Any>)["EndHour"] as? Int
                    model.type = HCTaskType.allCases[(task as! Dictionary<String, Any>)["TaskType"] as! Int]
                    
                    taskList.append(model)
                }
            }
            completion(taskList, nil)
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func uploadTaskListForUser(_ userId: String, tasks: [HCTaskModel]?, completion: @escaping HCNetworkUploadTaskListHandler) {
        
        let requestModel = HCNetworkTaskListUploadModel()
        requestModel.userId = userId
        requestModel.tasks = tasks
        
        performRequest(model: requestModel, success: { (response) in
            
            let successResult = response["success"]
            
            guard successResult != nil, (successResult as? Bool) == true else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(false, e)
                return
            }
            completion(true, nil)
            
        }) { (error) in
            guard let _ = error else {
                let e = HCCustomError(message: "Error occured while processing your request")
                completion(false, e)
                return
            }
            completion(false, error)
        }
    }
}
