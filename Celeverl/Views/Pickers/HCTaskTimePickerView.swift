//
//  HCTaskTypePickerView.swift
//  HappyChild (mobile)
//
//  Created by Andrew on 12/8/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCTaskTimePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currentTaskTime: Int = 0 {
        willSet {
            selectTaskTime(newValue)
        }
    }

    var taskTimes :[Int] = []
    
    var onTaskTimeSelected: ((_ time: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.delegate = self
        self.dataSource = self
    }
    
    func selectTaskTime(_ time: Int) {
        if let index = taskTimes.firstIndex(of: time) {
            self.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    //MARK: - UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            let time = taskTimes[row]
            return String(format: "%02d:00", time)
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return taskTimes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let taskTime = taskTimes[self.selectedRow(inComponent: 0)]
        
        if let block = onTaskTimeSelected {
            block(taskTime)
        }
        self.currentTaskTime = taskTime
    }
}

