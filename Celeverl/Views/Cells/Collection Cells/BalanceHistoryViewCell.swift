//
//  BalanceHistoryViewCell.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/20/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class BalanceHistoryViewCell: BaseViewCell {
    
    public static let reuqseID = "BalanceHistoryViewCell"
    
    var valueView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 18)
        return label
    }()
    
    var dataView: UILabel = {
        let label = UILabel()
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        return label
    }()
    
    var contentCell: ViewButtomLine = {
        var view = ViewButtomLine()
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.ListInvokes.append(self.propertyChanged(_:))
        
        self.configuareContentView()
        self.configuareDataView()
        self.configuarePriceView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func propertyChanged(_ propertyName: String) {
        if(propertyName == "BindingContext"){
            updateViewCell()
        }
    }
    
    override public func updateViewCell() {
        
        if let data = self.BindingContext as? HistoryBalanceModel {
            if data.HappyChildAnalysisHoursChangeValue > 0 {
               self.valueView.textColor = .systemGreen
            }
            else {
               self.valueView.textColor = .systemRed
            }
            self.valueView.text = String(data.HappyChildAnalysisHoursChangeValue)
            self.dataView.text = String(data.ChangeDateStr)
        }
    }
    
    private func configuarePriceView(){
        self.valueView.translatesAutoresizingMaskIntoConstraints = false
        self.valueView.centerYAnchor.constraint(equalTo: self.contentCell.centerYAnchor, constant: 0).isActive = true
        self.valueView.leftAnchor.constraint(equalTo: self.dataView.rightAnchor, constant: 0).isActive = true
        self.valueView.rightAnchor.constraint(equalTo: self.contentCell.rightAnchor, constant: -20).isActive = true
        self.valueView.textAlignment = .right
    }
    
    private func configuareDataView(){
        self.dataView.translatesAutoresizingMaskIntoConstraints = false
        self.dataView.centerYAnchor.constraint(equalTo: self.contentCell.centerYAnchor, constant: 0).isActive = true
        self.dataView.leftAnchor.constraint(equalTo: self.contentCell.leftAnchor, constant: 0).isActive = true
        self.dataView.widthAnchor.constraint(equalTo: self.contentCell.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    private func configuareContentView(){
        
        self.addSubview(self.contentCell)
        self.contentCell.addSubview(self.valueView)
        self.contentCell.addSubview(self.dataView)
        
        self.contentCell.heightLine = 2
        self.contentCell.colorLine = UIColor.init(hex: "#CCCCCC", alpha: 1)
        self.contentCell.translatesAutoresizingMaskIntoConstraints = false
        self.contentCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.contentCell.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.contentCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.contentCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
