//
//  VideoFullDescriptionView.swift
//  HappyChild
//
//  Created by Евгений on 11/16/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit


public class VideoFullDecriptionView: UIView {
    
    var videoPalyer: UIView!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func createView(){
        self.videoPalyer = UIView()
        self.videoPalyer.backgroundColor = .black
        self.addSubview(self.videoPalyer)
        
        self.videoPalyer.translatesAutoresizingMaskIntoConstraints = false
        self.videoPalyer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.videoPalyer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.videoPalyer.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.videoPalyer.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9 / 16).isActive = true
    }
    
}
