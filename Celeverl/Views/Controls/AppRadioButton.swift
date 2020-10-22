//
//  AppRadioButton.swift
//  HappyChild
//
//  Created by Евгений on 11/20/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit


public class AppRadioButton: UIView {
    
    private var _layer: CAShapeLayer!
    private var buttonLayer:CAShapeLayer!
    private var backgroundLayer:CAShapeLayer!
    
    public var TIME_ANIMATION: TimeInterval = 0.2
    public var selectedButtonColor: UIColor = UIColor.black
    public var nonSelectedButtonColor: UIColor = UIColor.darkGray
    public var backgroundButtonColor: UIColor = UIColor.lightGray
    public var cornerButtonRadius: CGFloat = 10
    public var backgroundCornerRadius: CGFloat = 5
    
    public var state: Bool = false {
        didSet{
            self.updateView()
        }
    }
    public var Clicked: ((Bool)->Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touchHandle))
        recognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(recognizer)
        self.isUserInteractionEnabled = true
        self.createLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.configuareLayer()
    }
    
    public func createLayer(){
        self.layer.masksToBounds = true
        self.contentScaleFactor = UIScreen.main.scale
        
        self._layer = CAShapeLayer()
        self._layer.contentsScale = self.contentScaleFactor
        self.layer.addSublayer(self._layer)
        
        self._layer.strokeColor = UIColor.black.cgColor
        self._layer.fillColor = UIColor.white.cgColor
        self._layer.lineWidth = 1
        
        self.backgroundLayer = CAShapeLayer()
        self.backgroundLayer.contentsScale = self.contentScaleFactor
        self.layer.addSublayer(self.backgroundLayer)
        
        self.buttonLayer = CAShapeLayer()
        self.buttonLayer.contentsScale = self.contentScaleFactor
        self.layer.addSublayer(self.buttonLayer)
    }
    
    private func configuareLayer(){
        self.backgroundLayer.frame = self.bounds
        self.buttonLayer.frame = self.bounds
        
        let path = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: self.bounds.height/2 - backgroundCornerRadius), size: CGSize(width: self.bounds.width, height: 2 * backgroundCornerRadius)), cornerRadius: backgroundCornerRadius)
        self._layer.path = path.cgPath
        self.updateView()
    }
    
    private func updateView(){
        if self.state {
            self.Selected()
        }
        else{
            self.nonSelected()
        }
    }
    
     public func Selected(){
        
        let newBackgroundPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: self.bounds.height/2 - backgroundCornerRadius), size: CGSize(width: self.bounds.width, height: 2 * backgroundCornerRadius)), cornerRadius: backgroundCornerRadius)
        
        let newButtonPath = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width - cornerButtonRadius, y: self.bounds.height/2), radius: cornerButtonRadius, startAngle: 0 , endAngle: CGFloat(2 * Float.pi), clockwise: true)
        
        CATransaction.begin()
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.fromValue = self.buttonLayer.path
            pathAnimation.toValue = newButtonPath.cgPath
            
            let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
            colorAnimation.fromValue = self.buttonLayer.strokeColor
            colorAnimation.toValue = self.selectedButtonColor.cgColor
            
            let groupButtonAnimation = CAAnimationGroup()
            groupButtonAnimation.duration = self.TIME_ANIMATION
            groupButtonAnimation.repeatCount = 0
            groupButtonAnimation.animations = [pathAnimation, colorAnimation]
        
        
            let backgroundColorAnimation = CABasicAnimation(keyPath: "strokeColor")
            backgroundColorAnimation.fromValue = self.backgroundLayer.fillColor
            backgroundColorAnimation.toValue = self.backgroundButtonColor.cgColor
        
            let pathBackgroundAnimation = CABasicAnimation(keyPath: "path")
            pathBackgroundAnimation.fromValue = self.backgroundLayer.path
            pathBackgroundAnimation.toValue = newBackgroundPath.cgPath
        
            let groupBackgroundAnimation = CAAnimationGroup()
            groupBackgroundAnimation.duration = self.TIME_ANIMATION
            groupBackgroundAnimation.repeatCount = 0
            groupBackgroundAnimation.animations = [backgroundColorAnimation, pathBackgroundAnimation]
            
            self.buttonLayer.add(groupButtonAnimation, forKey: nil)
            self.backgroundLayer.add(groupBackgroundAnimation, forKey: nil)
        
        CATransaction.setCompletionBlock({
            self.buttonLayer.fillColor = self.selectedButtonColor.cgColor
            self.buttonLayer.path = newButtonPath.cgPath
            
            self.backgroundLayer.fillColor = self.backgroundButtonColor.cgColor
            self.backgroundLayer.path = newBackgroundPath.cgPath
        })
        CATransaction.commit()
    }
    
    public func nonSelected(){
        
        let newButtonPath = UIBezierPath(arcCenter: CGPoint(x: cornerButtonRadius, y: self.bounds.height/2), radius: cornerButtonRadius, startAngle: 0 , endAngle: CGFloat(2 * Float.pi), clockwise: true)
        
        let newBackgroundPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 0, y: self.bounds.height/2 - backgroundCornerRadius), size: CGSize(width: cornerButtonRadius, height: 2 * backgroundCornerRadius)), cornerRadius: backgroundCornerRadius)
        
        CATransaction.begin()
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.fromValue = self.buttonLayer.path
            pathAnimation.toValue = newButtonPath.cgPath

            let strokeAnimation = CABasicAnimation(keyPath: "fillColor")
            strokeAnimation.fromValue = self.buttonLayer.fillColor
            strokeAnimation.toValue = self.buttonLayer.fillColor

            let groupAnimation = CAAnimationGroup()
            groupAnimation.duration = self.TIME_ANIMATION
            groupAnimation.repeatCount = 0
            groupAnimation.animations = [pathAnimation, strokeAnimation]
        
            
            let backgroundPathAnimation = CABasicAnimation(keyPath: "path")
            backgroundPathAnimation.fromValue = self.backgroundLayer.path
            backgroundPathAnimation.toValue = newBackgroundPath.cgPath
        
            let groupBackgroundAnimation = CAAnimationGroup()
            groupBackgroundAnimation.duration = self.TIME_ANIMATION
            groupBackgroundAnimation.repeatCount = 0
            groupBackgroundAnimation.animations = [backgroundPathAnimation]

            self.buttonLayer.add(groupAnimation, forKey: nil)
            self.backgroundLayer.add(groupBackgroundAnimation, forKey: nil)
        CATransaction.setCompletionBlock({
            self.buttonLayer.fillColor = self.buttonLayer.fillColor
            self.buttonLayer.path = newButtonPath.cgPath
            
            self.backgroundLayer.path = newBackgroundPath.cgPath
        })
        CATransaction.commit()
    }
    
//    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.state = !self.state
//        self.Clicked?(self.state)
//    }
    
    
    @objc func touchHandle(){
        self.state = !self.state
        self.Clicked?(self.state)
    }
}
