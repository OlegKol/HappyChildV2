//
//  AppCameraListView.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class AppCameraListView: UIView {
   
    var listCameras: AppCameraCollectionView = {
        var collection = AppCameraCollectionView()
        return collection
    }()
    
    public var selectDelegate: SelectItemCollectionDelegateProtocol?{
        didSet{
            self.listCameras.selectDelegate = self.selectDelegate
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createListView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
   
    private func createListView(){
        self.listCameras.backgroundColor = .clear
        self.addSubview(self.listCameras)
        
        let margin:CGFloat = 20
        self.listCameras.translatesAutoresizingMaskIntoConstraints = false
        self.listCameras.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        self.listCameras.leftAnchor.constraint(equalTo: self.leftAnchor,  constant: margin).isActive = true
        self.listCameras.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
        self.listCameras.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -margin).isActive = true
    }
    
    
    public func updateBindingContext(list: [BaseModel]){
        self.listCameras.BindingContext = list
    }
    
}
