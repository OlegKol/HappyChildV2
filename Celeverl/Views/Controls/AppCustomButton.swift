//
//  AppCustomButton.swift
//  HappyChild
//
//  Created by Евгений on 11/12/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

//MARK: - AppCustomButton

public class AppCustomButton:UIButton {
    
    public var TIME_ANIMATION = 0.6
    public var Action:((_ button: UIButton) -> Void)?
    
    private var circle: CAShapeLayer = {
        var layer = CAShapeLayer()
        return layer
    }()
    
    private var inidicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.stopAnimating()
        indicator.style = .medium
        indicator.color = .white
        return indicator
    }()
    
    private var activityIndicatorView: UIView = {
        var view = UIView()
        return view
    }()
    
    public var isBusy: Bool! = false {
        didSet{
            self.toggleBusy()
        }
    }
    
    public var title: String? {
        didSet{
            self.setTitle(self.title, for: .normal)
        }
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeButton(){
        self.backgroundColor = .black
        self.layer.masksToBounds = true
        self.circle.frame = self.frame
        self.circle.fillColor = UIColor.clear.cgColor
        self.circle.lineWidth = 0
        
        self.layer.addSublayer(self.circle)
        self.addSubview(self.activityIndicatorView)
        
        self.activityIndicatorView.addSubview(self.inidicator)
        
        self.inidicator.translatesAutoresizingMaskIntoConstraints = false
        self.inidicator.topAnchor.constraint(equalTo: self.activityIndicatorView.topAnchor).isActive = true
        self.inidicator.leftAnchor.constraint(equalTo: self.activityIndicatorView.leftAnchor).isActive = true
        self.inidicator.rightAnchor.constraint(equalTo: self.activityIndicatorView.rightAnchor).isActive = true
        self.inidicator.bottomAnchor.constraint(equalTo: self.activityIndicatorView.bottomAnchor).isActive = true
        
        let touch = UITapGestureRecognizer()
        touch.numberOfTouchesRequired = 1
        touch.addTarget(self, action: #selector(touchHandle))
        
        self.addGestureRecognizer(touch)
        
    }
    
    @objc private func touchHandle(_ gesture: UILongPressGestureRecognizer){
        let location = gesture.location(in: self)
        if self.isBusy == false {
            self.startCircleAnimation(location)
        }
    }
    
    private func startCircleAnimation(_ point: CGPoint) {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = self.TIME_ANIMATION
        groupAnimation.repeatCount = 0
        groupAnimation.animations = [self.createPathAnimation(point), self.createFillColorAnination()]
        self.circle.add(groupAnimation, forKey: "pulse")
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {(timer) in self.Action?(self) })
    }
    
    func createPathAnimation(_ point:CGPoint) -> CABasicAnimation {
        
        let radius = self.frame.height > self.frame.width ? self.frame.height * 2 : self.frame.width * 2
        let oldPath = UIBezierPath(arcCenter: point, radius: 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        self.circle.path = oldPath
        let newPath = UIBezierPath(arcCenter: point, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.toValue = newPath.cgPath
        return pathAnimation
    }
    
    func createFillColorAnination() -> CABasicAnimation {
        
        let fillColorAnimation = CABasicAnimation(keyPath: "fillColor")
        fillColorAnimation.fromValue = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8).cgColor
        fillColorAnimation.toValue = UIColor.clear.cgColor
        
        return fillColorAnimation
    }
    
    private func toggleBusy(){
        DispatchQueue.main.async {
            if self.isBusy {
                    self.activityIndicatorView.frame = self.bounds
                    self.setTitle("", for: .normal)
                    self.inidicator.startAnimating()
            }
            else {
                self.inidicator.stopAnimating()
                self.setTitle(self.title, for: .normal)
            }
        }
    }
    
}



extension AppCustomButton {
    
    public override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
            }
            else {
                self.backgroundColor = UIColor.init(hex: "#B5B9C8", alpha: 255)
            }
        }
    }
}
