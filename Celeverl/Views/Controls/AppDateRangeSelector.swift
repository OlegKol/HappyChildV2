//
//  AppDateRangeSelector.swift
//  Cleverl
//
//  Created by Евгений on 3/22/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit


public class AppDateRangeSelector: UIView {

    public var fromDate: Date = {
        var date = Date()
        return date
        }(){
        didSet{
            self.updateView()
        }
    }
    
    public var toDate: Date = {
       var date = Date()
            return date
    }(){
        didSet{
            self.updateView()
        }
    }
    
    public var dateForrmater: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }(){
        didSet{
            self.updateView()
        }
    }
    
    public var fromDateLabel: AppCustomButton = {
        var button = AppCustomButton()
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        button.setTitleColor(AppConstants.APP_DEFAULT_TEXT_COLOR, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    public var toDateLabel: AppCustomButton = {
       var button = AppCustomButton()
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        button.setTitleColor(AppConstants.APP_DEFAULT_TEXT_COLOR, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpView(){
        
        self.addSubview(self.fromDateLabel)
        self.fromDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.fromDateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 25).isActive = true
        self.fromDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        self.fromDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        self.fromDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.fromDateLabel.title = self.dateForrmater.string(from: self.fromDate)
        self.fromDateLabel.isUserInteractionEnabled = true
        
        let image = UIImageView(image: UIImage(named: "ic_right"))
        
        self.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 10).isActive = true
        image.centerYAnchor.constraint(equalTo:self.fromDateLabel.centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
        
        self.addSubview(self.toDateLabel)
        self.toDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.toDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        self.toDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        self.toDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        self.toDateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.toDateLabel.title = self.dateForrmater.string(from: self.toDate)
        self.toDateLabel.isUserInteractionEnabled = true
    }
    
    private func updateView(){
        self.fromDateLabel.title = self.dateForrmater.string(from: self.fromDate)
        self.toDateLabel.title = self.dateForrmater.string(from: self.toDate)
    }
}
