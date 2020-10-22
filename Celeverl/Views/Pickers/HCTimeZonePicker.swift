//
//  HCTimeZonePicker.swift
//  HappyChild (mobile)
//
//  Created by Anna on 15.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCTimeZonePicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var currentTimeZone: Int = 0 {
        willSet {
            selectTimeZone(newValue)
        }
    }

    var timeZones: [Int] = []
    
    var onTimeZoneSelected: ((_ zone: Int) -> Void)?
    
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
    
    func selectTimeZone(_ zone: Int) {
        if let index = timeZones.firstIndex(of: zone) {
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
            return "\(timeZones[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return timeZones.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let timeZone = timeZones[self.selectedRow(inComponent: 0)]
        
        if let block = onTimeZoneSelected {
            block(timeZone)
        }
        self.currentTimeZone = timeZone
    }
}
