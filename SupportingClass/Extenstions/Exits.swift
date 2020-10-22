//
//  Exits.swift
//  PlanMyParty
//
//  Created by vishal gupta on 05/07/17.
//  Copyright © 2017 hp. All rights reserved.
//

import UIKit

class Exits: NSObject {

}
struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_7          = IS_IPHONE_6
    static let IS_IPHONE_7P         = IS_IPHONE_6P
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO_9_7      = IS_IPAD
    static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_TV                = UIDevice.current.userInterfaceIdiom == .tv
    static let IS_CAR_PLAY          = UIDevice.current.userInterfaceIdiom == .carPlay
    
    
    static let IS_IPHONE_X        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812
    
   
    
}

struct Version{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
}

extension NSMutableDictionary {
    func convertToString () -> String {
        do {
            let jsonData: NSData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
            
            let str = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            
            return str.replacingOccurrences(of: "\n", with: "")
        } catch {
            
        }
        
        return "[]"
    }
}
extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}
extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
import Social
import UIKit
public protocol SocialMediaShareable {
    func image() -> UIImage?
    func url() -> URL?
    func text() -> String?
}
public class SocialMediaSharingManager {
    public static func shareOnFacebook(object: SocialMediaShareable, from presentingVC: UIViewController) {
        share(object: object , for: SLServiceTypeFacebook, from: presentingVC)
    }
    public static func shareOnTwitterData(object: SocialMediaShareable, from presentingVC: UIViewController) {
        share(object: object, for: SLServiceTypeTwitter, from: presentingVC)
    }
    private static func share(object: SocialMediaShareable, for serviceType: String, from presentingVC: UIViewController) {
        if let composeVC = SLComposeViewController(forServiceType:serviceType) {
            composeVC.add(object.image())
            composeVC.add(object.url())
            composeVC.setInitialText(object.text())
            presentingVC.present(composeVC, animated: true, completion: nil)
        }
    }
}

extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}




/////////===========+Extension.........Neeleshwarim 31MAY 2018 updatess
//================*******************************================================
//extension work Here ===========================.....Neeleshwari
func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
}

///=======================================Neeleshwari

//MARK:- HEX_COLOR_CODE
/*
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}*/

class appColor: NSObject {
    static let redColor = UIColor(rgb: 0xB62625)
    static let schedule_color = UIColor(rgb: 0x3C9EF3)
    static let orange = UIColor(rgb: 0xfd8469)
    static let green = UIColor(rgb: 0x00c72a)
    static let red = UIColor(rgb: 0xd90000)
    static let blue = UIColor(rgb: 0x0000FF)
    static let light_black = UIColor(rgb: 0xa9a9a9)
    static let light_blue = UIColor(rgb: 0x3C9EF3)
}
extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: 1.0
        )
    }
}

//MARK:- SET_BACK_BUTTON_VIEW_CONTOLLER
extension UIViewController {
    
    func setRedBackButton() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back-arrow")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackButton")
    }
    
    func setBackButtonNil() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage()
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
    }
    
    func setWhiteBackButton() {
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic_arrow_back_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackButton")
    }
    
}
//MARK:- SET_MENU_BUTTON_VIEW_CONTOLLER
extension UIViewController {
    
    func setTransparentBg() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
    }
    
    func newTransperntNavigation() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    
    
}

//MARK:- SET_MENU_BUTTON_VIEW_CONTOLLER
extension UIViewController {
    
    func setMenuButton() {
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "MenuButton")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "MenuButton")
    }
}


extension UIViewController {
    
    func setNavigationViewDefault(className:String) {
        
        self.navigationItem.title = className
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.black//UIColor(named:"appTheme")
       /// self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationItem.hidesBackButton = false
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
     self.navigationController?.navigationBar.isTranslucent = false
    
    }
}

extension UIViewController {
    
     func setNavigationAppThemeWowVenue(className:String) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.black//UIColor(named: "appTheme")  //appColor.appThemeGreenColor
        self.navigationController?.navigationBar.isTranslucent = false
        
        let titleViewNav = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 100, height: 40))
        let lbl1 = UILabel(frame: CGRect.init(x: 0 , y: 0, width: view.frame.size.width - 100, height: 40))
        lbl1.text = className
        lbl1.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl1.textColor = UIColor.white
        lbl1.textAlignment = .center
        lbl1.numberOfLines = 1
        titleViewNav.addSubview(lbl1)
        self.navigationItem.titleView = titleViewNav
    }

}

extension UIViewController {
   
    func setNavTransparent(className:String)  {
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.tintColor = UIColor.yellow//UIColor(named: "redColor") //appColor.redColor //UIColor.black
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
       navigationController?.navigationBar.isTranslucent = true
        
        let titleViewNav = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 100, height: 40))
        let lbl1 = UILabel(frame: CGRect.init(x: 0 , y: 0, width: view.frame.size.width - 100, height: 40))
        lbl1.text = className
        lbl1.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl1.textColor = UIColor.black//UIColor(named: "redColor")  //appColor.redColor//UIColor.black
        lbl1.numberOfLines = 1
        lbl1.textAlignment = .center
        titleViewNav.addSubview(lbl1)
        //titleViewNav.backgroundColor = UIColor.yellow
        self.navigationItem.titleView = titleViewNav
    }
    
    func setNavTransparenthhfg(className:String)  {
        //let navigationBarAppearace = UINavigationBar.appearance()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .red
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
     //   self.navigationController?.navigationBar.topItem?.title = className
        
        let titleViewNav = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 100, height: 40))
        let lbl1 = UILabel(frame: CGRect.init(x: 0 , y: 0, width: view.frame.size.width - 100, height: 40))
        lbl1.text = className
        lbl1.font = UIFont.boldSystemFont(ofSize: 16.0)
        lbl1.textColor = UIColor.white//UIColor(named: "redColor")  //appColor.redColor//UIColor.black
        lbl1.numberOfLines = 1
        lbl1.textAlignment = .center
        titleViewNav.addSubview(lbl1)
        //titleViewNav.backgroundColor = UIColor.yellow
        self.navigationItem.titleView = titleViewNav
    }
    /*
     self.navigationController?.navigationBar.isTranslucent = true
     self.navigationController?.navigationBar.backgroundColor = .clear
     self.navigationController?.navigationBar.tintColor = .red
     self.navigationController?.navigationBar.barTintColor = .clear
     self.navigationController?.navigationBar.shadowImage = UIImage()
     self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
     
     self.title = "Neeleshwari"
     self.navigationController?.navigationBar.topItem?.title = "asdfkjdksfjk"
     self.navigationController?.navigationItem.title = "nnnnn"
     */
}


func SourabhisValidEmail(testStr:String) -> Bool {
    print("validate email: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func setPaddingWithRightImage(image: UIImage, textField: UITextField){
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    imageView.frame = CGRect(x: 10.0, y: 13.0, width: 20.0, height: 20.0)
    //For Setting extra padding other than Icon.
    let seperatorView = UIView(frame: CGRect(x: 40, y: 0, width: 0, height: 40))
    seperatorView.backgroundColor = UIColor.clear
    view.addSubview(seperatorView)
    textField.leftViewMode = .always
    view.addSubview(imageView)
    view.backgroundColor = .clear
    //   textField.leftViewMode = UITextFieldViewMode.always/Users/kavyamacmini2/Desktop/Neeleshwari_WorkSpace/Projects/VegiDelivery_work/VegiDelivery/VegiDelivery/Classes/Home/HomeVC.swift
    // textField.leftView = view
    textField.rightViewMode = UITextField.ViewMode.always
    textField.rightView = view
    
}
///////////////////////////////////////setPaddingWithLeftImage

func setPaddingWithLeftImage(image: UIImage, textField: UITextField){
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
    imageView.frame = CGRect(x: 5.0, y: 5.0, width: 20.0, height: 20.0)
    //For Setting extra padding other than Icon.
    let seperatorView = UIView(frame: CGRect(x: 40, y: 0, width: 0, height: 40))
    seperatorView.backgroundColor = UIColor.clear
    view.addSubview(seperatorView)
    textField.leftViewMode = .always
    view.addSubview(imageView)
    view.backgroundColor = .clear
    textField.leftViewMode = UITextField.ViewMode.always
    textField.leftView = view
    //    textField.rightViewMode = UITextFieldViewMode.always
    //    textField.rightView = view
}
///////////////////////////////////////setPaddingWithLeftImage

extension String {
    
    func stringHeightWithFontSize(_ fontSize: CGFloat,width: CGFloat) -> CGFloat {
        let font = UIFont(name: UIView.hr_toastFontName(), size: HRToastFontSize)
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.font:font!,
                          NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
}

func isNumberOrEmail(testString: String) -> String {
    let number = Double(testString)
    
    if number == nil {
        return "email"
    } else {
        return "number"
    }
}


extension UIView {
    func addBottomBorder(color: UIColor, height: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                toItem: nil,
                                                attribute: NSLayoutConstraint.Attribute.height,
                                                multiplier: 1, constant: height))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.leading,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              relatedBy: NSLayoutConstraint.Relation.equal,
                                              toItem: self,
                                              attribute: NSLayoutConstraint.Attribute.trailing,
                                              multiplier: 1, constant: 0))
    }
    
}

//================*******************************================================

//====================================Neeleshwari++++++++++++++++++++

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

//====================================Neeleshwari++++++++++++++++++++

extension UIButton{
    
    func roundedButtonRightTopCorner(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [ .topRight],
                                     cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedButtonLeftTopCorner(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft ],
                                     cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
//Neeleshwari--- 18/06/2018
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
}
//Neeleshwari______20June

extension UILabel {
    func setTextWithImage(image: UIImage, with text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: 18, height: 15)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        
        let textString = NSAttributedString(string: text, attributes: [.font: self.font])
        mutableAttributedString.append(attachmentStr)
        mutableAttributedString.append(textString)
        self.attributedText = mutableAttributedString
    }
    
    func setImageAndText(strText: String, image: UIImage) {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: 18, height: 15)
        let attachmentStr = NSAttributedString(attachment: attachment)
        
        let mutableAttributedString = NSMutableAttributedString()
        
        let textString = NSAttributedString(string: strText, attributes: [.font: self.font])
        mutableAttributedString.append(textString)
        mutableAttributedString.append(attachmentStr)
        
        self.attributedText = mutableAttributedString
    }
}


//MARK: TEXTFIELD EXTENSION
extension UITextField {
    @IBInspectable var doneAccessory: Bool {
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        //doneToolbar.barTintColor = appColor.defaultColor
        doneToolbar.isTranslucent = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        
        let close: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = appColor.redColor
        close.tintColor = appColor.redColor
        
        //done.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Muli-SemiBold", size: 18.0)!], for: .normal)
        //close.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Muli-SemiBold", size: 18.0)!], for: .normal)
        
        let items = [close ,flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

//MARK: WINDOW_ALERT
func alertWindowDict( dict: NSDictionary,  str: String) {
    let alert = UIAlertController(title: "", message: string(dict, str), preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindow.Level.alert + 1;
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
}

func alertWindow(_ str: String) {
    let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
    
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindow.Level.alert + 1;
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
}


//UTC TO LOCALE
//MARK: Time & Date Convert
func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = toFormat
    
    return dateFormatter.string(from: dt!)
}

func stringToDate(_ str: String) -> Date {
    let isoDate = str
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    let date = dateFormatter.date(from:isoDate)!
    return date
}
class EncodeDecodeString {
    func stringDecode(_ s: String) -> String? {
        if let data = s.data(using: .utf8) {
            return String(data: data, encoding: .nonLossyASCII)
        }
        return "\(s)"
    }
    
    func stringEncode(_ s: String) -> String {
        if let data = s.data(using: .nonLossyASCII, allowLossyConversion: true) {
            return String(data: data, encoding: .utf8)!
        }else {
            return s
        }
    }
}

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

@IBDesignable class DottedVertical: UIView {
    
    @IBInspectable var dotColor: UIColor = UIColor.darkGray
    @IBInspectable var lowerHalfOnly: Bool = false
    
    override func draw(_ rect: CGRect) {
        
        // say you want 8 dots, with perfect fenceposting:
        let totalCount = 8 + 8 - 1
        let fullHeight = bounds.size.height
        let width = bounds.size.width
        let itemLength = fullHeight / CGFloat(totalCount)
        
        let path = UIBezierPath()
        
        let beginFromTop = CGFloat(0.0)
        let top = CGPoint(x: width/2, y: beginFromTop)
        let bottom = CGPoint(x: width/2, y: fullHeight)
        
        path.move(to: top)
        path.addLine(to: bottom)
        
        path.lineWidth = width
        
        let dashes: [CGFloat] = [itemLength, itemLength]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        
        dotColor.setStroke()
        path.stroke()
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func capFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capFirst() {
        self = self.capFirstLetter()
    }
    
    func converDate(_ from:String, _ to:String) -> String {
        if self.count == 0 {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        if let myDate:Date? = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = to
            
            if myDate == nil {
                return ""
            } else {
                return dateFormatter.string(from: myDate!)
            }
        } else{
            return ""
        }
        
        
        
    }
    
    func getDate(_ formate:String) -> Date {
        if self.count == 0 {
            return Date()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.date(from: self)!
    }
    
    func imageName () -> String {
        var name = self.replacingOccurrences(of: ".", with: "_")
        name = name.replacingOccurrences(of: "?", with: "_")
        name = name.replacingOccurrences(of: "=", with: "_")
        name = name.replacingOccurrences(of: ":", with: "_")
        name = name.replacingOccurrences(of: "//", with: "_")
        name = name.replacingOccurrences(of: "/", with: "_")
        name = name.replacingOccurrences(of: "-", with: "_")
        name = name.replacingOccurrences(of: "", with: "_")
        name = "\(name).jpg"
        
        let arr = name.components(separatedBy: "_")
        
        if arr.count > 0 {
            let divide:Int = Int(arr.count / 2);
            
            if (divide <= 0) {
                return name
            } else {
                var newName = ""
                
                for i in divide..<arr.count {
                    newName = "\(newName)\(arr[i])"
                }
                
                return newName
            }
        }
        
        return ""
    }
    
    func subString (_ str:String) -> Bool {
        if self.range(of: str) != nil {
            return true
        }
        
        return false
    }
    
    func subInSensetive (_ str:String) -> Bool {
        if (self.range(of: str, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil) {
            return true
        }
        
        return false
    }
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func validate(_ phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    func getDateFromUTC (_ formate:String) -> String {
        let dateUTC = self.getDate(formate)
        
        let timeZoneLocal = NSTimeZone.local as TimeZone?
        
        let newDate = Date(timeInterval: TimeInterval((timeZoneLocal?.secondsFromGMT(for: dateUTC))!), since: dateUTC)
        
        return newDate.getStringDate(formate)
    }
}

