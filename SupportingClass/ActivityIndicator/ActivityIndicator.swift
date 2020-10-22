import Foundation
import UIKit

/*class ActivityIndicator1 {
    var container: UIView? = nil
    var loadingView: UIView? = nil
    var activityIndicator: UIActivityIndicatorView? = nil
    
    static let sharedInstance: ActivityIndicator = { ActivityIndicator() }()
    
    var appDelegate:UIApplicationDelegate? = nil
    
    let lockQueue = DispatchQueue.init(label: "com.kavya.LockQueue.ActivityIndicator")
    var noofrequest = 0
    var indicatorView = DotActivityIndicatorView()//Sourabh
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.lockQueue.sync {
                if self.noofrequest == 0 {
                    
                    if self.container == nil {
                        self.container = UIView()
                    }
                    
                    if self.loadingView == nil {
                        self.loadingView = UIView()
                    }
                    
                    if self.activityIndicator == nil {
                        self.activityIndicator = UIActivityIndicatorView()
                    }
                    
                    if self.appDelegate == nil {
                        self.appDelegate = UIApplication.shared.delegate
                    }
                    
                    self.container?.frame = (self.appDelegate?.window??.frame)!
                    self.container?.center = (self.appDelegate?.window??.center)!
                    
                    self.container?.backgroundColor = self.UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
                    
                    self.loadingView?.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
                    self.loadingView?.center = (self.appDelegate?.window??.center)!
                    self.loadingView?.backgroundColor = self.UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
                    self.loadingView?.clipsToBounds = true
                    self.loadingView?.layer.cornerRadius = 10
                    
                    self.activityIndicator?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                    self.activityIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
                    self.activityIndicator?.center = CGPoint(x: (self.loadingView?.frame.size.width)! / 2, y: (self.loadingView?.frame.size.height)! / 2)
                    
                    //========== SOurabh ========
                    
                    self.indicatorView.frame.origin.y = (self.loadingView?.frame.size.height)! / 2 - 30
                    self.indicatorView.frame.origin.x = (self.loadingView?.frame.size.width)! / 2 - 30
                    let dotParms = DotActivityIndicatorParms()
                    dotParms.activityViewWidth = self.indicatorView.frame.size.width;
                    dotParms.activityViewHeight = self.indicatorView.frame.size.height;
                    dotParms.numberOfCircles = 3;
                    dotParms.internalSpacing = 3;
                    dotParms.animationDelay = 0.2;
                    dotParms.animationDuration = 0.6;
                    dotParms.animationFromValue = 0.3;
                    dotParms.isDataValidationEnabled = true;
                    self.indicatorView.tag = 99
                    self.indicatorView.startAnimating()
                    
                    //==============
                    
                    
                    
                    self.loadingView?.addSubview(self.indicatorView)
                    
                    
                    self.loadingView?.addSubview(self.activityIndicator!)
                    
                    
                    self.container?.addSubview(self.loadingView!)
                    self.appDelegate?.window??.addSubview(self.container!)
                    self.activityIndicator?.startAnimating()
                }
                
                self.noofrequest += 1
            }
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.global().async {
            while self.noofrequest == 0 {
                sleep(1)
            }
            
            DispatchQueue.main.async {
                self.lockQueue.sync {
                    
                    if self.noofrequest == 1 {
                        self.activityIndicator?.stopAnimating()
                        self.container?.removeFromSuperview()
                    }
                    
                    if self.noofrequest > 0 {
                        self.noofrequest -= 1
                    }
                }
            }
        }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
*/

class ActivityIndicator {
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    
    static let sharedInstance: ActivityIndicator = { ActivityIndicator() }()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var indicatorView = DotActivityIndicatorView()//Sourabh
    func showActivityIndicator() {
        
      //  container.frame = (appDelegate.window?.frame)!
       // container.center = (appDelegate.window?.center)!
        
        container.backgroundColor = UIColor.clear.withAlphaComponent(0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
     //   loadingView.center = (appDelegate.window?.center)!
        loadingView.backgroundColor = UIColor.clear
        
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        //========== SOurabh ========
        
        indicatorView.frame.origin.y = loadingView.frame.size.height / 2 - 30
        indicatorView.frame.origin.x = loadingView.frame.size.width / 2 - 30
        let dotParms = DotActivityIndicatorParms()
        dotParms.activityViewWidth = indicatorView.frame.size.width;
        dotParms.activityViewHeight = indicatorView.frame.size.height;
        dotParms.numberOfCircles = 3;
        dotParms.internalSpacing = 3;
        dotParms.animationDelay = 0.2;
        dotParms.animationDuration = 0.6;
        dotParms.animationFromValue = 0.3;
        dotParms.isDataValidationEnabled = true;
        indicatorView.tag = 99
        indicatorView.startAnimating()
        
        DispatchQueue.main.async {
            self.loadingView.addSubview(self.indicatorView)
            
            self.container.addSubview(self.loadingView)
          //  self.appDelegate.window?.addSubview(self.container)
            // self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        
        OperationQueue.main.addOperation { //1212121212121212
            self.indicatorView.stopAnimating()//Sourabh
            // activityIndicator.stopAnimating()
            self.container.removeFromSuperview()
        }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}


