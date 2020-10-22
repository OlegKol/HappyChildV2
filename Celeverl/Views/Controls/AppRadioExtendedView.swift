//
//  AppSelectExtendedView.swift
//  HappyChild
//
//  Created by Евгений on 11/16/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class AppRadioExtendedView: UIView {
    
    var radioButton: AppRadioButton!
    var title: UILabel!
    var bottomLine: CAShapeLayer!
    
   public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuareView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configuareView(){
        self.createTitle()
        self.createCheckBox()
    }
    
    func createCheckBox(){
        self.radioButton = AppRadioButton(frame: .zero)
        self.addSubview(self.radioButton)
        
        self.radioButton.translatesAutoresizingMaskIntoConstraints = false
        self.radioButton.leftAnchor.constraint(equalTo: self.title.rightAnchor, constant: 0).isActive = true
        self.radioButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.radioButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.radioButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    func createTitle(){
        self.title = UILabel(frame: .zero)
        self.title.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
        self.title.textColor = .black
        self.title.text = "Уведомления"
        self.addSubview(self.title)

        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.title.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.title.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85).isActive = true
    }
    
    func createBottomLine(){
        if(self.bottomLine == nil){
            self.bottomLine = CAShapeLayer()
            self.layer.addSublayer(self.bottomLine)
            self.bottomLine.strokeColor = UIColor.lightGray.cgColor
        }
        self.bottomLine.frame = self.bounds
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.bounds.height))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        self.bottomLine.path = path.cgPath
        self.bottomLine.lineWidth = 2
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.createBottomLine()
    }
}
