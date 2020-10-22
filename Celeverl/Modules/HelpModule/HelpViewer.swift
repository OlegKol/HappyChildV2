//
//  DocumentViewer.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public class HelpViewer: UIViewController, HelpViewerProtocol, WKNavigationDelegate {
   
    public var interactor: HelpInteractorProtocol?
    
    public func updatePage(_ data: HelpModel) {
        DispatchQueue.main.async {
            if data.Phone != nil {
                self.phoneTitleView.text = "Телефон поддержки: \(data.Phone!)"
            }
            if data.HelpPage != nil, let url = URL(string: data.HelpPage!) {
                self.updatePageState(true)
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }
    }
    
    public func updatePageState(_ state: Bool) {
        DispatchQueue.main.async {
            if (state) {
                self.busyView.startAnimating()
            }
            else {
                self.busyView.stopAnimating()
            }
        }
    }
    
    private let busyView: UIActivityIndicatorView = {
       var activity = UIActivityIndicatorView()
       activity.style = .large
       activity.color = .white
       activity.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.85)
       return activity
    }()
    private let phoneTitleView: UILabel = {
       var label = UILabel()
       label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 14)
       label.textColor = .black
       return label
    }()
    private let webView: WKWebView = {
        var web = WKWebView()
        return web
    }()
       
    override public func loadView() {
       super.loadView()
       self.configuareView()
    }
       
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactor?.loadData()
    }

    private func configuareView(){
        self.configuareWebView()
        self.configuareBusyStatePageView()
    }
    
    private func configuareDocumentTitleView(){
        self.view.addSubview(self.phoneTitleView)
        self.phoneTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.phoneTitleView.text = "Телефон поддержки:"
        self.phoneTitleView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
        self.phoneTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
    }
    
    private func configuareBusyStatePageView(){
        self.view.addSubview(self.busyView)
        self.busyView.translatesAutoresizingMaskIntoConstraints = false
        self.busyView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.busyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.busyView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.busyView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
    }
    
    private func configuareWebView(){
        self.view.addSubview(self.webView)
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.webView.navigationDelegate = self
    }
    
    public func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
        if webView == self.webView {
            self.updatePageState(false)
        }
    }
    
}
