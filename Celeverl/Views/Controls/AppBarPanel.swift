//
//  AppBarPanel.swift
//  HappyChild
//
//  Created by Евгений on 11/13/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class AppBarPanel: UIView {
    
    public var leftView: UIView = {
        var view = AppTouchView()
        view.touchBackgroundColor = UIColor.clear    
        return view
    }()
    
    public var layerLeftView: CAShapeLayer = {
        var layer = CAShapeLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.strokeColor = AppConstants.APP_DEFAULT_TEXT_COLOR.cgColor
        layer.lineWidth = 5
        layer.lineCap = .round
        return layer
    }()
    
    public var titleView: UIView = {
        var view = UIView()
        view.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        var image = UIImageView(image: UIImage(named: "company_picture"))
        image.contentMode = .scaleAspectFit
        view.mask = image
        return image
    }()
    
    private var rightLayer: CALayer = {
        let imageLayer = CALayer()
        imageLayer.contents = UIImage(contentsOfFile: "notify_picture")?.cgImage
        return imageLayer
    }()
    public var rightView: UIView = {
        var view = UIImageView(image: UIImage(named: "notify_picture"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    public var badgeView: UILabel = {
        var label = UILabel()
        return label
    }()
    
    public var notificationLayer: CAShapeLayer!
    public var notifictionTextLayer: CATextLayer!
    
    public var menuSize: CGFloat = 40
    
    public var Toggled: ((Bool) -> Void)?
    @objc dynamic public var IsOpen: Bool = false {
        didSet{
            self.updateLeftView(0.3)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuareViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func configuareViews(){
        self.createLeftView()
        self.createTitleView()
        self.createNotifyView()
        self.createBadgeView()
    }
    
    private func createLeftView(){
        self.addSubview(self.leftView)
        self.leftView.translatesAutoresizingMaskIntoConstraints = false
        self.leftView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.leftView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        self.leftView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.leftView.widthAnchor.constraint(equalToConstant: 60).isActive = true

        self.leftView.layer.addSublayer(self.layerLeftView)
        let gestureRecognizire = UITapGestureRecognizer(target: self, action: #selector(Toggle))
        self.leftView.addGestureRecognizer(gestureRecognizire)
    }
    
    private func configuareLeftView(){
        self.layerLeftView.bounds = self.layerLeftView.bounds
        self.updateLeftView()
    }
    
    private func updateLeftView(_ time: CFTimeInterval = 0.0){
        
        let newPath = self.IsOpen ? self.openPath() : self.closePath()
        CATransaction.begin()
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.duration = time
        pathAnimation.fromValue = self.layerLeftView.path
        pathAnimation.toValue = newPath.cgPath
        
        self.layerLeftView.add(pathAnimation, forKey: nil)
        
        CATransaction.setCompletionBlock({
            self.layerLeftView.path = newPath.cgPath
        })
        CATransaction.commit()
    }
    
    private func closePath() -> UIBezierPath {
        
        let path = UIBezierPath()
        let lineHeight = self.layerLeftView.lineWidth
        path.move(to: CGPoint(x:self.leftView.bounds.midX - 15, y: self.leftView.bounds.midY - 10))
        path.addLine(to: CGPoint(x: self.leftView.bounds.midX + 15, y: self.leftView.bounds.midY - 10))

        path.move(to: CGPoint(x:self.leftView.bounds.midX - 15, y: self.leftView.bounds.midY))
        path.addLine(to: CGPoint(x: self.leftView.bounds.midX + 15, y: self.leftView.bounds.midY))

        path.move(to: CGPoint(x:self.leftView.bounds.midX - 15, y: self.leftView.bounds.midY + 10))
        path.addLine(to: CGPoint(x:self.leftView.bounds.midX + 15, y: self.leftView.bounds.midY + 10))
        return path
    }
    
    private func openPath() -> UIBezierPath {
        let lineHeight = self.layerLeftView.lineWidth
        let path = UIBezierPath()
        path.move(to: CGPoint(x:self.leftView.bounds.midX - 10, y: self.leftView.bounds.midY - 10))
        path.addLine(to: CGPoint(x:self.leftView.bounds.midX + 10, y:self.leftView.bounds.midY + 10))
        
        path.move(to: CGPoint(x:self.leftView.bounds.midX - 10, y: self.leftView.bounds.midY + 10))
        path.addLine(to: CGPoint(x:self.leftView.bounds.midX + 10, y: self.leftView.bounds.midY - 10))
        return path
    }
    
    private func createTitleView(){
//        self.addSubview(self.titleView)
//        self.titleView.translatesAutoresizingMaskIntoConstraints = false
//        self.titleView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        self.titleView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -50).isActive = true
//        self.titleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        self.titleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        titleLabel.textAlignment = .center
        titleLabel.text = "HappyChild\nGeneration"
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 17)
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func createNotifyView(){
        self.addSubview(self.rightView)
        self.rightView.translatesAutoresizingMaskIntoConstraints = false
        self.rightView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.rightView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -25).isActive = true
        self.rightView.widthAnchor.constraint(equalToConstant: 37).isActive = true
        self.rightView.heightAnchor.constraint(equalToConstant: 34).isActive = true
    }
    
    private func createBadgeView(){
        self.addSubview(self.badgeView)
    }
    
    private func configuareBadgeView(){
        self.badgeView.center = CGPoint(x: self.bounds.width - 28, y: self.bounds.height/2 - 10)
        self.badgeView.bounds = CGRect(x: 0, y: 0, width: 26, height: 26)
        self.badgeView.layer.cornerRadius = 9
        self.badgeView.backgroundColor = .white
        self.badgeView.isHidden = true
        self.badgeView.textColor = UIColor.init(hex: "#32417F", alpha: 1)
        self.badgeView.layer.borderWidth = 2
        self.badgeView.layer.borderColor = UIColor.init(hex: "#32417F", alpha: 1).cgColor
        self.badgeView.textAlignment = NSTextAlignment.center
        self.badgeView.clipsToBounds = true
        self.badgeView.font = badgeView.font.withSize(12.0)
    }
    
    public func showBadgeView(flag: Bool){
        if(flag == true){
            self.badgeView.text = String(UIApplication.shared.applicationIconBadgeNumber)
            self.badgeView.isHidden = false
        }else{
            self.badgeView.isHidden = true
        }
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.configuareLeftView()
        self.configuareBadgeView()
        
    }
    
    @objc public func Toggle(_ gesture: UIGestureRecognizer){
        self.updateLeftView()
        if let click = self.Toggled {
            click(self.IsOpen)
        }
    }
    
}
