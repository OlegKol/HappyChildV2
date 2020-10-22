//
//  HttpsRequest.swift
//  jsonSwift
//
//  Created by Harish on 6/15/15.
//  Copyright (c) 2015 Harish. All rights reserved.
//

import UIKit

let kCouldnotconnect = "Could not connect to the server. Please try again later."
let kInternetNotAvailable = "Please establish network connection."

import UIKit

class Valid: NSObject {
    
    let NameAcceptableCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
    
    class func email(_ testStr:String) -> Bool {
        var count = 0
        
        for r in testStr {//testStr.characters
            if r == "@" {
                count += 1
            }
        }
        if count > 1 {
            return false
        }
        
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            return regex.firstMatch(in: testStr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, testStr.count)) != nil
        } catch {
            print("hgkjhgjkgh")
            return false
        }
    }
    
    class func url (_ testStr:String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            return regex.firstMatch(in: testStr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, testStr.count)) != nil
        } catch {
            return false
        }
    }
    
    class func fiscale(_ testStr: String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: "[A-Za-z]{6}[0-9lmnpqrstuvLMNPQRSTUV]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9lmnpqrstuvLMNPQRSTUV]{2}[A-Za-z]{1}[0-9lmnpqrstuvLMNPQRSTUV]{3}[A-Za-z]{1}", options: .caseInsensitive)
            return regex.firstMatch(in: testStr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, testStr.count)) != nil
            
        } catch {
            return false
        }
    }
    
    class func password (_ testStr: String) -> Bool {
        
        if testStr.count < 8 {
            return false
        }
        return true
    }
    
    class func name(strTest: String) -> Bool {
        
        let numberCharacters = NSCharacterSet.decimalDigits
        
        if strTest.rangeOfCharacter(from: numberCharacters) != nil {
            return false
        }
        else if strTest.rangeOfCharacter(from: numberCharacters) == nil {
            return true
        }
        return true
    }
}

// MARK: View

class View : UIView {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func layoutSubviews11() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let color = self.backgroundColor
            self.backgroundColor = UIColor.clear
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.tag)).cgPath
            shadowLayer.fillColor = color?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

// MARK: Label

class Label : UILabel {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

// MARK: TextView

class TextView : UITextView {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}


// MARK: extension UITextField

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

// MARK: TextField

class TextField : UITextField {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    @IBInspectable open var padding: Int = 0
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
        
        if padding > 0 {
            padding (padding)
        }
    }
    
    /*override func padding (_ pad:Int) {
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: pad, height: Int(self.frame.size.height)))
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewMode.always
    }*/
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

// MARK: ImageView

class ImageView : UIImageView {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

// MARK: Button

class Button : UIButton {
    @IBInspectable open var isBorder: Bool = false
    
    @IBInspectable open var border: Int = 0
    
    @IBInspectable open var radious: Int = 0
    
    @IBInspectable open var borderColor: UIColor? = nil
    
    @IBInspectable open var isShadow: Bool = false
    
    @IBInspectable open var shadow_Color: UIColor? = UIColor.darkGray
    
    @IBInspectable open var ls_Opacity:CGFloat = 0.5
    @IBInspectable open var ls_Radius:Int = 0
    
    @IBInspectable open var lsOff_Width:CGFloat = 2.0
    @IBInspectable open var lsOff_Height:CGFloat = 2.0
    
    @IBInspectable open var isStrokeColor: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isStrokeColor {
            let c = UIGraphicsGetCurrentContext()
            c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
            c!.setStrokeColor(UIColor.red.cgColor)
            c!.strokePath()
        }
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isShadow {
            if shadowLayer == nil {
                let color = self.backgroundColor
                self.backgroundColor = UIColor.clear
                
                shadowLayer = CAShapeLayer()
                shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(radious)).cgPath
                shadowLayer.fillColor = color?.cgColor
                
                shadowLayer.shadowColor = shadow_Color?.cgColor
                shadowLayer.shadowPath = shadowLayer.path
                shadowLayer.shadowOffset = CGSize(width: lsOff_Width, height: lsOff_Height)
                shadowLayer.shadowOpacity = Float(ls_Opacity)
                shadowLayer.shadowRadius = CGFloat(ls_Radius)
                
                layer.insertSublayer(shadowLayer, at: 0)
            }
        } else if isBorder {
            border1(borderColor, CGFloat(radious), CGFloat(border))
        }
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    
    
    
    
}

// MARK: UILabel

class SBLabel : UILabel {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        //let c = UIGraphicsGetCurrentContext()
        //c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
        //c!.setStrokeColor(UIColor.red.cgColor)
        //c!.strokePath()
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let color = self.backgroundColor
            self.backgroundColor = UIColor.clear
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.tag)).cgPath
            shadowLayer.fillColor = color?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class BLabel : UILabel {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    var shadowLayer: CAShapeLayer!
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 1.0)
    }
}

class BLabel0 : UILabel {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
    }
    
    var shadowLayer: CAShapeLayer!
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 0.0)
    }
}

// MARK: UIView

class SBView : UIView {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        //let c = UIGraphicsGetCurrentContext()
        //c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
        //c!.setStrokeColor(UIColor.red.cgColor)
        //c!.strokePath()
    }
    
    var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let color = self.backgroundColor
            self.backgroundColor = UIColor.clear
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.tag)).cgPath
            shadowLayer.fillColor = color?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class BView : UIView {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    var shadowLayer: CAShapeLayer!
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 1.0)
    }
}

class BView0 : UIView {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    var shadowLayer: CAShapeLayer!
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 0.0)
    }
}

// MARK: UIButton

class SBButton : UIButton {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        //let c = UIGraphicsGetCurrentContext()
        //c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
        //c!.setStrokeColor(UIColor.red.cgColor)
        //c!.strokePath()
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let color = self.backgroundColor
            self.backgroundColor = UIColor.clear
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.tag)).cgPath
            shadowLayer.fillColor = color?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class BButton : UIButton {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 1.0)
    }
}

class BButton0 : UIButton {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 0.0)
    }
}

// MARK: UITextView

class BTextView : UITextView {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 1.0)
    }
}

class BTextView0 : UITextView {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 0.0)
    }
}

class SBTextView : UITextView {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        //let c = UIGraphicsGetCurrentContext()
        //c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
        //c!.setStrokeColor(UIColor.red.cgColor)
        //c!.strokePath()
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let color = self.backgroundColor
            self.backgroundColor = UIColor.clear
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.tag)).cgPath
            shadowLayer.fillColor = color?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

// MARK: UITextField

class SBTextField : UITextField {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        //let c = UIGraphicsGetCurrentContext()
        //c!.addRect(CGRect(x: 10.0, y: 10.0, width: 80.0, height: 80.0))
        //c!.setStrokeColor(UIColor.red.cgColor)
        //c!.strokePath()
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let color = self.backgroundColor
            self.backgroundColor = UIColor.clear
            
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(self.tag)).cgPath
            shadowLayer.fillColor = color?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

class BTextField : UITextField {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 1.0)
    }
}

class BTextField0 : UITextField {
    var radious:Float!
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func border1 (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border1(UIColor.lightGray, CGFloat(self.tag), 0.0)
    }
}

// MARK: Http

class Http: NSObject {
    class func instance () -> Http {
        return Http()
    }
    
   /* static func getRouteBetweenTwoLocations ( newLocation:CLLocation?,  keyPlace:CLLocation?) -> (overview_polyline:String?, totalDistance:Double, latCenter:Double, longCenter:Double) {
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\((newLocation?.coordinate.latitude)!),\((newLocation?.coordinate.longitude)!)&destination=\((keyPlace?.coordinate.latitude)!),\((keyPlace?.coordinate.longitude)!)&sensor=false&mode=driving&key=\(PredefinedConstants.GoogleAccount_Key)"
        print(url)
        
        let json = Http.instance().jsonSynchronous(url, false)
        
        if json != nil {
            let routes = json?["routes"] as! [NSDictionary]
            
            if routes.count > 0 {
                let dict_overview_polyline = routes[0] as NSDictionary
                let overview_polyline = dict_overview_polyline.object(forKey: "overview_polyline") as! NSDictionary
                let pointsp = overview_polyline.object(forKey: "points") as? String
                
                var j = 0
                
                let legs = dict_overview_polyline.object(forKey: "legs") as? NSArray
                
                if (legs?.count)! > 0 {
                    let legs0 = legs?[0] as! NSDictionary
                    let steps = legs0.object(forKey: "steps") as! NSArray
                    
                    let points_count = steps.count
                    
                    let points = NSMutableArray()
                    
                    var totalDistance = 0.0;
                    var latCenter = 0.0;
                    var longCenter = 0.0;
                    
                    for i in 0..<points_count {
                        let d1 = steps[i] as! NSDictionary
                        let start_location = d1.object(forKey: "start_location") as! NSDictionary
                        
                        let st_lat = number(start_location, "lat").doubleValue
                        let st_lon = number(start_location, "lng").doubleValue
                        
                        latCenter = st_lat;
                        longCenter = st_lon;
                        
                        if (i == (points_count/2) && (points_count%2 == 0)) {
                            latCenter = st_lat;
                            longCenter = st_lon;
                        }
                        
                        let text = d1.object(forKey: "distance") as! NSDictionary
                        let distance = string(text, "text")
                        
                        let arr = distance.components(separatedBy: " ")
                        
                        if arr.count == 2 {
                            var d = 0.0
                            
                            if distance.contains("km") {
                                d = Double(arr[0])! * 1000.0
                            } else if distance.contains("m") {
                                d = Double(arr[0])!
                            }
                            
                            totalDistance += d
                        }
                        
                        if (st_lat > 0.0 && st_lon > 0.0) {
                            points[j] = CLLocationCoordinate2DMake(st_lat, st_lon)
                            j += 1
                        }
                        
                        let end_location = d1.object(forKey: "end_location") as! NSDictionary
                        
                        let end_lat = number(end_location, "lat").doubleValue
                        let end_lon = number(end_location, "lng").doubleValue
                        
                        points[j] = CLLocationCoordinate2DMake(end_lat, end_lon);
                        //endCoordinate = CLLocationCoordinate2DMake(end_lat, end_lon);
                        j += 1
                    }
                    
                    return (pointsp, totalDistance, latCenter, longCenter)
                }
            }
        }
        
        return (nil, 0.0, 0.0, 0.0)
    }*/
    
    func jsonSynchronous (_ api:String, _ prnt:Bool) -> NSDictionary? {
        
        let data = NSData(contentsOf: NSURL(string: (api.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!))! as URL)
        
        do {
            if data != nil {
                let json:NSDictionary? = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? NSDictionary
                
                if prnt {
                    print("api-\(api)-")
                    print("json-\(String(describing: json))-")
                }
                
                return json
            } else {
                return nil
            }
        } catch _ as NSError {
            return nil
        }
    }
    
    func json (_ api:String?,_ params:NSMutableDictionary?, _ method:String?, ai:Bool, popup:Bool, prnt:Bool, _ header:NSDictionary? = nil , _ images:NSMutableArray? = nil, sync:Bool = false, completionHandler: @escaping (Any?, NSMutableDictionary?) -> Swift.Void) {
        
        let reach = Reachability.init(hostname: "google.com")
        
        if (reach?.isReachable)! {
            if ai {
                startActivityIndicator()
            }
            
            var request = NSMutableURLRequest(url: NSURL(string: (api!.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!))! as URL)
            
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 180.0
            config.timeoutIntervalForResource = 180.0
            config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            
            let session = URLSession(configuration: config)
            
            if (method == "GET" && params != nil) {
                var url = api! + "?"
                
                for (key,value) in params! {
                    url = url + "\(key as! String)=\(value)&"
                }
                
                request = NSMutableURLRequest(url: NSURL(string: (url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!))! as URL)
            } else if (method == "POST") {
                request.httpMethod = method!
                
                var data:Data! = Data()
                
                do {
                    if (method == nil || params == nil) {
                        data = try JSONSerialization.data(withJSONObject:[], options:[])
                        request.httpBody = data
                    } else if (method == "GET") {
                        data = try JSONSerialization.data(withJSONObject:[], options:[])
                        request.httpBody = data
                    } else if (method == "POST") {
                        if images != nil {
                            let boundary = generateBoundaryString()
                            
                            let newParams = NSMutableDictionary()
                            newParams.setValue("", forKey: "")
                            newParams.setValue("", forKey: "")
                            newParams.setValue("", forKey: "")
                            
                            for (key,value) in params! {
                                newParams.setValue(value, forKey: key as! String)
                            }
                            
                            for (key, value) in newParams {
                                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.ascii)!)
                                data.append("\(value)".data(using: String.Encoding.ascii)!)
                                data.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.ascii)!)
                            }
                            
                            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                            
                            for i in 0..<(images?.count)! {
                                
                                let md = images?[i] as! NSMutableDictionary
                                
                                let param = md["param"] as! String
                                let image = md["image"] as! UIImage
                                
                                //print("Sourabh check image name----------->\(param)")
                                //print("Sourabh check image----------->\(image)")
                                
                                let image_data = image.pngData()
                                
                                print("image-\(param)-\(image)-\(String(describing: image_data?.count))-")
                                
                                let fname = "\(param).png"//png
                                
                                //filename
                                 //print("Sourabh 2 check image name----------->\(fname)")
                                
                                
                                data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                data.append("Content-Disposition: form-data; name=\"\(param)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
                                data.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
                                data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
                                
                                data.append(image_data!)
                                data.append("\r\n".data(using: String.Encoding.utf8)!)
                                
                                data.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
                            }
                        } else {
                            var str:NSString = ""
                            
                            for (key, value) in params! {
                                if (str.length == 0) {
                                    str = "\(key)=\(value)" as NSString
                                } else {
                                    str = "\(str)&\(key)=\(value)" as NSString
                                }
                            }
                            
                            data = str.data(using: String.Encoding.utf8.rawValue)
                        }
                        
                        request.httpBody = data
                    }
                } catch {
                    print("JSON serialization failed:  \(error)")
                }
                
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("\(data.count)", forHTTPHeaderField: "Content-Length")
            } else if (method == nil || params == nil || method == "GET") {
            }
            
            if header != nil {
                if (header?.count)! > 0 {
                    for (key,_) in header! {
                        request.setValue(header?.object(forKey: key) as? String, forHTTPHeaderField: "\(key)")
                    }
                }
            }
            
            var semaphore:DispatchSemaphore!
            
            if sync {
                semaphore = DispatchSemaphore(value: 0)
            }
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                
                let md = NSMutableDictionary()
                md["completionHandler"] = completionHandler
                
                if (data != nil) { md["data"] = data! as Data }
                if (response != nil) { md["response"] = response! as URLResponse }
                if (error != nil) { md["error"] = error! as Error}
                if (api != nil) { md["api"] = api! as String  }
                if (params != nil) { md["params"] = params! as NSMutableDictionary }
                if (method != nil) { md["method"] = method! as String }
                md["ai"] = ai as Bool
                md["popup"] = popup as Bool
                md["prnt"] = prnt as Bool
                
                if sync {
                    semaphore.signal()
                    self.jsonThread(md)
                } else {
                    self.performSelector(inBackground: #selector(self.jsonThread(_ :)), with: md)
                }
            });
            
            task.resume()
            
            if sync {
                _ = semaphore.wait(timeout: .distantFuture)
            }
        } else {
            if popup {
                alert("Network message!", "Please establish network connection.")
            }
        }
    }
    
    @objc func jsonThread(_ md:NSMutableDictionary) {
        let completionHandler = md["completionHandler"] as! ((Any?, NSMutableDictionary?) -> Swift.Void)
        
        var data:Data! = nil
        var response:URLResponse! = nil
        var error:Error! = nil
        var api:String! = nil
        var params:NSMutableDictionary! = nil
        
        if (md["data"] != nil) { data = md["data"] as? Data }
        if (md["response"] != nil) { response = md["response"] as? URLResponse }
        if (md["error"] != nil) { error = md["error"] as?Error }
        if (md["api"] != nil) { api = md["api"] as? String }
        if (md["params"] != nil) { params = md["params"] as? NSMutableDictionary }
        
        let ai = md["ai"] as! Bool
        let popup = md["popup"] as! Bool
        let prnt = md["prnt"] as! Bool
        
        if error != nil {
            if (api != nil) { print("api -\(api!)-") }
            if (params != nil) { print("params -\(params!)-") }
            if (error != nil) { print(error) }
            if (data != nil) { print("data -\(String(describing: NSString(data: data, encoding: String.Encoding.utf8.rawValue)))-") }
            if (response != nil) { print("response -\(response!)-") }
            
            if (popup) {
                self.alert("", kCouldnotconnect)
            }
            
            completionHandler(nil, params)
        } else {
            do {
                let parsedData:Any? = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                //Sourabh let parsedData:Any? = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Any
                
                
                if (prnt) {
                    if (api != nil) { print("api -\(api!)-") }
                    if (params != nil) { print("params -\(params!)-") }
                    if (parsedData != nil) { print("json -\(parsedData!)-") }
                }
                
                DispatchQueue.main.async {
                    completionHandler(parsedData, params)
                }
            } catch _ as NSError {
                if (api != nil) { print("api -\(api!)-") }
                if (params != nil) { print("params -\(params!)-") }
                if (error != nil) { print(error) }
                if (data != nil) { print("data -\(String(describing: NSString(data: data, encoding: String.Encoding.utf8.rawValue)))-") }
                if (response != nil) { print("response -\(response!)-") }
                
                if (popup) {
                    self.alert("", kCouldnotconnect)
                }
                completionHandler(nil, params)
            }
        }
        
        if (ai) {
            stopActivityIndicator ()
        }
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    class func startActivityIndicator () {
        self.performSelector(inBackground: #selector(Http.startActivityIndicatorThread), with: nil)
    }
    
    class func stopActivityIndicator () {
        self.performSelector(inBackground: #selector(Http.stopActivityIndicatorThread), with: nil)
    }
    
    func startActivityIndicator () {
        Http.startActivityIndicator ()
    }
    
    func stopActivityIndicator () {
        Http.stopActivityIndicator ()
    }
    
    @objc class func startActivityIndicatorThread () {
        ActivityIndicator.sharedInstance.showActivityIndicator()
    }
    
    @objc class func stopActivityIndicatorThread () {
        DispatchQueue.main.async {
            ActivityIndicator.sharedInstance.hideActivityIndicator()
        }
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func toast (_ view:UIView?, _ msg:String?) {
        
        if (view != nil && msg != nil) {
            let md = NSMutableDictionary()
            md["view"] = view
            md["msg"] = msg
            
            self.performSelector(inBackground: #selector(self.toastThread(_ :)), with: md)
        }
    }
    
    @objc func toastThread (_ md:NSMutableDictionary) {
        let view = md["view"] as! UIView
        let msg = md["msg"] as! String
        
        view.makeToast(message: msg)
    }
    
    func attributedString() {
        /*
         // 1
         let string = "Don't have an account? SIGN UP NOW!" as NSString
         
         //let string = "Testing Attributed Strings" as NSString
         var attributedString = NSMutableAttributedString(string: string as String)
         
         // 2
         let firstAttributes = [NSForegroundColorAttributeName: UIColor.blue, NSBackgroundColorAttributeName: UIColor.yellow, NSUnderlineStyleAttributeName: 1] as [String : Any]
         let secondAttributes = [NSForegroundColorAttributeName: UIColor.red,
         NSBackgroundColorAttributeName: UIColor.blue,
         NSStrikethroughStyleAttributeName: 1] as [String : Any]
         let thirdAttributes = [NSForegroundColorAttributeName: UIColor.green, NSBackgroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 40)]
         
         // 3
         //attributedString.addAttributes(firstAttributes, range: string.range(of: "Testing"))
         attributedString.addAttributes(secondAttributes, range: string.range(of: "SIGN UP NOW!"))
         //attributedString.addAttributes(thirdAttributes, range: string.range(of: "Strings"))
         
         // 4
         //myTestLabel.attributedText = attributedString
         */
    }
    
    func convertArrayToString (_ arr:NSMutableArray)  -> String {
        var str = "["
        
        for i in 0..<arr.count {
            let dt = arr[i] as! NSDictionary
            
            if (i == 0) {
                str = "\(str)\(convertDictToString(dt))"
            } else {
                str = "\(str), \(convertDictToString(dt))"
            }
        }
        
        str = "\(str)]"
        
        return str
    }
    
    func convertDictToString (_ dt: NSDictionary) -> String {
        var str = "{"
        
        for (key, value) in dt {
            if (str.count == 1) {
                str = "\(str)\(colon (key as! String)):\(colon (value as! String))"
            } else {
                str = "\(str), \(colon (key as! String)):\(colon (value as! String))"
            }
        }
        
        str = "\(str)}"
        
        return str
    }
    
    func colon (_ str:String) -> String {
        return "\"\(str)\""
    }
    
    class func alert (_ ttl:String?, _ msg:String?) {
        if (msg != nil) {
            if (msg?.count)! > 0 || (ttl?.count)! > 0{//Sourabh add ttl
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let alertController:UIAlertController
                    
                    var ttl = ttl
                    
                    if (ttl == nil) {
                        ttl = ""
                    }
                    
                    alertController = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
                    
                    let defaultActionq = UIAlertAction(title: "Ok", style: .default, handler: { (_ action:UIAlertAction) in
                        
                    })
                    
                    alertController.addAction(defaultActionq)
                    
                    //appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: { })
                }
            }
        }
    }
    
    func alert (_ ttl:String?, _ msg:String?) {
        Http.alert(ttl, msg)
    }
    
    class func alert (_ ttl:String?, _ msg:String?, _ btns:[Any]) {
        if (msg != nil) {
            if (msg?.count)! > 0 {
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    let alertController:UIAlertController
                    
                    var ttl = ttl
                    
                    if (ttl == nil) {
                        ttl = ""
                    }
                    
                    alertController = UIAlertController(title: ttl, message: msg, preferredStyle: .alert)
                    
                    if btns.count >= 2 {
                        alertController.addAction(self.alertAction(btns, 0))
                    }
                    
                    if btns.count >= 3 {
                        alertController.addAction(self.alertAction(btns, 1))
                    }
                    
                    //appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: { })
                }
            }
        }
    }
    
    class func alertFailed (_ json:NSDictionary?, _ key:String) {
        let message = json?[key] as! String?
        
        if message != "failed." {
            Http.alert("", json?[key] as! String?)
        } else {
            if let result = json?["result"] as? NSDictionary {
                var msg = ""
                
                let arr = result.allKeys
                
                for i in 0..<arr.count {
                    let key = arr[i] as? String
                    
                    if let keyArr = result[key!] as? NSArray {
                        for j in 0..<keyArr.count {
                            msg = keyArr[j] as! String
                            Http.alert("", msg)
                        }
                    }
                }
            }
        }
    }
    
    class func alertAction (_ btns:[Any], _ index:Int) -> UIAlertAction {
        let action = UIAlertAction(title: (btns[index + 1] as? String)!, style: .default, handler: { (_ action:UIAlertAction) in
            
            let vc = btns[0] as? UIViewController
            
            if index == 0 {
                vc?.alertZero()
            } else if index == 1 {
                vc?.alertOne()
            }
        })
        
        return action
    }
    
    class func currTime () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//.SSSZ"
        let date = Date()
        let str = dateFormatter.string(from: date)
        
        return str
    }
    
    func printTime () {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss.SSSSSSSSSSSS"
        
        print("-time----\(df.string(from: d))-")
    }
}

extension UIViewController {
    func alertZero () {
        
    }
    
    func alertOne () {
        
    }
}

// MARK: UIImageView

/*extension UIImageView {
    func saveImageDocumentDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("apple.jpg")
        let image = UIImage(named: "apple.jpg")
        print(paths)
        let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage () -> UIImage? {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("apple.jpg")
        
        if fileManager.fileExists(atPath: imagePAth) {
            return UIImage(contentsOfFile: imagePAth)
        } else {
            return nil
        }
    }
    
    func createDirectory() {
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        
        if !fileManager.fileExists(atPath: paths) {
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        } else {
            print("Already dictionary created.")
        }
    }
    
    func deleteDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        
        if !fileManager.fileExists(atPath: paths) {
            try! fileManager.removeItem(atPath: paths)
        } else {
            print("Something wronge.")
        }
    }
    
    func deleteFileForUrl (_ url:String?) {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(url!.imageName())
        
        let del:Bool = fileManager.fileExists(atPath: imagePAth)
        
        if del {
            try! fileManager.removeItem(atPath: imagePAth)
        } else {
            print("Something wronge.")
        }
    }
    
    func savedUIImageForUrl (_ url:String?, block: @escaping (UIImage?) -> Swift.Void) {
        
        if (url == nil) {
            block(nil)
        } else {
            let fileManager = FileManager.default
            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(url!.imageName())
            
            if fileManager.fileExists(atPath: imagePAth) {
                block(UIImage(contentsOfFile: imagePAth))
            } else {
                block(nil)
            }
        }
    }
    
    func savedUIImage (_ name:String?, block: @escaping (UIImage?) -> Swift.Void) {
        
        if (name == nil) {
            block(nil)
        } else {
            let fileManager = FileManager.default
            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(name!)
            
            if fileManager.fileExists(atPath: imagePAth) {
                block(UIImage(contentsOfFile: imagePAth))
            } else {
                block(nil)
            }
        }
    }
    
    func saveUIImage (_ name:String?, _ img:UIImage?) {
        if (name != nil && img != nil) {
            let data:Data? = UIImagePNGRepresentation(img!)!
            
            if (data != nil) {
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name!)
                
                fileManager.createFile(atPath: paths as String, contents: data, attributes: nil)
            }
        }
    }
    
    func saveUIImageForUrl (_ url:String?, _ img:UIImage?) {
        if (url != nil && img != nil) {
            let data:Data? = UIImagePNGRepresentation(img!)!
            
            if (data != nil) {
                let fileManager = FileManager.default
                let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(url!.imageName())
                
                fileManager.createFile(atPath: paths as String, contents: data, attributes: nil)
            }
        }
    }
    
    @objc func displayImage (_ dict:NSDictionary) {
        let boolCustomScale:Bool = dict["scale"] as! Bool
        
        if (boolCustomScale) {
            self.clipsToBounds = true;
            self.contentMode = .scaleAspectFill
        }
        
        let url:String = dict["url"] as! String
        
        let imgV = self as? ItemImageView
        
        if imgV != nil {
            if (imgV?.url.count)! > 0 {
                if imgV != nil {
                    
                    let imageUrl = imgV?.url[(imgV?.url.count)!-1]
                    
                    if imageUrl != nil {
                        if imageUrl! == url {
                            if let img = dict["image"] as? UIImage {
                                self.image = img
                            } else if let dimg = dict["dimage"] as? String {
                                self.image = UIImage(named: dimg)
                            }
                        }
                    }
                } else {
                    if let img = dict["image"] as? UIImage {
                        self.image = img
                    } else if let dimg = dict["dimage"] as? String {
                        self.image = UIImage(named: dimg)
                    }
                }
            }
        } else {
            if let img = dict["image"] as? UIImage {
                self.image = img
            } else if let dimg = dict["dimage"] as? String {
                self.image = UIImage(named: dimg)
            }
        }
        
        if let ai = dict["ai"] as? UIActivityIndicatorView {
            ai.isHidden = true
            ai.stopAnimating()
        }
    }
    
    func downloadUIImage1 (_ url:String?, block: @escaping (UIImage?) -> Swift.Void) {
        if ((url?.count)! > 0 && url != "") {
            self.savedUIImageForUrl(url, block: { (img) in
                if (img != nil) {
                    block(img)
                } else {
                    let urlL = URL(string: (url?.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)!)!
                    
                    let data = NSData(contentsOf: urlL as URL) as Data?
                    
                    var image:UIImage? = nil;
                    
                    if (data != nil) {
                        image = UIImage(data: data! as Data)
                        
                        if (image != nil) {
                            self.saveUIImageForUrl(url, image)
                        }
                    } else {
                        self.deleteFileForUrl(url)
                    }
                    
                    block(image)
                }
            })
        } else {
            block(nil)
        }
    }
    
    func downloadUIImage (_ url:String?, block: @escaping (UIImage?) -> Swift.Void) {
        let md = NSMutableDictionary()
        md["url"] = url
        md["block"] = block
        
        self.performSelector(inBackground: #selector(downloadUIImageThread (_ :)), with: md)
    }
    
    @objc func downloadUIImageThread (_ md:NSMutableDictionary) {
        let url:String? = md["url"] as? String
        let block = md["block"] as! (UIImage?) -> Swift.Void
        
        if ((url?.count)! > 0 && url != "") {
            self.savedUIImageForUrl(url, block: { (img) in
                if (img != nil) {
                    block(img)
                } else {
                    let urlL = URL(string: (url?.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!)!)!
                    
                    let data = NSData(contentsOf: urlL as URL) as Data?
                    
                    var image:UIImage? = nil;
                    
                    if (data != nil) {
                        image = UIImage(data: data! as Data)
                        
                        if (image != nil) {
                            self.saveUIImageForUrl(url, image)
                        }
                    } else {
                        self.deleteFileForUrl(url)
                    }
                    
                    block(image)
                }
            })
        } else {
            block(nil)
        }
    }
    
    func uiimage (_ url:String?, _ dImage:String?, _ boolScal:Bool, _ ai:UIActivityIndicatorView?) {
        if url != nil {
            if self is ItemImageView {
                let iiii = self as? ItemImageView
                iiii?.url.append(url!)
            }
        }
        
        if ai != nil {
            ai?.isHidden = false
            ai?.startAnimating()
        }
        
        var dImage = dImage
        
        if (dImage == nil) {
            dImage = "noimage.jpg";
            
            
        } else if (dImage?.count == 0) {
            dImage = "noimage.jpg";
            
        }
        
        if ((url?.count)! > 0 && url != "") {
            let url = url?.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
            
            let dict = NSMutableDictionary()
            
            dict["url"] = url
            dict["scale"] = boolScal
            
            if ai != nil {
                dict["ai"] = ai;
            }
            
            dict["dimage"] = dImage
            
            self.performSelector(inBackground: #selector(self.getNSetUIImagee(_ :)), with: dict)
        } else {
            self.image = UIImage(named: dImage!)
            
            if ai != nil {
                ai?.isHidden = true
                ai?.stopAnimating()
            }
        }
    }
    
    @objc func getNSetUIImagee (_ dict:NSDictionary) {
        let url:String = dict["url"] as! String
        
        self.downloadUIImage(url) { (image) in
            let dt = NSMutableDictionary()
            
            for (key, value) in dict {
                dt[key] = value
            }
            
            if (image != nil) {
                dt["image"] = image
            }
            
            self.performSelector(inBackground: #selector(self.displayImage(_:)), with: dt)
        }
    }
}*/

// MARK: extension UITextField

extension UITextField{
    func padding (_ pad:Int) {
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: pad, height: Int(self.frame.size.height)))
        self.leftView = paddingView;
        self.leftViewMode = UITextField.ViewMode.always
        //_tf.placeholder="Enter Name"
    }
}

// MARK: UIView

extension UIView {
    
    func border (_ color:UIColor?, _ cornerRadius:CGFloat, _ borderWidth:CGFloat) {
        self.layer.masksToBounds = true
        if (color != nil) { self.layer.borderColor = color?.cgColor }
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
    
    func shadowSubViews () {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
        
        // add the border to subview
        let borderView = UIView()
        borderView.frame = self.bounds
        borderView.layer.cornerRadius = 10
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 1.0
        borderView.layer.masksToBounds = true
        self.addSubview(borderView)
        
        // add any other subcontent that you want clipped
        let otherSubContent = UIImageView()
        //otherSubContent.image = UIImage(named: "lion")
        otherSubContent.frame = borderView.bounds
        borderView.addSubview(otherSubContent)
    }
    
    func shadow () {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = self.frame.size.height/4.0
        self.layer.masksToBounds = false
    }
}

// MARK: UIImage

extension UIImage {
    func resize(_ wth: CGFloat) -> UIImage {
        
        let scale = wth / self.size.width
        let newHeight = self.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: wth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: wth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func base64 (_ quality:CGFloat) -> String {
        /*let imgD1:Data?  = UIImageJPEGRepresentation(self, quality)! as Data
         let img1:UIImage = UIImage(data: imgD1!)!*/
        let imageData:NSData = self.pngData()! as NSData
        
        let bytes = Double(imageData.length)/8.0
        let kb = bytes/1024.0
        let mb = kb/1024.0
        
        print("imageData size-\(kb)-\(mb)-")
        
        let profilePicture = imageData.base64EncodedString(options: .lineLength64Characters)
        
        return profilePicture
    }
}

// MARK: UIColor

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    class func hexColor(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

class PredefinedConstants: NSObject {
    
    //Nunito Font
    static let fontNunitoRegular = "Nunito-Regular"
    static let fontNunitoBold = "Nunito-Bold"
    static let fontNunitoLight = "Nunito-Light"
    
    
    //About Device and App
    static let ScreenWidth =  UIScreen.main.bounds.width
    static let ScreenHeight =  UIScreen.main.bounds.height
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let userDeviceId = UIDevice.current.identifierForVendor!.uuidString
    static let deviceOSVersion = NSString(string: UIDevice.current.systemVersion).floatValue
    static let appVersion: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
    //static let GoogleAccount_Key = "AIzaSyAP_1vHk1kU3sq9ABZox-2vChSzGtlYQK8"
    static let GoogleAccount_Key = "AIzaSyAJWgv6m7oSA7Hd7nvx20JDM1HCfiFPOGQ"
    let Network_Error = "Problem retrieving data from server due to connectivity issue.";
    static let deviceType = "iphone"
    
     static let KeyInstabug =  "4d22041bcec3d415aba8afb0cc7ca417"
    
  //  static let Google_CLIENT_ID =  "com.googleusercontent.apps.966319062413-35ea1g170e1s3j67kbjkcmetr2j0mcjb"
    static let Google_CLIENT_ID =  "966319062413-35ea1g170e1s3j67kbjkcmetr2j0mcjb.apps.googleusercontent.com"
    
    let defEmailId = "EmailId"
    let defPassword = "Password"
    let defRememberMe = "IsRemberMe"
    //Default Namings.
    let defaultRememberMe = "rememberMe"
    let defaultEmail = "email"
    let defaultPassword = "password"
    let defaultBaseUrl = "baseUrl"
    
    //Default titles.
    let verifyMobile = "VERIFY MOBILE NUMBER"
    let myOrders = "MY ORDERS"
    let myOrderDetail = "ORDER DETAILS"
    
     let PassportCharcter = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    let emailAcceptableCharacter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-@"
    let AddressAcceptableCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,/- "
    let NameAcceptableCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
    let ZipCodeAcceptableCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    let StateCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 ."
    let phoneNoAcceptableCharacter = "1234567890."
    var dark_red = UIColor(red: 204, green: 19, blue: 18)
    var blue = UIColor(red: 71, green: 154, blue: 200)
    
    static func appColor() -> UIColor {
        return UIColor(red:0.08, green:0.77, blue:0.29, alpha:1.0)
    }
    static func appColorMain() -> UIColor {
        return UIColor(red:71/255, green:154/225, blue:200/225, alpha:1.0)
    }
    
    
    /***********sandeep Attributed string************/
    func sandeepAttributedString(strTitle:String,strResult:String, fontFirstName:String, fontSecondName:String , FirstFontSize : CGFloat, SceondFontSize : CGFloat,firstcolor:UIColor,secondcolor:UIColor) -> NSAttributedString {
        
        var myMutableString = NSMutableAttributedString()
        var myMutableString2 = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: strTitle, attributes: [NSAttributedString.Key.font:UIFont(name: fontFirstName, size: FirstFontSize)!, NSAttributedString.Key.foregroundColor: firstcolor])
        
        //Add more attributes here
        
        myMutableString2 = NSMutableAttributedString(string: strResult as String, attributes: [NSAttributedString.Key.font:UIFont(name: fontSecondName, size: SceondFontSize)!,NSAttributedString.Key.foregroundColor: secondcolor])
        
        
        
        myMutableString.append(myMutableString2)
        return myMutableString
        
    }
    func sandeepAttributedStringSqar(strTitle:String,strResult:String, fontFirstName:String, fontSecondName:String , FirstFontSize : CGFloat, SceondFontSize : CGFloat,firstcolor:UIColor,secondcolor:UIColor) -> NSAttributedString {
        
        var myMutableString = NSMutableAttributedString()
        var myMutableString2 = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: strTitle, attributes: [NSAttributedString.Key.font:UIFont(name: fontFirstName, size: FirstFontSize)!, NSAttributedString.Key.foregroundColor: firstcolor])
        
        //Add more attributes here
        
        myMutableString2 = NSMutableAttributedString(string: strResult as String, attributes: [NSAttributedString.Key.font:UIFont(name: fontSecondName, size: SceondFontSize)!,NSAttributedString.Key.foregroundColor: secondcolor])
        
        let font:UIFont? = UIFont(name: "Arial", size:14.0)
        let fontSuper:UIFont? = UIFont(name: "Arial", size:12.0)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: "M2", attributes: [.font:font!])
        attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:1,length:1))
        
        myMutableString2.append(attString)
        myMutableString.append(myMutableString2)
        return myMutableString
        
    }
}

func filterByPrice (_ ma:NSMutableArray,_ high:Bool) -> NSMutableArray {
    var swiftArray = ma as NSArray as! [Item]
    
    if high {
        swiftArray = swiftArray.sorted { $0.price < $1.price }
    } else {
        swiftArray = swiftArray.sorted { $0.price > $1.price }
    }
    
    return NSMutableArray(array: swiftArray)
}

//SOURABH
func arrayMutable (_ dict:NSMutableDictionary, _ key:String) -> NSMutableArray? {
    if let title = dict[key] as? NSMutableArray {
        return title
    } else {
        return nil
    }
}


func array (_ dict:NSDictionary, _ key:String) -> Array<Any>? {
    if let title = dict[key] as? Array<Any> {
        return title
    } else {
        return nil
    }
}

func dictionary (_ dict:NSDictionary, _ key:String) -> Dictionary<String, Any>? {
    if let title = dict[key] as? Dictionary<String, Any> {
        return title
    } else {
        return nil
    }
}

func string (_ dict:NSDictionary, _ key:String) -> String {
    if let title = dict[key] as? String {
        return "\(title)"
    } else if let title = dict[key] as? NSNumber {
        return "\(title)"
    } else {
        return ""
    }
}

func number (_ dict:NSDictionary, _ key:String) -> NSNumber {
    if let title = dict[key] as? NSNumber {
        return title
    } else if let title = dict[key] as? String {
        
        if let title1 = Int(title) as Int? {
            return NSNumber(value: title1)
        } else if let title1 = Float(title) as Float? {
            return NSNumber(value: title1)
        } else if let title1 = Double(title) as Double? {
            return NSNumber(value: title1)
        } else if let title1 = Bool(title) as Bool? {
            return NSNumber(value: title1)
        }
        
        return 0
    } else {
        return 0
    }
}

func bool (_ dict:NSDictionary, _ key:String) -> Bool {
    if let title = dict[key] as? Bool {
        return title
    } else {
        return false
    }
}

func niil (_ dict:NSDictionary, _ key:String) -> String? {
    if let title = dict[key] as? String {
        return title
    } else {
        return nil
    }
}

func nullToNil(value : AnyObject?) -> AnyObject? {
    if value is NSNull {
        return nil
    } else {
        return value
    }
}

func null(value : AnyObject?) -> Bool {
    if value == nil {
        return false
    } else if value is NSNull {
        return false
    } else {
        return true
    }
}
/*
func callNumber(_ phoneNumber:String) {
    if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        
        if (application.canOpenURL(phoneCallURL as URL)) {
            application.openURL(phoneCallURL as URL);
        
            
        } else {
            Http.alert("", "Phone call not available.")
        }
    } else {
        Http.alert("", "Phone call not available.")
    }
}*/

func getAddressOrLatLong (_ lat:NSNumber?, _ long:NSNumber?, _ addr:String?, _ prnt:Bool) -> (lat:String?, long:String?, address:String?) {
    let reach = Reachability.init(hostname: "google.com")
    
    if prnt {
        print("lat-\(String(describing: lat))-")
        print("long-\(String(describing: long))-")
        print("addr-\(String(describing: addr))-")
    }
    
    if lat == nil && long == nil && addr == nil {
        return (nil, nil, nil)
    } else {
        if (reach?.isReachable)! {
            var api = "https://maps.google.com/maps/api/geocode/json?sensor=false&"
            
            if lat != nil && long != nil {
                api = api + "latlng=\(lat!),\(long!)"
            } else if addr != nil {
                api = api + "address=\(addr!)"
            }
            
            if prnt {
                print("api-\(api)-")
            }
            
            do {
                let data = NSData(contentsOf: URL(string: api)!)
                
                if data != nil {
                    let json:NSDictionary? = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? NSDictionary
                    
                    if prnt {
                        print("json-\(String(describing: json))-")
                    }
                    
                    if json != nil {
                        
                        if json != nil {
                            let status = string(json!, "status")
                            
                            if status == "OK" {
                                if let results = json?["results"] as? NSArray {
                                    for i in 0..<results.count {
                                        if lat != nil && long != nil {
                                            if let dt = results[i] as? NSDictionary {
                                                let address = string(dt, "formatted_address")
                                                
                                                return (nil, nil, address)
                                            }
                                        } else if addr != nil {
                                            if let dt = results[i] as? NSDictionary {
                                                if let geometry = dt["geometry"] as? NSDictionary {
                                                    if let location = geometry["location"] as? NSDictionary {
                                                        let lat = string(location, "lat")
                                                        let lng = string(location, "lng")
                                                        
                                                        if lat.count > 0 && lng.count > 0 {
                                                            return (lat, lng, nil)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            } catch _ as NSError {
            }
        }
    }
    
    return (nil, nil, nil)
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func all(from date: Date) -> DateComponents {
        //print("self-\(self)-")
        //print("date-\(date)-")
        return Calendar.current.dateComponents([.year, .month, .hour, .day, .minute, .second], from: date, to: self)
        
        //return Calendar.current.dateComponents([.year, .month, .hour, .day, .minute, .second], from: date, to: self).second ?? 0
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func getStringDate(_ formate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: self)
    }
}

class ItemImageView: UIImageView {
    var url:[String] = []
}

class Item: NSObject {
    var price:Double = 0.0
}




