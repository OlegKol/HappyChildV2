//
//  AppCameraListView.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class AppDocumentsListView: UIView{
   
    var topTitle:UILabel!
    var listCameras: AppCameraCollectionView!
    var footerView:UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createTitle()
        self.createListView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func createTitle(){
        self.topTitle = UILabel()
        self.topTitle.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 20)
        self.topTitle.textColor = .black
        self.topTitle.text = "Ежедневные отчеты"
        self.addSubview(self.topTitle)
        
        self.topTitle.translatesAutoresizingMaskIntoConstraints = false
        self.topTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.topTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.topTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        self.topTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func createListView(){
        self.listCameras = AppCameraCollectionView()
        self.listCameras.backgroundColor = .clear
        self.addSubview(self.listCameras)
        
        self.listCameras.translatesAutoresizingMaskIntoConstraints = false
        self.listCameras.topAnchor.constraint(equalTo: self.topTitle.bottomAnchor, constant: 10).isActive = true
        self.listCameras.leftAnchor.constraint(equalTo: self.leftAnchor,  constant: 20).isActive = true
        self.listCameras.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.listCameras.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
}
