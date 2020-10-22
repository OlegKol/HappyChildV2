//
//  AppErrorView.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit
public class AppErrorView: UIView {
    
    var statusLabel: UILabel!
    public var denyTextColor: UIColor = .white
    public var successTextColor: UIColor = .white
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.createTitleError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createTitleError(){
        if(self.statusLabel == nil){
            self.statusLabel = UILabel()
            self.addSubview(statusLabel)
            statusLabel.translatesAutoresizingMaskIntoConstraints = false
            statusLabel.textAlignment = .center
            statusLabel.contentScaleFactor = UIScreen.main.scale
            statusLabel.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 15)
        }
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        statusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        statusLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        statusLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
    }
    
    func showAceptStatus(){
        statusLabel.text = "LIVE"
        statusLabel.textColor = self.successTextColor
        statusLabel.backgroundColor = UIColor.init(red: 254/255, green: 0, blue: 18/255, alpha: 1)
        statusLabel.layer.cornerRadius = 5
        statusLabel.layer.masksToBounds = true
    }
    
    func showDenyStatus(){
        statusLabel.text =  "Offline"
        statusLabel.textColor = self.denyTextColor
    }
    
}
