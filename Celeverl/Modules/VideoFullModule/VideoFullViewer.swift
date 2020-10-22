//
//  VideoFullViewer.swift
//  
//
//  Created by Евгений on 12/18/19.
//

import Foundation
import UIKit
import AVFoundation

//MARK: - VideoFullViewer
public class VideoFullViewer: UIViewController, FullVideoViewerProtocol{
    
    //MARK: - FullVideoViewerProtocol implementation
    public var interactor: FullVideoInteractorProtocol?
    
    //MARK: - Properties
    var tabBarPanel: AppSecondBarPanel = {
        var panel = AppSecondBarPanel()
        return panel
    }()
    var videoPlayer: AppPlayer = {
        var player = AppPlayer()
        player.backgroundColor = .red
        return player
    }()
    var titleView: UILabel = {
        var label = UILabel()
        return label
    }()
    var descriptionView: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 12)
        label.textColor = AppConstants.APP_DEFAULT_GRAY_COLOR
        return label
    }()
    var statusCameraView: AppErrorView = {
        var error = AppErrorView()
        error.denyTextColor = UIColor.black
        return error
    }()
    var settingsView: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
        label.textColor = .black
        return label
    }()
    var firstNotification: AppSelectedExtendedView = {
        var view = AppSelectedExtendedView()
        return view
    }()
    var secondNotification: AppSelectedExtendedView = {
        var view = AppSelectedExtendedView()
        return view
    }()
    var footerTitleView: UILabel = {
           var label = UILabel()
           return label
    }()
    var cameraSettingView: AppRadioExtendedView = {
        var view = AppRadioExtendedView()
        return view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override public func loadView(){
        super.loadView()
        self.interactor?.loadDefaultData()
        self.configureController()
    }
    
    //MARK: - configaure Views
    func configureController(){
        self.configaureBarPanel()
        self.configuareVideoPalyer()
        self.configuareTitle()
        self.configuareStatus()
        self.configuareDescription()
        self.configuareSetting()
        self.configuareFirstNotification()
        self.configuareSecondNotification()
        self.configuareFooterTitle()
        self.configuareCameraSetting()
    }
    
    func configaureBarPanel() {
        self.view.addSubview(self.tabBarPanel)
        
        self.tabBarPanel.translatesAutoresizingMaskIntoConstraints = false
        self.tabBarPanel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tabBarPanel.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tabBarPanel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tabBarPanel.heightAnchor.constraint(equalToConstant: self.view.safeAreaLayoutGuide.layoutFrame.size.height +  UIScreen.main.bounds.height * 0.08).isActive = true
        self.tabBarPanel.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.tabBarPanel.leftViewCommand = {(view) in
            self.interactor?.closePage()
        }
    }
    
    func configuareVideoPalyer() {
        self.view.addSubview(self.videoPlayer)
        self.videoPlayer.translatesAutoresizingMaskIntoConstraints = false
        self.videoPlayer.topAnchor.constraint(equalTo: self.tabBarPanel.bottomAnchor).isActive = true
        self.videoPlayer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.videoPlayer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.videoPlayer.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 9 / 16).isActive = true
        self.videoPlayer.url = URL(string: (self.interactor?.cameraModel!.Url)!)!
    }
    
    
    func configuareTitle() {
        self.titleView.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
        self.titleView.textColor = .black
        self.view.addSubview(self.titleView)
        
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.titleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        self.titleView.topAnchor.constraint(equalTo: self.videoPlayer.bottomAnchor, constant: 15).isActive = true
        self.titleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.titleView.text = "Камера 1"
    }
    
    func configuareStatus(){
        self.view.addSubview(self.statusCameraView)
        
        self.statusCameraView.translatesAutoresizingMaskIntoConstraints = false
        self.statusCameraView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.statusCameraView.topAnchor.constraint(equalTo: self.videoPlayer.bottomAnchor, constant: 15).isActive = true
        self.statusCameraView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15).isActive = true
        self.statusCameraView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.statusCameraView.showDenyStatus()
    }
    
    func configuareDescription() {
        
        self.view.addSubview(self.descriptionView)
        
        self.descriptionView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.descriptionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.descriptionView.topAnchor.constraint(equalTo: self.statusCameraView.bottomAnchor, constant: 5).isActive = true
        self.descriptionView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.descriptionView.text = "Камера в детской. Камера с угом обзора 360"
        self.descriptionView.numberOfLines = 1
        self.descriptionView.lineBreakMode = .byCharWrapping
    }
    
    func configuareSetting(){
       
        self.view.addSubview(self.settingsView)
        
        self.settingsView.translatesAutoresizingMaskIntoConstraints = false
        self.settingsView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        self.settingsView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        self.settingsView.topAnchor.constraint(equalTo: self.descriptionView.bottomAnchor, constant: 10).isActive = true
        self.settingsView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.settingsView.text = "Настройки уведомлений:"
        self.settingsView.numberOfLines = 1
        self.settingsView.lineBreakMode = .byCharWrapping
    }
    
    func configuareFirstNotification(){
        self.view.addSubview(firstNotification)
        
        firstNotification.translatesAutoresizingMaskIntoConstraints = false
        firstNotification.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        firstNotification.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        firstNotification.topAnchor.constraint(equalTo: self.settingsView.bottomAnchor, constant: 10).isActive = true
        firstNotification.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func configuareSecondNotification(){
        self.view.addSubview(secondNotification)
        
        secondNotification.translatesAutoresizingMaskIntoConstraints = false
        secondNotification.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        secondNotification.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        secondNotification.topAnchor.constraint(equalTo: firstNotification.bottomAnchor, constant: 5).isActive = true
        secondNotification.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func configuareFooterTitle(){
        self.view.addSubview(self.footerTitleView)
        
        self.footerTitleView.textColor = .black
        self.footerTitleView.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
        self.footerTitleView.text = "Настройки камеры:"
        
        footerTitleView.translatesAutoresizingMaskIntoConstraints = false
        footerTitleView.topAnchor.constraint(equalTo: secondNotification.bottomAnchor, constant: 10).isActive = true
        footerTitleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        footerTitleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        footerTitleView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func configuareCameraSetting(){
        self.view.addSubview(self.cameraSettingView)
        
        cameraSettingView.translatesAutoresizingMaskIntoConstraints = false
        cameraSettingView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        cameraSettingView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15).isActive = true
        cameraSettingView.topAnchor.constraint(equalTo: footerTitleView.bottomAnchor, constant: 5).isActive = true
        cameraSettingView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

}
