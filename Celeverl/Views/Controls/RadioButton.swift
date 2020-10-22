//
//  RadioButton.swift
//  Cleverl
//
//  Created by Евгений on 3/20/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit


public class RadioButton : UIView {
    
    var fontLayer: CAShapeLayer = {
        var layer = CAShapeLayer()
        return layer
    }()
    
    var activeColor: UIColor = UIColor.systemBlue
    var IsSelect: Bool = false{
        didSet {
            self.updateView()
        }
    }
    
    var Clicked:((Bool) -> Void)?
    
    @objc dynamic func tapHandle(){
        self.IsSelect = !self.IsSelect
        self.ckeckCallAction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(self.fontLayer)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.configuareView()
    }
    
    
    func configuareView(){
        self.layer.addSublayer(self.fontLayer)
        self.fontLayer.frame = self.bounds
        self.fontLayer.cornerRadius = self.bounds.height / 2
        self.fontLayer.fillColor = self.IsSelect ? self.activeColor.cgColor : UIColor.clear.cgColor
        self.fontLayer.borderColor = UIColor.init(hex: "#CCCCCC", alpha: 1).cgColor
        self.fontLayer.borderWidth = 1
        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2), radius: self.bounds.height / 2, startAngle: 0, endAngle: 360, clockwise: true)
        self.fontLayer.path = path.cgPath
    }
    
    
    private func updateView(){
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 0.25
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0.7
        scaleAnimation.autoreverses = true
        
        self.fontLayer.add(scaleAnimation, forKey: "transform.scale")
        
        CATransaction.begin()
        
        let newfillColor = self.IsSelect ? self.activeColor.cgColor : UIColor.clear.cgColor
        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        fillColorAnimation.duration = 0.25
        fillColorAnimation.fromValue = self.fontLayer.fillColor
        fillColorAnimation.toValue = newfillColor
        fillColorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        fillColorAnimation.autoreverses = false
        fillColorAnimation.repeatCount = 0
        
        self.fontLayer.add(fillColorAnimation, forKey: nil)
        
        CATransaction.setCompletionBlock({
            self.fontLayer.fillColor = newfillColor
           
        })
        CATransaction.commit()
    }
    
    private func ckeckCallAction(){
        self.Clicked?(self.IsSelect)
    }
    
    
}
