//
//  CameraViewCell.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class CameraViewCell: BaseViewCell {
    
    private var player: AVPlayer!
    private var panel: UIView!
    private var titleTop: UILabel!
    private var descriptionPanel: UILabel!
    private var statusLabel: AppErrorView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.ListInvokes.append(self.propertyChanged)
    }
    
    private func propertyChanged(_ propertyName: String) {
        if(propertyName == "BindingContext"){
            updateViewCell()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPlayerView() {
        if let cameraModel = self.BindingContext as? CameraModel{
            let url = URL(string: cameraModel.Url)
            
            if url != nil {
                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                self.player = AVPlayer(playerItem: playerItem)
                
                let playerLayer = AVPlayerLayer(player: self.player)
                playerLayer.backgroundColor = UIColor.black.cgColor
                playerLayer.frame = CGRect(x:0, y:0, width:self.bounds.width, height:self.bounds.height)
                self.layer.addSublayer(playerLayer)
            }
        }
    }
    
    func createPanelView() {
        if let cameraModel = self.BindingContext as? CameraModel{
            if(self.panel == nil){
                self.panel = UIView()
                self.panel.backgroundColor = AppConstants.APP_DEFAULT_GRAY_COLOR
                self.addSubview(self.panel)
                self.panel.translatesAutoresizingMaskIntoConstraints = false
            }
           
            self.panel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height*0.7).isActive = true
            self.panel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            self.panel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            self.panel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    func createDescriptionView(){
        if let cameraModel = self.BindingContext as? CameraModel{
            if(self.titleTop == nil){
                self.titleTop = UILabel()
                self.addSubview(self.titleTop)
                self.titleTop.textColor = .black
                self.titleTop.contentScaleFactor = UIScreen.main.scale
                self.titleTop.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 20)
                self.titleTop.translatesAutoresizingMaskIntoConstraints = false
                
                self.descriptionPanel = UILabel()
                self.addSubview(self.descriptionPanel)
                           
               self.descriptionPanel.textColor = UIColor.init(red: 131/255, green: 131/255, blue: 131/255, alpha: 1)
               self.descriptionPanel.contentScaleFactor = UIScreen.main.scale
               self.descriptionPanel.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 12)
               self.descriptionPanel.translatesAutoresizingMaskIntoConstraints = false
            }
            
            self.titleTop.topAnchor.constraint(equalTo: self.panel.topAnchor, constant: 5).isActive = true
            self.titleTop.leftAnchor.constraint(equalTo: self.panel.leftAnchor, constant: 10).isActive = true
            self.titleTop.rightAnchor.constraint(equalTo: self.panel.rightAnchor, constant: -self.bounds.width*0.3).isActive = true
            self.titleTop.heightAnchor.constraint(equalTo: self.panel.heightAnchor, multiplier: 0.3).isActive = true
            //self.titleTop.text = cameraModel.CameraName
            
           
            self.descriptionPanel.topAnchor.constraint(equalTo: self.titleTop.bottomAnchor, constant: 5).isActive = true
            self.descriptionPanel.leftAnchor.constraint(equalTo: self.panel.leftAnchor, constant: 10).isActive = true
            self.descriptionPanel.rightAnchor.constraint(equalTo: self.panel.rightAnchor, constant: -10).isActive = true
            self.descriptionPanel.heightAnchor.constraint(equalTo: self.panel.heightAnchor, multiplier: 0.5).isActive = true
           // self.descriptionPanel.text = cameraModel.Description
        }
    }
    
    func createStatusView(){
        if let cameraModel = self.BindingContext as? CameraModel{
            if(self.statusLabel == nil){
                self.statusLabel = AppErrorView()
                self.addSubview(self.statusLabel)
                self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
            }
            
            self.statusLabel.centerYAnchor.constraint(equalTo: self.titleTop.centerYAnchor, constant: 0).isActive = true
            self.statusLabel.rightAnchor.constraint(equalTo: self.panel.rightAnchor, constant: -10).isActive = true
            self.statusLabel.widthAnchor.constraint(equalTo: self.panel.widthAnchor, multiplier: 0.15).isActive = true
            self.statusLabel.heightAnchor.constraint(equalTo: self.panel.heightAnchor, multiplier: 0.3).isActive = true
            
//            if cameraModel.IsActive {
//                self.statusLabel.showAceptStatus()
//            }
//            else{
//               self.statusLabel.showDenyStatus()
//            }
        }
    }
    
    override public func updateViewCell(){
        self.createPlayerView()
        self.createPanelView()
        self.createDescriptionView()
        self.createStatusView()
    }
}
