//
//  HCTaskTypePickerView.swift
//  HappyChild (mobile)
//
//  Created by Andrew on 12/8/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class CommonPickerDialogView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public var currentElement: ElementToPickerDialog? {
        willSet {
            if newValue != nil {
                selectElement(newValue!)
            }
        }
    }

    private var pickerElements :[ElementToPickerDialog] = []
    
    var onSelected: ((_ type: ElementToPickerDialog) -> Void)?
    
    init(frame: CGRect, arrays: [ElementToPickerDialog]) {
        super.init(frame: frame)
        self.commonSetup(arrays)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonSetup(_ arrays: [ElementToPickerDialog]) {
        pickerElements = arrays
        
        if pickerElements.count > 1{
            currentElement = pickerElements[0]
        }
        
        self.delegate = self
        self.dataSource = self
        
        if let element = currentElement {
            selectElement(element)
        }
    }
    
    func selectElement(_ type: ElementToPickerDialog) {
        let index = pickerElements.firstIndex { element in
            return type.PickerDialogElement() == element.PickerDialogElement()
        }
        self.selectRow(index!, inComponent: 0, animated: false)
    }
    
    //MARK: - UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return pickerElements[row].PickerDialogElement()
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return pickerElements.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let element = pickerElements[row]
        
        if let block = onSelected {
            block(element)
        }
        self.currentElement = element
    }
    
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let topLine = UIView()
        topLine.backgroundColor = UIColor.gray
        
        self.addSubview(topLine)
        topLine.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 2)
    }
    
    public func SetPickerElements(_ arrays: [ElementToPickerDialog]){
        self.pickerElements = arrays
        self.currentElement = nil
        self.reloadAllComponents()
    }
}

