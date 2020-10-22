//
//  HCTaskTypePickerView.swift
//  HappyChild (mobile)
//
//  Created by Andrew on 12/8/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCTaskTypePickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currentTaskType: HCTaskType = .play {
        willSet {
            selectTaskType(newValue)
        }
    }

    private var taskTypes :[HCTaskType] = []
    
    var onTaskTypeSelected: ((_ type: HCTaskType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        taskTypes = HCTaskType.allCases
        
        currentTaskType = taskTypes[0]
        
        self.delegate = self
        self.dataSource = self
        
        selectTaskType(currentTaskType)
    }
    
    func selectTaskType(_ type: HCTaskType) {
        let index = taskTypes.firstIndex(of: type)!
        self.selectRow(index, inComponent: 0, animated: false)
    }
    
    //MARK: - UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return taskTypes[row].rawValue
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return taskTypes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let taskType = taskTypes[self.selectedRow(inComponent: 0)]
        
        if let block = onTaskTypeSelected {
            block(taskType)
        }
        self.currentTaskType = taskType
    }
}

