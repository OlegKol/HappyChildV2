//
//  NotifyViewer.swift
//  Celeverl
//
//  Created by Евгений on 2/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

//MARK: - NotifyViewer
public class NotifyViewer: UIViewController, NotifyViewerProtocol, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - NotifyViewerProtocol implementation
    public var interactor: NotifyInteractorProtocol?
    public var router: NotifyRouterProtocol?
    
    public var notifications: [NotificationModel]  = []
    public var groupingNotifications: [(Date,[NotificationModel])] = []{
        didSet {
            DispatchQueue.main.async {
                self.notificationsCollection.reloadData()
            }
        }
    }
    
    public func updateNotifications(_ notification: [NotificationModel]) {
        self.notifications = notification
        
        DispatchQueue.main.async {
            self.emptyTitleView.isHidden = self.notifications.count > 0
        }
        self.groupNotifications()
    }
    
    private func groupNotifications(){
        
        let formmater = DateFormatter()
        formmater.dateFormat = "MM-dd-yyyy HH:mm"
        let anotherForrmater = DateFormatter()
        anotherForrmater.dateFormat = "MM/dd/yyyy"
        
        self.groupingNotifications = Dictionary(grouping: self.notifications){ (notify) -> Date in
            
            let data = formmater.date(from: notify.usersDateStr!)!
            let str = anotherForrmater.string(from: data)
            let shortData = anotherForrmater.date(from: str)!
            return shortData
        }
        .sorted(){ (prev,next) in prev.key > next.key }
        
    }
    
    public func showError(error: String) {
        
    }
    
    public func hideError() {
        
    }
    
    public func changedBusyState(_ state: Bool) {
        DispatchQueue.main.async {
            state ? self.busyView.startAnimating() : self.busyView.stopAnimating()
        }
    }
    
    
    //MARK: - Properties
    public var backButtonView: UIImageView!
    public var notificationTitleView: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 24)
        label.textColor = .white
        label.text = "Последние сообщения"
        return label
    }()
    public var backPanelView: UIView = {
        var view = UIView()
        view.backgroundColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
        return view
    }()
    public var notificationsCollection: UITableView = {
        var table = UITableView()
        table.separatorStyle = .none
        return table
    }()
    public var scanImageView: UIImageView = {
        var image = UIImageView(image: UIImage(named: "app_scan"))
        return image
    }()
    
    public var busyView: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView()
        view.style = .large
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.85)
        view.color = .white
        return view
    }()
    
    public var emptyTitleView: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 20)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.text = "В данный момент нет нотификаций"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.confgiaureViews()
//       NotificationCenter.default.addObserver(self, selector: #selector(self.updateWhenOpenFrombackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }
    
    
//    @objc func updateWhenOpenFrombackground(){
//        self.interactor?.getNotifications()
//    }

    override public func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        self.busyView.startAnimating()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactor?.getNotifications()
    }
    
    private func confgiaureViews(){
        self.configuareBackButton()
        self.configuareTitleView()
        self.configuateTableView()
        self.configuateEmptyTitleView()
        self.configuareBusyView()
    }
    
    private func configuareBackButton(){
        
        self.view.addSubview(self.backPanelView)
        self.backPanelView.translatesAutoresizingMaskIntoConstraints = false
        self.backPanelView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.backPanelView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.backPanelView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.backPanelView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        self.backButtonView = UIImageView(image: UIImage(named: "arrow_back_white"))
        self.backButtonView.isUserInteractionEnabled = true
        self.backPanelView.addSubview(self.backButtonView)
        
        self.backButtonView.translatesAutoresizingMaskIntoConstraints = false
        self.backButtonView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.backButtonView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.backButtonView.leftAnchor.constraint(equalTo: self.backPanelView.leftAnchor, constant: 20).isActive = true
        self.backButtonView.centerYAnchor.constraint(equalTo: self.backPanelView.centerYAnchor).isActive = true
        
        self.backButtonView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backToPrevious))
        self.backButtonView.addGestureRecognizer(tapGesture)
        
        
        self.backPanelView.addSubview(self.scanImageView)
        self.scanImageView.translatesAutoresizingMaskIntoConstraints = false
        self.scanImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.scanImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
               
        self.scanImageView.rightAnchor.constraint(equalTo: self.backPanelView.rightAnchor, constant: -20).isActive = true
        self.scanImageView.centerYAnchor.constraint(equalTo: self.backPanelView.centerYAnchor).isActive = true
        self.scanImageView.isHidden = true
    }
    
    private func configuareTitleView(){
        self.backPanelView.addSubview(self.notificationTitleView)
        
        self.notificationTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        self.notificationTitleView.centerYAnchor.constraint(equalTo: self.backPanelView.centerYAnchor).isActive = true
        self.notificationTitleView.centerXAnchor.constraint(equalTo: self.backPanelView.centerXAnchor).isActive = true
    }
    
    
    private func configuareBusyView(){
        self.view.addSubview(self.busyView)
        self.busyView.translatesAutoresizingMaskIntoConstraints = false
        self.busyView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.busyView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.busyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.busyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
    private func configuateTableView(){
        self.view.addSubview(self.notificationsCollection)
        
        self.notificationsCollection.register(NotificationViewCell.self, forCellReuseIdentifier: NotificationViewCell.resueseId)
        self.notificationsCollection.translatesAutoresizingMaskIntoConstraints = false
        self.notificationsCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.notificationsCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.notificationsCollection.topAnchor.constraint(equalTo: self.backPanelView.bottomAnchor, constant: 0).isActive = true
        self.notificationsCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.notificationsCollection.delegate = self
        self.notificationsCollection.dataSource = self
        self.notificationsCollection.backgroundColor = .clear
    }
    
    private func configuateEmptyTitleView(){
        self.view.addSubview(self.emptyTitleView)
        self.emptyTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.emptyTitleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.emptyTitleView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.emptyTitleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    @objc private func backToPrevious(){
        self.interactor?.back()
    }
    
    
    //MARK: - Table functions
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( section < self.groupingNotifications.count){
            return self.groupingNotifications[section].1.count
        }
        else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationViewCell.resueseId, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if let model = cell as? NotificationViewCell {
            model.BindingContext = self.groupingNotifications[indexPath.section].1[indexPath.item]
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = AppPaddingLabel(withInsets: 5, 5, 20, 20)
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        label.textAlignment = .center
        label.backgroundColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
        label.textColor = UIColor.init(hex: "#D7DEFF", alpha: 1)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        
        let containerView = UIView()
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        
       
        if let notify = self.groupingNotifications[section].1.first {
            label.text = notify.creationTimeUsers

            let formmater = DateFormatter()
            formmater.dateFormat = "MM-dd-yyyy HH:mm"
            let anotherForrmater = DateFormatter()
            anotherForrmater.dateFormat = "dd.MM.yyyy"
            let data = formmater.date(from: notify.usersDateStr!)!
            let str = anotherForrmater.string(from: data)
            label.text = str
        }
        return containerView
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupingNotifications.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
