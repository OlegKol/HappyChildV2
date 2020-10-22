//
//  HCTaskListPresenter.swift
//  HappyChild (mobile)
//
//  Created by Anna on 04.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCTaskListViewPresenter: NSObject {
    
    unowned private var view: HCTaskListViewControllerProtocol
    private var model: HCTaskListModel
    private var networkService: HCNetworkServiceProtocol?
    
    init(view: HCTaskListViewControllerProtocol, model: HCTaskListModel) {
        self.view = view
        self.model = model
        self.networkService = HCNetworkService()
    }
    
    private func loadTaskList() {
        let userId = AccountService.shared.currentAccount?.Id ?? "" // UserDefaults.standard.value(forKey: "userId") as! String
        
        networkService?.loadTaskListForUser(userId, completion: { [weak self] (taskList, error) in
            
            self?.view.showActivityIndicator(false)
            
            guard taskList != nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            self?.model.taskList = taskList!.sorted(by: {$0.startHour! < $1.startHour!})
            self?.view.updateUI()
        })
    }
    
    private func uploadTaskList() {
        let userId = AccountService.shared.currentAccount?.Id ?? "" // UserDefaults.standard.value(forKey: "userId") as! String
        
        networkService?.uploadTaskListForUser(userId, tasks:self.model.taskList, completion: { [weak self] (success, error) in
            self?.view.showActivityIndicator(false)
        })
    }
    
    private func nearestTaskStartTime() -> Int {
        var startTime = 9
        
        if (model.taskList.count > 0) {
            for task in model.taskList.sorted(by: { $0.startHour! < $1.startHour!}) {
                let otherTasks: [HCTaskModel] = model.taskList.filter { $0 != task && $0.startHour == task.endHour }
                if (otherTasks.count == 0) {
                    startTime = task.endHour!
                    break
                }
            }
        }
        return startTime
    }

}

extension HCTaskListViewPresenter: HCTaskListViewPresenterProtocol {
    
    var currentTask: HCTaskModel? {
        get { return model.currentTask }
        set { model.currentTask = newValue }
    }
    
    var taskList: [HCTaskModel] {
        get { return model.taskList }
    }
    
    func tasksCount() -> Int {
        return model.taskList.count
    }
    
    func loadTasks() {
        model.taskList.removeAll()
        view.showActivityIndicator(true)
        loadTaskList()
    }
    
    func uploadTasks() {
        view.showActivityIndicator(true)
        uploadTaskList()
    }
    
    
    func creadNewTask() {
        let task = HCTaskModel()
        
        task.startHour = nearestTaskStartTime()
        task.endHour = task.startHour! + 1
        task.type = .sleep
        
        model.taskList.append(task)
        
        view.updateUI()
        view.scrollTableViewToBottom()
    }
    
    func removeTask(by index: Int) {
        guard index < model.taskList.count else {
            return
        }
        
        model.taskList.remove(at: index)
    }
    
    func isTaskStartHourUsed(_ startHour: Int) -> Bool {
        let filterTasks: [HCTaskModel] = model.taskList.filter{ $0.startHour == startHour }
        return (filterTasks.count > 0)
    }
    
    func isCreateNewTaskAllowed() -> Bool {
        return (model.taskList.count < 5)
    }
}
