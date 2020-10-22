//
//  UILabel.swift
//  Cleverl
//
//  Created by Евгений on 3/21/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func halfTextColorChange (fullText : String , changeText : String, textColor: UIColor) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor , range: range)
        self.attributedText = attribute
    }
}
