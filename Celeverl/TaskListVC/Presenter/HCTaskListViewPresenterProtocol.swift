//
//  HCTaskListViewPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Anna on 04.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

protocol HCTaskListViewPresenterProtocol {
    var currentTask: HCTaskModel? { get set }
    var taskList: [HCTaskModel] { get }
    
    func loadTasks()
    func uploadTasks()
    func tasksCount() -> Int
    
    func creadNewTask()
    func removeTask(by index: Int)
    
    func isTaskStartHourUsed(_ startHour: Int) -> Bool
    func isCreateNewTaskAllowed() -> Bool
}
