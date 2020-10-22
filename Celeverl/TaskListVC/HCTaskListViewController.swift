//
//  HCTaskListViewController.swift
//  HappyChild (mobile)
//
//  Created by Anna on 04.12.2019.
//  Copyright © 2019 oberon. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

class HCTaskListViewController: UIViewController {
    
    @IBOutlet weak var topBarView: AppSecondBarPanel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var addTaskView: HCAddTaskView!
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: MDCActivityIndicator!
    @IBOutlet weak var saveButton: UIButton!
    
    var presenter: HCTaskListViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPresenter()
        setupUI()
//        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.loadTasks()
        addTaskView.isActive = presenter.isCreateNewTaskAllowed()
    }
    

    //MARK: - Setup
    private func setupPresenter() {
        let model = HCTaskListModel()
        let presenter = HCTaskListViewPresenter(view: self, model: model)
        
        self.presenter = presenter
    }
    
    private func setupUI() {
        titleLabel.text = String.localize("Задачи для няни")
        
        addTaskView.delegate = self
        
        activityIndicator.cycleColors = [UIColor.activityIndicatorColor()]
        
        saveButton.layer.masksToBounds = false
        saveButton.layer.shadowRadius = 2.0
        saveButton.layer.shadowOpacity = 0.4
        saveButton.layer.shadowOffset = CGSize(width: 1, height: 2)
        saveButton.layer.cornerRadius = 4
        saveButton.setTitle(String.localize("Сохранить"), for: .normal)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        taskListTableView.addGestureRecognizer(gesture)
        
    }
    
    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        presenter.uploadTasks()
    }
    
    
    @objc func hideKeyboard(_ gestire: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

//MARK: - HCTaskListViewControllerProtocol

extension HCTaskListViewController: HCTaskListViewControllerProtocol {
    
    func updateUI() {
        DispatchQueue.main.async {
            self.taskListTableView.reloadData()
            self.addTaskView.isActive = self.presenter.isCreateNewTaskAllowed()
        }
    }
    
    func showActivityIndicator(_ show: Bool) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = !show
            self.activityIndicator.startAnimating()
        }
    }
    
    func scrollTableViewToBottom() {
        taskListTableView.scrollToBottom()
    }
    
}

extension HCTaskListViewController: HCAddTaskViewDelegate {
    func addTaskButtonDidTouchUpInside() {
        view.endEditing(true)
        
        presenter.creadNewTask()
        addTaskView.isActive = presenter.isCreateNewTaskAllowed()
    }
}
