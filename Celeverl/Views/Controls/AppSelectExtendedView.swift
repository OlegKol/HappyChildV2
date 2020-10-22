//
//  AppSelectExtendedView.swift
//  HappyChild
//
//  Created by Евгений on 11/16/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class AppSelectedExtendedView: UIView {
    
    var checkBox: AppCustomCheckBox!
    var firstTitle: UILabel!
    var secondTitle: UILabel!
    var bottomLine: CAShapeLayer!
    
   public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuareView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configuareView(){
        self.createCheckBox()
        self.createFirstTitle()
        self.createSecondTitle()
    }
    
    func createCheckBox(){
        self.checkBox = AppCustomCheckBox(frame: .zero)
        //self.checkBox.state = true
        self.addSubview(self.checkBox)
        
        self.checkBox.translatesAutoresizingMaskIntoConstraints = false
        self.checkBox.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.checkBox.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.checkBox.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func createFirstTitle() {
        self.firstTitle = UILabel(frame: .zero)
        self.firstTitle.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
        self.firstTitle.textColor = .black
        self.firstTitle.text = "Уведомления"
        self.addSubview(self.firstTitle)

        self.firstTitle.translatesAutoresizingMaskIntoConstraints = false
        self.firstTitle.leftAnchor.constraint(equalTo: self.checkBox.rightAnchor, constant: 20).isActive = true
        self.firstTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.firstTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.firstTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    }
    
    func createSecondTitle() {
        self.secondTitle = UILabel(frame: .zero)
        self.secondTitle.font = UIFont(name: AppConstants.APP_AVENIR, size: 14)
        self.secondTitle.textColor = AppConstants.APP_DEFAULT_GRAY_COLOR
        self.secondTitle.text = "Уведомления"
        self.addSubview(self.secondTitle)

        self.secondTitle.translatesAutoresizingMaskIntoConstraints = false
        self.secondTitle.leftAnchor.constraint(equalTo: self.checkBox.rightAnchor, constant: 20).isActive = true
        self.secondTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.secondTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.secondTitle.topAnchor.constraint(equalTo: self.firstTitle.bottomAnchor, constant: 5).isActive = true
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
