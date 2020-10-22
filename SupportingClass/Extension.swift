//
//  Extension.swift
//  Pip
//
//  Created by Kavya Indore on 18/02/19.
//  Copyright © 2019 Kavya Indore. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

func setGradient(btn:UIButton)->CAGradientLayer {
    
    // Apply Gradient Color
    let gradientLayer:CAGradientLayer = CAGradientLayer()
    gradientLayer.frame.size = btn.frame.size
    gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.1)
    gradientLayer.endPoint = CGPoint(x: 0.1, y:1.1)
    
    let color1 = hexStringToUIColor(hex: "#0d4ec5")
    let color2 = hexStringToUIColor(hex: "#1d8bb4")
   gradientLayer.colors =
        [color2.cgColor,color1.withAlphaComponent(1).cgColor]
    
//    gradientLayer.colors =
//        [color1.cgColor,UIColor.orange.withAlphaComponent(1).cgColor]
    
    return gradientLayer
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//*********************** Navigation Contoller Code Start ************************\\
extension UINavigationController {
    func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
    }
    
    func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
    public func hpnavigation(barhide : Bool , navcolor : UIColor , backbtncolor : UIColor ,statusBarColor : UIColor, textColor : UIColor, hidebackbtn : Bool) {
        
        if barhide {
            hideTransparentNavigationBar()
            navigationBar.tintColor = backbtncolor// back button color
            navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor : textColor]
            //navigationBar.backgroundColor = navcolor //
            UIApplication.shared.statusBarView?.backgroundColor = statusBarColor
            
        } else {
            presentTransparentNavigationBar()
            navigationBar.tintColor = backbtncolor// back button color
            navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor : textColor]
            navigationBar.backgroundColor = navcolor //
            navigationBar.barTintColor = navcolor
            
            let imgBg = UIImageView()
            imgBg.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64)
            imgBg.image = UIImage(named: "header")
            
            self.navigationBar.setBackgroundImage(imgBg.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch), for: .default)
            
            DispatchQueue.main.async {
                self.navigationBar.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 0)
            }
            
            UIApplication.shared.statusBarView?.backgroundColor = statusBarColor
            self.navigationController?.isNavigationBarHidden = true
        }
    }
}

extension UINavigationBar {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension UIImageView {
    
    func makeRounded() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//*********************** Navigation Contoller Code End **************************\\
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
