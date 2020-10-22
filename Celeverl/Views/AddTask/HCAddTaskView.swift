//
//  HCAddTaskView.swift
//  HappyChild (mobile)
//
//  Created by Anna on 04.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

class HCAddTaskView: UIView {

    @IBOutlet private weak var addTaskButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    weak var delegate: HCAddTaskViewDelegate?
    
    var isActive: Bool {
        set {
            self.alpha = newValue ? 1 : 0.5
            self.addTaskButton.isEnabled = newValue
        }
        get {
            return addTaskButton.isEnabled
        }
    }
   
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupUI()
    }
    
    //MARK: - Private
    
    private func setupUI() {
        addTaskButton.layer.borderColor = UIColor.customLightGray().cgColor
        addTaskButton.layer.borderWidth = 2
        addTaskButton.layer.cornerRadius = 10
        addTaskButton.isEnabled = true
        
        titleLabel.text = String.localize("Создать задачу")
    }
    
    @IBAction private func addTaskButtonDidTouchUpInside(_ sender: Any) {
        delegate?.addTaskButtonDidTouchUpInside()
    }

}
