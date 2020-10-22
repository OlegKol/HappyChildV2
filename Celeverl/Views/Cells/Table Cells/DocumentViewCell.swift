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

public class DocumentViewCell: BaseUITableViewCell {
    
    static let resueseId: String = "DocumentViewCell"
    
    private var titleView: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 18)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        return label
    }()
    
    private var descriptionView: UILabel = {
       var label = UILabel()
       label.numberOfLines = 0
       label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 14)
       label.textColor = .darkGray
       return label
    }()
    
    public var backView: UIView = {
        var back = UIView()
        back.layer.cornerRadius = 10
        back.layer.masksToBounds = true
        return back
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MenuTableViewCell.self.resueseId)
        self.configuareViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func OnPropertyChanged(_ propertyName: String) {
        if propertyName == "BindingContext" {
            self.updateView()
        }
    }
    
    private func updateView(){
        guard let model = self.BindingContext as? DocumentModel else { return }
        let shortTime = DateFormatter()
        shortTime.dateFormat = "dd.MM"
        self.titleView.text = "Ежедневный отчет за \(shortTime.string(from: model.date))"
    }
    
    private func configuareViews(){
        self.confgiaureBackView()
        self.configuareTitleView()
        self.configuareDescriptionView()
    }
    
    private func configuareTitleView(){
        self.addSubview(self.titleView)
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.leftAnchor.constraint(equalTo: self.backView.leftAnchor, constant: 16).isActive = true
        self.titleView.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 16).isActive = true
        self.titleView.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -16).isActive = true
    }
    
    private func configuareDescriptionView(){
        self.addSubview(self.descriptionView)
        self.descriptionView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionView.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -16).isActive = true
        self.descriptionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 16).isActive = true
        self.descriptionView.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -16).isActive = true
    }
    
    private func confgiaureBackView(){
        self.addSubview(self.backView)
        self.backView.translatesAutoresizingMaskIntoConstraints = false
        self.backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.backView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.backView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.backView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.backView.backgroundColor = UIColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    }
}
