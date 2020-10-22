//
//  ConstantForUI.swift
//  MapViewDemo
//
//  Created by Sourabh Pal on 01/05/19.
//  Copyright © 2019 Kavya. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.borderWidth = 0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8.0
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -2, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.image = anyImage
    }
}

