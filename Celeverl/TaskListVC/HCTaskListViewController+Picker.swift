//
//  HCTaskListViewController + TableView.swift
//  HappyChild (mobile)
//
//  Created by Anna on 05.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

private let kPickerViewHeight: CGFloat = 240.0

extension HCTaskListViewController {
    
    func showPicker(_ pickerView: UIPickerView) {
        let customView:UIView = UIView (frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        customView.backgroundColor = UIColor.white
        customView.addSubview(pickerView)
        
        editTextField.inputView = customView
        editTextField.becomeFirstResponder()
    }
    
    func showTaskTypePicker() {
        let taskTypePicker = HCTaskTypePickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        
        if let task = presenter.currentTask {
            taskTypePicker.currentTaskType = task.type!
        }
        
        taskTypePicker.onTaskTypeSelected = { (type: HCTaskType) in
            if let currentTask = self.presenter.currentTask {
                currentTask.type = type
                self.updateUI()
            }
        }
        showPicker(taskTypePicker)
    }
    
    func showStartTimePicker() {
        let taskTimePicker = HCTaskTimePickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        
        var taskTimes = Array(0...23)
        
        if let task = presenter.currentTask {
            let otherTasks: [HCTaskModel] = presenter.taskList.filter { $0 != task }
            for otherTask in otherTasks {
                taskTimes.removeAll(where: {$0 == otherTask.startHour!})
                if (otherTask.taskDuration > 1) {
                    taskTimes.removeAll(where: {$0 == (otherTask.startHour! + 1)})
                }
            }
            
            taskTimePicker.taskTimes = taskTimes
            taskTimePicker.currentTaskTime = task.startHour!
        }
        
        taskTimePicker.onTaskTimeSelected = { (time: Int) in
            if let currentTask = self.presenter.currentTask {
                currentTask.startHour = time
                currentTask.endHour = (time + 1)
                self.updateUI()
            }
        }
        showPicker(taskTimePicker)
    }
    
    func showFinishTimePicker() {
        let taskTimePicker = HCTaskTimePickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        
        if let startHour = presenter.currentTask?.startHour,
            let endHour = presenter.currentTask?.endHour {
            var taskTimes = [Int]()
            taskTimes.append(startHour + 1)
            if (startHour < 23 && !presenter.isTaskStartHourUsed(startHour + 1)) {
                taskTimes.append(startHour + 2)
            }
            
            taskTimePicker.taskTimes = taskTimes
            taskTimePicker.currentTaskTime = endHour
        }
        
        taskTimePicker.onTaskTimeSelected = { (time: Int) in
            if let currentTask = self.presenter.currentTask {
                currentTask.endHour = time
                self.updateUI()
            }
        }
        showPicker(taskTimePicker)
    }
}
