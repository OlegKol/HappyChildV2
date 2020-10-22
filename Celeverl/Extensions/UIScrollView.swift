//
//  UIScrollView.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/10/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit


extension UIScrollView {
    func updateContentSize() {
        contentSize.height = (subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY)! + 100 
    }
    
}
