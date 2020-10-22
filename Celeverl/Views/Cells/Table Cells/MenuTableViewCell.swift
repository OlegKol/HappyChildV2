//
//  CameraViewCell.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class MenuTableViewCell: BaseUITableViewCell {
    
    static let resueseId: String = "MenuTableViewCell"
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MenuTableViewCell.self.resueseId)
        self.backgroundColor = .clear
        self.ListInvokes.append(self.propertyChanged)
    }
    
    private var titleName: UILabel!
    public var imageTitle: UIImageView!
    
    
    private func propertyChanged(_ propertyName: String) {
        if(propertyName == "BindingContext"){
            updateViewCell()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createTitleView(){
        if let settingModel = self.BindingContext as? MenuModel{
            if(self.titleName == nil){
                
                var spaceView =  UIView()
                self.addSubview(spaceView)
                spaceView.translatesAutoresizingMaskIntoConstraints = false
                spaceView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                spaceView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                spaceView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                spaceView.heightAnchor.constraint(equalToConstant: 30).isActive = true
                
                self.titleName = UILabel()
                self.titleName.lineBreakMode = .byWordWrapping
                self.titleName.numberOfLines = 3
                self.addSubview(self.titleName)
                
                self.titleName.textColor = .white
                self.titleName.contentScaleFactor = UIScreen.main.scale
                self.titleName.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 22)
                self.titleName.translatesAutoresizingMaskIntoConstraints = false
                
                self.titleName.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                self.titleName.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
                self.titleName.bottomAnchor.constraint(equalTo: spaceView.topAnchor).isActive = true
                self.titleName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20).isActive = true
            }
            self.titleName.text = settingModel.Name
            
        }
    }
    
    func createImageView(){
       if let settingModel = self.BindingContext as? MenuModel{
            if(self.imageTitle == nil){
                let image = UIImage(named: settingModel.Image)
                self.imageTitle = UIImageView(image: image)
                self.imageTitle.contentMode = .scaleAspectFit
                self.addSubview(self.imageTitle)
                                
                self.imageTitle.contentScaleFactor = UIScreen.main.scale
                self.imageTitle.translatesAutoresizingMaskIntoConstraints = false
                
                self.imageTitle.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                self.imageTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 160).isActive = true
                self.imageTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                self.imageTitle.widthAnchor.constraint(equalToConstant: 40).isActive = true
            }
        }
    }
    
    public func updateViewCell(){
        self.createTitleView()
        self.createImageView()
    }
}
