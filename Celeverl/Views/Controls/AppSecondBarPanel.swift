//
//  AppBarPanel.swift
//  HappyChild
//
//  Created by Евгений on 11/13/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class AppSecondBarPanel: UIView {
    
    public var leftView: UIImageView!
    public var titleView: UIImageView!
    public var rightView: UIView!
    
    public var menuSize: CGFloat = 40 {
        didSet{
            self.leftView?.bounds = CGRect(x: 0, y: 0, width: self.menuSize, height: self.menuSize)
        }
    }
    
    public var leftViewCommand: ((UIView) -> Void)?
    public var centerViewCommand: ((UIView) -> Void)?
    public var rightViewCommand: ((UIView) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuareView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configuareView(){
        self.backgroundColor = UIColor.customPaleGray()
        self.createMenuView()
        self.createTitleView()
        self.createNotifyView()
    }
    
    private func createMenuView(){
        self.leftView = UIImageView(image: UIImage(named: "arrow_back"))
        self.leftView.isUserInteractionEnabled = true
        self.addSubview(self.leftView)
        
        let action = UITapGestureRecognizer(target: self, action: #selector(self.ClickLeftAction))
        self.leftView.addGestureRecognizer(action)
    }
    
    private func configuareLeftView(){
        self.leftView?.center = CGPoint(x: 40, y: self.bounds.height/2)
        self.leftView?.bounds = CGRect(x: 0, y: 0, width: self.menuSize, height: self.menuSize)
    }
    
    private func createTitleView(){
        self.titleView = UIImageView(image: UIImage(named: "black_company"))
        self.titleView.contentScaleFactor = UIScreen.main.scale
        self.titleView.contentMode = .scaleAspectFit
        
        let action = UITapGestureRecognizer(target: self, action: #selector(self.ClickCenterAction))
        self.titleView.gestureRecognizers?.append(action)
        self.addSubview(self.titleView)
    }
    
    private func configuareTitleView(){
        self.titleView?.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        self.titleView?.bounds = CGRect(x: 0, y: 0, width: self.menuSize, height: self.menuSize)
    }
    
    private func createNotifyView(){
        self.rightView = UIImageView(image: UIImage(named: "notification_picture"))
        self.rightView.contentScaleFactor = UIScreen.main.scale
        self.rightView.contentMode = .scaleAspectFit
        
        let action = UITapGestureRecognizer(target: self, action: #selector(self.ClickRightAction))
        self.rightView.gestureRecognizers?.append(action)
        self.addSubview(self.rightView)
    }
    
    private func configuareRightView(){
        self.rightView?.center = CGPoint(x: self.bounds.width-40, y: self.bounds.height/2)
        self.rightView?.bounds = CGRect(x: 0, y: 0, width: self.menuSize, height: self.menuSize)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.configuareLeftView()
        self.configuareTitleView()
        self.configuareRightView()
    }
    
    @objc private func ClickLeftAction(){
        if let command = self.leftViewCommand {
            command(self)
        }
    }
    
    @objc private func ClickCenterAction(){
        if let command = self.centerViewCommand {
            command(self)
        }
    }
    
    @objc private func ClickRightAction(){
        if let command = self.rightViewCommand {
            command(self)
        }
    }
}
