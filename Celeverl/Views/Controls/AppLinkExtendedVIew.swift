//
//  AppSelectExtendedView.swift
//  HappyChild
//
//  Created by Евгений on 11/16/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

//MARK: - AppLinkExtendedView
public class AppLinkExtendedView: UIView {
    
    
    //MARK: - PropertiesView
    private lazy var title: UILabel = {
        var label = UILabel()
        return label
    }()
    
    var bottomLine: CAShapeLayer = {
        var layer = CAShapeLayer()
        return layer
    }()
     
    public override init(frame: CGRect) {
         super.init(frame: frame)
         self.configuareView()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
     }
     
    
    //MARK: - Configuare Functions
     func configuareView(){
         self.configuareTitle()
     }
     
     func configuareTitle() {
         self.title.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
         self.title.textColor = .black
         self.title.text = "Уведомления"
         self.addSubview(self.title)

         self.title.translatesAutoresizingMaskIntoConstraints = false
         self.title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
         self.title.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
         self.title.heightAnchor.constraint(equalToConstant: 30).isActive = true
         self.title.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
     }
    
    func createLink(){
        let buttonLink = CAShapeLayer()
        buttonLink.frame = CGRect(x: self.bounds.width*0.95 - 7.5, y: self.bounds.height/2 - 7.5, width: 15, height: 15)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: buttonLink.bounds.width * 0.8, y: buttonLink.bounds.height * 0.5))
        path.addLine(to: CGPoint(x: 0, y: buttonLink.bounds.height))
        buttonLink.path = path.cgPath
        buttonLink.lineWidth = 2
        buttonLink.strokeColor = AppConstants.APP_DEFAULT_GRAY_COLOR.cgColor
        buttonLink.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(buttonLink)
    }
     
    func configuareBottomLine(){
         self.bottomLine.frame = self.bounds
         let path = UIBezierPath()
         path.move(to: CGPoint(x: 0, y: self.bounds.height))
         path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
         self.bottomLine.path = path.cgPath
         self.bottomLine.lineWidth = 2
     }
     
     override public func draw(_ rect: CGRect) {
         super.draw(rect)
         self.configuareBottomLine()
         self.createLink()
     }
}
