//
//  HCTaskListTableViewCell.swift
//  HappyChild (mobile)
//
//  Created by Anna on 05.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit

protocol HCTaskListCellDelegate: AnyObject {
    func removeTaskButtonDidTouchUpInside(_ cell: HCTaskListTableViewCell)
    func startTimeButtonDidTouchUpInside(_ cell: HCTaskListTableViewCell)
    func finishTimeButtonDidTouchUpInside(_ cell: HCTaskListTableViewCell)
    func taskButtonDidTouchUpInside(_ cell: HCTaskListTableViewCell)
}

class HCTaskListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var deleteTaskButton: UIButton!
    @IBOutlet weak var startTimeValueLabel: UILabel!
    @IBOutlet weak var finishTimeValueLabel: UILabel!
    @IBOutlet weak var taskValueLabel: UILabel!
    @IBOutlet weak var startTimeView: UIView!
    @IBOutlet weak var finishTimeView: UIView!
    @IBOutlet weak var taskView: UIView!
    
    weak var delegate: HCTaskListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
        addTapGesture()
    }
    
    func updateUI(with model: HCTaskModel) {
        deleteTaskButton.alpha = 0
        
        if let startHour = model.startHour {
            startTimeValueLabel.text = String(format: "%02d:00", startHour)
        }
        if let endHour = model.endHour {
            finishTimeValueLabel.text = String(format: "%02d:00", endHour)
        }
        taskValueLabel.text = model.type?.rawValue
    }
    
    private func setupUI() {
        backView.layer.cornerRadius = 10
        
        startTimeLabel.text = String.localize("Время начала:")
        finishTimeLabel.text = String.localize("Время завершения:")
        taskLabel.text = String.localize("Задание:")
        
        setupButtons()
    }
    
    private func setupButtons() {
        deleteTaskButton.alpha = 0
        
        deleteTaskButton.layer.masksToBounds = false
        deleteTaskButton.layer.shadowRadius = 2.0
        deleteTaskButton.layer.shadowOpacity = 0.4
        deleteTaskButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        deleteTaskButton.layer.cornerRadius = 4
        
        startTimeView.layer.cornerRadius = 4
        startTimeView.backgroundColor = UIColor.customLightGray()
        
        finishTimeView.layer.cornerRadius = 4
        finishTimeView.backgroundColor = UIColor.customLightGray()
        
        taskView.layer.cornerRadius = 4
        taskView.backgroundColor = UIColor.customLightGray()
    }
    
    private func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showDeleteButton(_:)))
        tap.cancelsTouchesInView = false
        backView.addGestureRecognizer(tap)
    }
    
    @objc private func showDeleteButton(_ show: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.deleteTaskButton.alpha = show ? 1 : 0
            }
        }
    }
    
    @IBAction func menuButtonDidTouchUpInside(_ sender: Any) {
        showDeleteButton(deleteTaskButton.alpha == 0)
    }
    
    @IBAction func deleteTaskButtonDidTouchUpInside(_ sender: Any) {
        delegate?.removeTaskButtonDidTouchUpInside(self)
    }
    
    @IBAction func taskButtonDidTouchUpInside(_ sender: Any) {
        delegate?.taskButtonDidTouchUpInside(self)
    }
    
    @IBAction func startTimeButtonDidTouchUpInside(_ sender: Any) {
        delegate?.startTimeButtonDidTouchUpInside(self)
    }
    
    @IBAction func finishTimeButtonDidTouchUpInside(_ sender: Any) {
        delegate?.finishTimeButtonDidTouchUpInside(self)
    }
}
