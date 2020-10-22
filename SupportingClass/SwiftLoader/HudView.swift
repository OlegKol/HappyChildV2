//
//  SourabhLoader.swift
//  Loader
//
//  Created by New on 25/10/16.
//  Copyright © 2016 Sourabh Pal. All rights reserved.
//

import UIKit

class HudView: UIView {
    
    class var sharedInstance: HudView {
        struct Singleton {
            static let instance = HudView(frame: CGRect(x: 0,y: 0,width: Config().width,height: Config().height))
        }
        return Singleton.instance
    }
    
    public struct Config {
        public var width : CGFloat = UIScreen.main.bounds.width
        public var height : CGFloat = UIScreen.main.bounds.height
        public init() {}
           }
    
    fileprivate func update() {
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        self.frame = CGRect(x: 0, y: 0, width: Config().width, height: Config().height)
    }
    
    
    open class func showActivityIndicator() {
        
            let currentWindow : UIWindow = UIApplication.shared.keyWindow!
            let LoaderView = HudView.sharedInstance
            // popUpView.removeAllViews(false)
            LoaderView.update()
            let viewCenter = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))//135,135
            //25 OCT 2016   viewCenter.setCornerRadiousAndBorder(UIColor.clear, borderWidth: 0.0)
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))//125
            img.image = UIImage.gif(name: "progress_loader")
            
            let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "progress_loader", withExtension: "gif")!)
            img.image = UIImage.gif(data: imageData)
            
            img.center = viewCenter.center
            viewCenter.addSubview(img)
            
            viewCenter.backgroundColor = UIColor.clear//Sourabh 11 july 2016...
            viewCenter.center = LoaderView.center
            
            viewCenter.transform = CGAffineTransform.identity.scaledBy(x: 5.0, y: 5.0)
            viewCenter.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                viewCenter.alpha = 1.0
                viewCenter.transform = CGAffineTransform.identity
            })
            LoaderView.addSubview(viewCenter)
            currentWindow.addSubview(LoaderView)
    }
    
    open class func hideActivityIndicator() {
        let LoaderView = HudView.sharedInstance
        let subView = LoaderView.subviews
        if subView.count > 0 {
            for views in subView {
                views.removeFromSuperview()
            }
        }
        LoaderView.removeFromSuperview()
        LoaderView.alpha = 1.0
    }
    
    fileprivate func removeAllViews(_ withAnimation: Bool) {
        let LoaderView = HudView.sharedInstance
        let subView = LoaderView.subviews
        if withAnimation {
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                LoaderView.alpha = 0.0
                subView[0].transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
                }, completion: { (completion) -> Void in
                    if subView.count > 0 {
                        for views in subView {
                            views.removeFromSuperview()
                        }
                    }
                    LoaderView.removeFromSuperview()
                    LoaderView.alpha = 1.0
            })
        } else {
            if subView.count > 0 {
                for views in subView {
                    views.removeFromSuperview()
                }
            }
            LoaderView.removeFromSuperview()
            LoaderView.alpha = 1.0
        }
        
    }
    
    fileprivate func setAnimationStateFrom(_ view1: UIView) {
        let layer: CALayer = view1.layer
        layer.transform = transform3d()
    }
    
    fileprivate func transform3d() -> CATransform3D {
        var transform: CATransform3D = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0.0, 200.0, 0.0)
        transform.m34 = 1.0/800.0
        transform = CATransform3DRotate(transform, CGFloat(70.0 * M_PI / 180.0), 1.0, 0.0, 0.0)
        let scale: CATransform3D = CATransform3DMakeScale(0.7, 0.7, 0.7)
        return CATransform3DConcat(transform, scale)
    }
    
    
}
