//
//  GenricViewController.swift
//  VegiDelivery
//
//  Created by Avinash somani on 13/10/16.
//  Copyright © 2016 Kavyasoftech. All rights reserved.
//

import UIKit

let api_NodeJS = "http://watchers.world:5000/" //Server URL 2 Jul 2019

//MARK:- NODE JS METHOD
let new_get_drivers_req = "new-get-drivers-req"// Emit
let new_get_drivers = "new-get-drivers"// Get
let accepted_ride = "accepted_ride"//Get
let start_ride_driver_data = "start_ride_driver_data"//Get

//let drivers_data_to_client = "drivers_data_to_client"
//************************* API_END ***************************

class Base: NSObject {
    
    func alertWindowDict( dict: NSDictionary,  str: String) {
        let alert = UIAlertController(title: "", message: string(dict, str), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func alertWindow(_ str: String) {
        let alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

class AppThemeColor: NSObject {
//    static let AppColor = UIColor(hex:"EFCE00")
 //   static let AppBlackColor = UIColor(hex:"2C2F32")
}

func dayshours (_ days:String, _ hours:String) -> String {
    var day:Int = 0
    
    if days.count > 0 {
        day = Int(days)!
    }
    
    var hour:Int = 0
    
    if hours.count > 0 {
        hour = Int(hours)!
    }
    
    if day > 1 {
        if hour > 1 {
            return "\(day) days \(hour) hours"
        } else {
            return "\(day) days \(hour) hour"
        }
    } else {
        if hour > 1 {
            return "\(day) day \(hour) hours"
        } else {
            return "\(day) day \(hour) hour"
        }
    }
}

func alertError (_ json:NSDictionary?) {
    let message = json?["message"] as! String?
    
    if message == "failed" {
        Http.alert("", json?["message"] as! String?)
    } else {
        if let result = json?["errors"] as? NSDictionary {
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

class tokenClass: NSObject {
}


func convertDateFormat(strDate: String, inputFormat: String, outputFormat: String) -> String {
    //"2017-03-30"; to "25-03-2017"
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.date(from: strDate)
    
    formatter.dateFormat = "dd-MM-yyyy"
    
    var str = ""
    
    if date == nil {
        str = formatter.string(from: Date())
        
    } else {
        str = formatter.string(from: date!)
    }
    print("date befor and after conversion-=-=    \(strDate) ====== \(str)")
    return str
}

extension Float {
    
    func getStringWith2Decimals() -> String {
        return String(format: "%.2f", self)
    }
}
extension CGFloat {
    
    func getStringWith2Decimals() -> String {
        return String(format: "%.2f", self)
    }
}

extension UITableView {
    
    func displayBackgroundText(text: String, fontStyle: String, fontSize: CGFloat) {
        let lblRahul = UILabel();
        
        if let headerView = self.tableHeaderView {
            lblRahul.frame = CGRect(x: 0, y: headerView.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height - headerView.bounds.size.height)
        } else {
            lblRahul.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        }
        lblRahul.text = text;
        lblRahul.textColor = UIColor.black;
        lblRahul.numberOfLines = 0;
        lblRahul.textAlignment = .center;
        lblRahul.font = UIFont(name: fontStyle, size:fontSize);
        
        let backgroundViewRahul = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewRahul.addSubview(lblRahul);
        self.backgroundView = backgroundViewRahul;
    }
    
    func displayBackgroundText(text: String, fontStyle: String) {
        let lblRahul = UILabel();
        
        if let headerView = self.tableHeaderView {
            lblRahul.frame = CGRect(x: 0, y: headerView.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height - headerView.bounds.size.height)
        } else {
            lblRahul.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        }
        lblRahul.text = text;
        lblRahul.textColor = UIColor.black;
        lblRahul.numberOfLines = 0;
        lblRahul.textAlignment = .center;
        lblRahul.font = UIFont(name: fontStyle, size:18);
        
        let backgroundViewRahul = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewRahul.addSubview(lblRahul);
        self.backgroundView = backgroundViewRahul;
    }
    
    func displayBackgroundText(text: String) {
        let lblRahul = UILabel();
        
        if let headerView = self.tableHeaderView {
            lblRahul.frame = CGRect(x: 0, y: headerView.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height - headerView.bounds.size.height)
        } else {
            lblRahul.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        }
        lblRahul.text = text;
        lblRahul.textColor = UIColor.gray;
        lblRahul.numberOfLines = 0;
        lblRahul.textAlignment = .center;
        lblRahul.font = UIFont(name: "Montserrat-Regular", size:18);
        //lblRahul.sizeToFit();
        
        let backgroundViewRahul = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewRahul.addSubview(lblRahul);
        self.backgroundView = backgroundViewRahul;
    }
}
