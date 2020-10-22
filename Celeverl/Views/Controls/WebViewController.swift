//
//  WebViewController.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/29/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public class WebViewController: UIViewController, WKNavigationDelegate {
    
    private var webView:WKWebView = {
        var view = WKWebView()
        view.backgroundColor = .systemBlue
        return view
    }()
    private let busyView: UIActivityIndicatorView = {
       var activity = UIActivityIndicatorView()
       activity.style = .large
       activity.color = .white
       activity.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.85)
       return activity
    }()
    
    public var url:String = "" {
        didSet{
            self.updatePage()
        }
    }
    
    override public func loadView() {
        super.loadView()
        self.configuareView()
    }
    
    func configuareView(){
        self.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.webView.navigationDelegate = self
        
        self.view.addSubview(self.busyView)
        self.busyView.translatesAutoresizingMaskIntoConstraints = false
        self.busyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.busyView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.busyView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.busyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func updatePage(){
        if let url = URL(string: self.url) {
            DispatchQueue.main.async {
                self.busyView.startAnimating()
            }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    
    public func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        DispatchQueue.main.async {
            if webView == self.webView {
                self.busyView.stopAnimating()
            }
        }
    }
    
}
