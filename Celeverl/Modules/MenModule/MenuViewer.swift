//
//  ContainerViewController.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/22/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class MenuViewer: UIViewController, MenuViewerProtocol, SelectedMenuItemDelegate {
    
    //MARK: - MenuViewerProtocol implementation
    public var interactor: MenuInteractorProtocol?
    
    public func changedMenuItem(item: MenuModel) {
        self.selectMenuDelegate?.selectedMenuItemDelegate(item)
        self.selectedMenuItem = item
    }
    
    public func getListMenuItems(_ list: [MenuModel]) {
        self.menuItems = list
        self.updateMenuListView()
    }
    
    //MARK: - Properties
    var menuItems: [MenuModel] = []
    var menuItemsView: [UIView] = []
    
    var selectedMenuItem: MenuModel?
    var selectMenuDelegate: SelectedMenuItemDelegate?
    
    var logOutButton: AppCustomButton = {
        var button = AppCustomButton()
        button.title = "Выйти"
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 18)
        button.titleLabel?.textColor = UIColor.white
        button.backgroundColor = UIColor.clear
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        return button
    }()
    
    override public func loadView() {
        super.loadView()
        self.interactor?.loadDefaultData()
        self.view.backgroundColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //self.configuareLogOutButton()
    }
    
    func configuareLogOutButton(){
        self.view.addSubview(self.logOutButton)
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        logOutButton.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        logOutButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        logOutButton.Action = {(_) in
            self.logOut()
        }
    }
     
    
   func selectedMenuItemDelegate(_ item: BaseModel) {
       if self.selectMenuDelegate != nil, let menuItem = item as? MenuModel {
            if menuItem.typePage == .Exit {
                self.logOut()
            }else {
                self.interactor?.changeMenuItem(item: menuItem)
            }
       }
   }
    
    private func updateMenuListView(){
        DispatchQueue.main.async {
            self.clearMenuViews()
            self.menuItems.forEach(){ self.createItemMenu($0)}
        }
    }
    
    private func createItemMenu(_ menuItem: MenuModel) {
        
        let content = ViewButtomLine()
        content.colorLine = UIColor.init(hex: "#D7DEFF", alpha: 1)
        content.heightLine = 1
        
        self.view.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        content.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        content.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        if self.menuItemsView.count == 0 {
           content.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        }
        else {
           content.topAnchor.constraint(equalTo: self.menuItemsView[self.menuItemsView.count-1].bottomAnchor, constant: 5).isActive = true
        }
        
        self.menuItemsView.append(content)
       
        
        let menuView = AppCustomButton()
        menuView.title = menuItem.Name
        menuView.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 18)
        menuView.titleLabel?.textColor = UIColor.white
        menuView.backgroundColor = UIColor.clear
        menuView.titleLabel?.numberOfLines = 0
        menuView.contentHorizontalAlignment = .left
        menuView.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        
        content.addSubview(menuView)
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.leftAnchor.constraint(equalTo: content.leftAnchor, constant: -20).isActive = true
        menuView.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        menuView.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: 0).isActive = true
        menuView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        menuView.Action = {(_) in
            self.selectedMenuItemDelegate(menuItem)
        }
    }
    
    private func clearMenuViews(){
        self.menuItemsView.forEach(){ $0.removeFromSuperview( )}
        self.menuItemsView.removeAll()
    }
    
    
    @objc private func logOut(){
        self.interactor?.logOut()
    }
}

