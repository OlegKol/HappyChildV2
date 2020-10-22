//
//  AppTouchView.swift
//  Cleverl
//
//  Created by Евгений on 2/27/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

//MARK: - AppTouchView
public class AppTouchView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.SetUp()
    }
    
    public var touchBackgroundColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func SetUp(){
        self.layer.masksToBounds = true
    }
    
    func touchAnimation(_ point: CGPoint) {
        
        let circle = CAShapeLayer()
        circle.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(circle)
        
        let oldPath = UIBezierPath(arcCenter: point, radius: 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        circle.path = oldPath
        
        let radius = max(self.frame.height * 2,self.frame.width * 2)
        let newPath = UIBezierPath(arcCenter: point, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)

        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = newPath.cgPath
        
        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        fillColorAnimation.fromValue = self.touchBackgroundColor.cgColor
        fillColorAnimation.toValue = UIColor.clear.cgColor
               
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.7
        groupAnimation.repeatCount = 0
        groupAnimation.animations = [pathAnimation, fillColorAnimation]
        
        circle.add(groupAnimation, forKey: "pulse")
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if touches.count > 0, let touch = touches.first {
            let location = touch.location(in: self)
            self.touchAnimation(location)
        }
    }
}
