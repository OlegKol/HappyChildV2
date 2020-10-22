//
//  HCTaskListViewController + TableView.swift
//  HappyChild (mobile)
//
//  Created by Anna on 05.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

extension HCTaskListViewController: UITableViewDelegate {
    
}

extension HCTaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tasksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HCTaskListTableViewCell.self), for: indexPath) as! HCTaskListTableViewCell
        
        cell.updateUI(with: presenter.taskList[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension HCTaskListViewController: HCTaskListCellDelegate {
    
    func removeTaskButtonDidTouchUpInside(_ cell: HCTaskListTableViewCell) {
        view.endEditing(true)
        
        let index = taskListTableView.indexPath(for: cell)
        
        presenter.removeTask(by: index!.row)
        taskListTableView.deleteRows(at: [index!], with: .fade)
        addTaskView.isActive = presenter.isCreateNewTaskAllowed()
    }
    
    func startTimeButtonDidTouchUpInside(_ cell: HCTaskListTableViewCell) {
        view.endEditing(true)
        
        if let index = taskListTableView.indexPath(for: cell) {
            let task = presenter.taskList[index.row]
            presenter.currentTask = task
            
            showStartTimePicker()
        }
    }
    
    func finishTimeButtonDidTouchUpInside(_ cell: HCTaskListTableViewCell) {
        view.endEditing(true)
        
        if let index = taskListTableView.indexPath(for: cell) {
            let task = presenter.taskList[index.row]
            presenter.currentTask = task
            
            showFinishTimePicker()
        }
    }
    
    func taskButtonDidTouchUpInside(_ cell: HCTaskListTableViewCell) {
        view.endEditing(true)
        
        if let index = taskListTableView.indexPath(for: cell) {
            let task = presenter.taskList[index.row]
            presenter.currentTask = task
            
            showTaskTypePicker()
        }
    }
    
}
