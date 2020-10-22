//
//  SettingsViewer.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit


//MARK: - SettingsViewer
public class SettingsViewer: UIViewController, SettingsViewerProtocol, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    //MARK: - SettingsViewerProtocol implementation
    public var interactor: SettingsInteractorProtocol?
    public var router: SettingsRouterProtocol?
    
    public func showError(error: String) {
        
    }
    
    public func hideError() {
        
    }
    
    public func changedBusyState(_ state: Bool) {
        DispatchQueue.main.async {
            if state {
                self.acitivitiIndicator.startAnimating()
            }
            else {
                self.acitivitiIndicator.stopAnimating()
            }
        }
    }
    
    public func updateView(account: SettingsModel?) {
        self.accountSettings = account
        guard let settings = self.accountSettings, let cameraSettings = self.accountSettings?.CameraConnections.first else { return }
        DispatchQueue.main.async {
            
            self.saveUtsButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
            self.utsButton.title = settings.TimeZoneOffsetInHours > 0 ? "UTS:+\(settings.TimeZoneOffsetInHours)" : "UTS:\(settings.TimeZoneOffsetInHours)"
            self.updateAccountSettingsButton.isEnabled = false
            
            self.updateStateWorkCamera.state = cameraSettings.IsActive
            let type = cameraSettings.type
            
            let cameraType = self.arrayTypesCamera.filter { $0.Id == type }.first
            if let data = cameraType {
                let index = self.arrayTypesCamera.firstIndex(of: data) ?? 0
                let radioButton = self.arraysTypeStateWork[index]
                self.SelectTypeCamera(radioButton, cameraType: data)
            }
            
            self.dateRangeSelector.fromDate = cameraSettings.DateStart!
            self.dateRangeSelector.toDate = cameraSettings.DateEnd!
            
            self.isWorkCameraAllHours.state = cameraSettings.IsForWholeDay
            self.fromHourButton.title = String(cameraSettings.StartHour)
            self.toHourButton.title = String(cameraSettings.EndHour)
            if self.isWorkCameraAllHours.state {
                self.heightToBottomParentConstraint.isActive = true
                self.fromHourButton.isHidden = true
                self.toHourButton.isHidden = true
                self.labelSecond.isHidden = true
            }
            
            self.arrayDays.forEach{$0.IsSelected = false}
            
            guard let selectedDaysString = cameraSettings.SelectedDays else { return }
            let arraySelectedDays = selectedDaysString.split(separator: ",")
            arraySelectedDays.forEach { (id) in
                self.arrayDays.forEach{(day) in
                    if day.Id == Int(id){
                        day.IsSelected = true
                    }
                }
            }
            self.arrayDaysView.forEach{ $0.backgroundColor = .white}
            let selectDays = self.arrayDays.filter { $0.IsSelected }
            selectDays.forEach{
                if let indexButton = self.arrayDays.firstIndex(of: $0) {
                    self.arrayDaysView[indexButton].backgroundColor = UIColor.init(hex: "#CCCCCC", alpha: 1)
                }
            }
            
        }
    }
    
    public var accountSettings: SettingsModel?
    
    //MARK: - ViewController functions
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.interactor?.loadAccountSettings()
    }
    
    public override func loadView() {
        super.loadView()
        self.arrayDays = self.interactor?.arrayDays ?? []
        self.arrayTypesCamera = self.interactor?.cameraTypesWork ?? []
        self.confgiaureViews()
    }
    
    private var arrayTypesCamera: [CameraTypeWork] = []
    
    private var arrayTypesCameraView: [RadioButton] = []
    private var selectedTypeCameraView: RadioButton?
    
    private var selectedVisibleView: UIView?
    
    
    private var arrayDays: [DayModel] = []
    private var arrayDaysView: [AppCustomButton] = []
    
    private var dateRangeSelector: AppDateRangeSelector = {
        var range = AppDateRangeSelector()
        range.isUserInteractionEnabled = true
        range.fromDateLabel.isUserInteractionEnabled = true
        range.toDateLabel.isUserInteractionEnabled = true
        range.layer.cornerRadius = 8
        range.layer.borderWidth = 2
        range.layer.borderColor = UIColor.init(hex: "#CCCCCC", alpha: 1).cgColor
        return range
    }()
    
    
    
    //MARK: - Configuare Views functions
    private var titleSettingView: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 24)
        label.textColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
        label.numberOfLines = 0
        label.text = "Настройки профиля"
        return label
    }()
    
    private var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        scroll.backgroundColor = .white
        scroll.alwaysBounceVertical = true
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceHorizontal = false
        scroll.isUserInteractionEnabled = true
        return scroll
    }()
    
    private var updateAccountSettingsButton: AppCustomButton = {
        var button = AppCustomButton()
        button.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 16)
        button.title = "Сохранить"
        button.layer.cornerRadius = 8
        return button
    }()
    
    var closeButton: AppCustomButton = {
        var close = AppCustomButton()
        close.title = "Отмена"
        close.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 22)
        close.titleLabel?.textColor = .black
        close.setTitleColor(.black, for: .normal)
        close.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return close
    }()
    var updateButton: AppCustomButton = {
        var close = AppCustomButton()
        close.title = "Обновить"
        close.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 22)
        close.titleLabel?.textColor = .black
        close.setTitleColor(.black, for: .normal)
        close.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return close
    }()
       
    var customPicker: UIPickerView = {
      let picker = UIPickerView()
      return picker
    }()
    
    var arrayPickerTitles: [String] = []
    var currentDataPciker: String = ""
    
    private var timeTitleView: UIView = {
        var view = ViewButtomLine()
        view.colorLine = UIColor.init(hex: "#CCCCCC", alpha: 1)
        view.heightLine = 2
        return view
    }()
    private var timeContentView: UIView = {
        var view = UIView()
        return view
    }()
    private var utsButton: AppCustomButton = {
        var button = AppCustomButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.init(red: 0.196, green: 0.255, blue: 0.498, alpha: 0.05)
        button.title = "UTS"
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        button.setTitleColor(AppConstants.APP_DEFAULT_TEXT_COLOR, for: .normal)
        return button
    }()
    private var saveUtsButton: AppCustomButton = {
        var button = AppCustomButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        button.title = "Сохранить"
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    
    private var stateTitleView: UIView = {
        var view = ViewButtomLine()
        view.colorLine = UIColor.init(hex: "#CCCCCC", alpha: 1)
        view.heightLine = 2
        return view
    }()
    private var stateContentView: UIView = {
        var view = UIView()
        return view
    }()
    private var updateStateWorkCamera: AppRadioButton = {
        var button = AppRadioButton()
        button.selectedButtonColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        button.nonSelectedButtonColor = UIColor.lightGray
        button.backgroundButtonColor = .white
        return button
    }()
    private var saveStateWorkCameraButton: AppCustomButton = {
        var button = AppCustomButton()
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        button.title = "Сохранить"
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var isWorkCameraAllHours: AppCustomCheckBox = {
        var checkbox = AppCustomCheckBox()
        checkbox.strokeColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
        checkbox.fillColor = UIColor.init(red: 0, green:0, blue: 0, alpha: 0.05)
        return checkbox
    }()
    
    private var fromHourButton: AppCustomButton = {
        var button = AppCustomButton()
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.init(hex: "#CCCCCC", alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.setTitleColor(AppConstants.APP_DEFAULT_TEXT_COLOR, for: .normal)
        return button
    }()
    private var labelSecond: UILabel = {
        var label = UILabel()
        return label
    }()
    private var toHourButton: AppCustomButton = {
        var button = AppCustomButton()
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.init(hex: "#CCCCCC", alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.setTitleColor(AppConstants.APP_DEFAULT_TEXT_COLOR, for: .normal)
        return button
    }()
    
    
    private var typeCameraWorkView: UIView = {
        var view = ViewButtomLine()
        view.colorLine = UIColor.init(hex: "#CCCCCC", alpha: 1)
        view.heightLine = 2
        return view
    }()
    private var typeCameraWorkContentView: UIView = {
        var view = UIView()
        return view
    }()
    
    private var arraysTypeStateWork: [RadioButton] = []
    
    private var datePanelContentView: UIView = {
        var view = UIView()
        return view
    }()
    
    private var hoursContentView: UIView = {
        var view = UIView()
        return view
    }()
    
    private var daysContentView: UIView = {
        var view = UIView()
        return view
    }()
    
    private  var acitivitiIndicator: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView()
       view.style = .large
       view.color = .white
       view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.35)
       return view
    }()
    
    private var textField: UITextField = UITextField()
    
    private var commonPicker: CommonPickerDialogView?
    
    //MARK: - Configuare functions
    private func confgiaureViews(){
        self.configuareTitleView()
        
        self.configuareUpdateButtonView()
        self.configuareScrollView()
        
        self.configuareTimeHeader()
        self.configuareTitleContent()
        
        self.configuareStateHeader()
        self.configuareStateContent()
        
        self.configuareTypeCameraHeader()
        self.configuareTypeWorkCameraContentView()
        
        self.configuareHoursContentView()
        
        self.configuareDataPanelView()
        self.configuareDaysPanelView()
        
        self.configuareIndicator()
        
        self.configuareDataPicker()
        self.configuareToolbarButtons()
        
        self.configaureDatePicker()
        
        self.view.addSubview(self.textField)
        self.textField.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
        self.textField.isHidden = true
        
        
        self.commonPicker = CommonPickerDialogView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight), arrays: [])
        let customView:UIView = UIView (frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        customView.backgroundColor = UIColor.white
        customView.addSubview(self.commonPicker!)

        self.textField.inputView = customView
        self.textField.becomeFirstResponder()
    }
    
    private func configuareTitleView(){
        self.view.addSubview(self.titleSettingView)
        self.titleSettingView.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleSettingView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32).isActive = true
        self.titleSettingView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 24).isActive = true
        self.titleSettingView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -24).isActive = true

    }
    
    private func configuareUpdateButtonView(){
        self.view.addSubview(self.updateAccountSettingsButton)
        self.updateAccountSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.updateAccountSettingsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.updateAccountSettingsButton.widthAnchor.constraint(equalToConstant: 174).isActive = true
        self.updateAccountSettingsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        self.updateAccountSettingsButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        self.updateAccountSettingsButton.Action = {(_) in
            
            let queue = DispatchQueue.global(qos: .background)
            guard let settings = self.interactor?.accountSettings else { return }
            queue.sync {
                self.interactor?.updateTimeZone(timeZone: self.accountSettings!.TimeZoneOffsetInHours)
            }
            queue.sync {
                self.interactor?.updateCameraStatus(status: settings.CameraConnections.first!.IsActive)
            }
            queue.sync {
                self.updateAccountSettings()
            }
        }
    }
    
    private func configuareScrollView(){
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
               
        self.scrollView.topAnchor.constraint(equalTo: self.titleSettingView.bottomAnchor, constant: 10).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.updateAccountSettingsButton.topAnchor, constant: -10).isActive = true
        self.scrollView.showsVerticalScrollIndicator = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
    }
    
    @objc func doubleTapped() {
         self.view.endEditing(true)
    }
    
    private func configuareTimeHeader(){
        self.scrollView.addSubview(self.timeTitleView)
        self.timeTitleView.translatesAutoresizingMaskIntoConstraints = false

        self.timeTitleView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 20).isActive = true
        self.timeTitleView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.timeTitleView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.configuareHeaderSectionView(sectionTitle:"Время", to: self.timeTitleView)
    }
    
    private func configuareHeaderSectionView(sectionTitle: String, to header: UIView) {
        
        let circleStatus = UIView()
        header.addSubview(circleStatus)
        
        circleStatus.translatesAutoresizingMaskIntoConstraints = false
        circleStatus.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20).isActive = true
        circleStatus.centerYAnchor.constraint(equalTo: header.centerYAnchor).isActive = true
        circleStatus.widthAnchor.constraint(equalToConstant: 20).isActive = true
        circleStatus.heightAnchor.constraint(equalToConstant: 20).isActive = true
        circleStatus.layer.cornerRadius = 10
        circleStatus.layer.masksToBounds = true
        circleStatus.layer.backgroundColor = UIColor.systemGreen.cgColor
        
        let title = UILabel()
        title.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        title.textColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
        title.numberOfLines = 1
        title.text = sectionTitle
        header.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: circleStatus.rightAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(equalTo: header.rightAnchor, constant: -20).isActive = true
        title.topAnchor.constraint(equalTo: header.topAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10).isActive = true
    }
    
    private func configuareTitleContent(){
        
        self.scrollView.addSubview(self.timeContentView)
        self.timeContentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.timeContentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.timeContentView.topAnchor.constraint(equalTo: self.timeTitleView.bottomAnchor).isActive = true
        self.timeContentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        self.timeContentView.addSubview(self.utsButton)
        self.utsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.utsButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.utsButton.topAnchor.constraint(equalTo: self.timeContentView.topAnchor, constant: 15).isActive = true
        self.utsButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        self.utsButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        self.utsButton.Action = {(_) in
            self.showUtsHoursPanel()
            //self.prepareUtsButton()
        }
        
        let label = UILabel()
        self.timeContentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.rightAnchor.constraint(equalTo: self.utsButton.leftAnchor, constant: -20).isActive = true
        label.leftAnchor.constraint(equalTo: self.timeContentView.leftAnchor, constant: 53).isActive = true
        label.centerYAnchor.constraint(equalTo: self.utsButton.centerYAnchor, constant: 0).isActive = true
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.text = "Часовый пояс"
        
        self.timeContentView.addSubview(self.saveUtsButton)
        self.saveUtsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.saveUtsButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.saveUtsButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
        self.saveUtsButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        self.saveUtsButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.saveUtsButton.bottomAnchor.constraint(equalTo: self.timeContentView.bottomAnchor, constant: -5).isActive = true
        self.saveUtsButton.Action = {(_) in
            self.interactor?.updateTimeZone(timeZone: self.accountSettings!.TimeZoneOffsetInHours)
        }
       
    }
    
    
    private func configuareStateHeader(){
        self.scrollView.addSubview(self.stateTitleView)
        self.stateTitleView.translatesAutoresizingMaskIntoConstraints = false

        self.stateTitleView.topAnchor.constraint(equalTo: self.timeContentView.bottomAnchor, constant: 10).isActive = true
        self.stateTitleView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.stateTitleView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.configuareHeaderSectionView(sectionTitle:"Статус", to: self.stateTitleView)
    }
    
    private func configuareStateContent(){
        self.scrollView.addSubview(self.stateContentView)
        self.stateContentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.stateContentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.stateContentView.topAnchor.constraint(equalTo: self.stateTitleView.bottomAnchor).isActive = true
        self.stateContentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        let label = UILabel()
        self.stateContentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: self.stateContentView.topAnchor, constant: 15).isActive = true
        label.leftAnchor.constraint(equalTo: self.stateContentView.leftAnchor, constant: 53).isActive = true
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.text = "Сервис активирован"
        
        self.stateContentView.addSubview(self.updateStateWorkCamera)
        self.updateStateWorkCamera.translatesAutoresizingMaskIntoConstraints = false
        
        self.updateStateWorkCamera.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.updateStateWorkCamera.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.updateStateWorkCamera.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        self.updateStateWorkCamera.rightAnchor.constraint(equalTo: self.stateContentView.rightAnchor, constant: -40).isActive = true
        self.updateStateWorkCamera.Clicked = {(status) in
            self.accountSettings?.CameraConnections.first?.IsActive = status
            self.updateAccountSettingsButton.isEnabled = true
        }
        
        
        self.stateContentView.addSubview(self.saveStateWorkCameraButton)
        self.saveStateWorkCameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.saveStateWorkCameraButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.saveStateWorkCameraButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
        self.saveStateWorkCameraButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        self.saveStateWorkCameraButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        self.saveStateWorkCameraButton.bottomAnchor.constraint(equalTo: self.stateContentView.bottomAnchor, constant: -5).isActive = true
        self.saveStateWorkCameraButton.Action = {(_) in
            guard let settings = self.interactor?.accountSettings else { return }
              self.interactor?.updateCameraStatus(status: settings.CameraConnections.first!.IsActive)
            self.saveStateWorkCameraButton.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)

        }
        
    }
    
    private func configuareTypeCameraHeader(){
        self.scrollView.addSubview(self.typeCameraWorkView)
        self.typeCameraWorkView.translatesAutoresizingMaskIntoConstraints = false

        self.typeCameraWorkView.topAnchor.constraint(equalTo: self.stateContentView.bottomAnchor, constant: 0).isActive = true
        self.typeCameraWorkView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.typeCameraWorkView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.configuareHeaderSectionView(sectionTitle:"Режим работы камеры", to: self.typeCameraWorkView)
    }
    
    private func configuareTypeWorkCameraContentView(){
        
        self.scrollView.addSubview(self.typeCameraWorkContentView)
        self.typeCameraWorkContentView.translatesAutoresizingMaskIntoConstraints = false
        self.typeCameraWorkContentView.topAnchor.constraint(equalTo: self.typeCameraWorkView.bottomAnchor, constant: 0).isActive = true
        self.typeCameraWorkContentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.typeCameraWorkContentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        var view: UIView?
        for type in self.arrayTypesCamera {
           let content = ViewButtomLine()
           content.colorLine = UIColor.init(hex: "#CCCCCC", alpha: 1)
           content.heightLine = 2
           
           self.typeCameraWorkContentView.addSubview(content)
           content.translatesAutoresizingMaskIntoConstraints = false
           content.leftAnchor.constraint(equalTo: self.typeCameraWorkContentView.leftAnchor, constant: 50).isActive = true
           content.rightAnchor.constraint(equalTo: self.typeCameraWorkContentView.rightAnchor).isActive = true
           if(view == nil){
               content.topAnchor.constraint(equalTo: self.typeCameraWorkContentView.topAnchor, constant: 5).isActive = true
           }
           else{
               content.topAnchor.constraint(equalTo: view!.bottomAnchor, constant: 5).isActive = true
           }
            self.createTypeWorkCamera(to: content, index: 0, cameraType: type)
           view = content
        }
        view?.bottomAnchor.constraint(equalTo: self.typeCameraWorkContentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func createTypeWorkCamera(to view: UIView, index: Int, cameraType: CameraTypeWork){
        
        let radioButton = RadioButton()
        self.arraysTypeStateWork.append(radioButton)
        view.addSubview(radioButton)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        
        radioButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        radioButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        radioButton.Clicked = {(value) in
            DispatchQueue.main.async {
                self.SelectTypeCamera(radioButton, cameraType: cameraType)
            }
            guard let settings = self.accountSettings else { return }
            settings.CameraConnections.first?.type = cameraType.Id
            self.updateAccountSettingsButton.isEnabled = true
        }
        
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        label.leftAnchor.constraint(equalTo: radioButton.rightAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 14)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.text = cameraType.Title
    }
    
    
    private func configuareDaysPanelView(){
        
        self.scrollView.addSubview(self.daysContentView)
        self.daysContentView.translatesAutoresizingMaskIntoConstraints = false
        self.daysContentView.isHidden = true
        self.daysContentView.topAnchor.constraint(equalTo: self.hoursContentView.bottomAnchor, constant: 0).isActive = true
        self.daysContentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.daysContentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.daysContentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -50).isActive = true
        
        var content: UIView?
        for day in self.arrayDays {
            
            let dayView = AppCustomButton()
            self.arrayDaysView.append(dayView)
            dayView.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
            dayView.setTitleColor(AppConstants.APP_DEFAULT_TEXT_COLOR, for: .normal)
            dayView.title = day.Title
            dayView.layer.cornerRadius = 8
            dayView.layer.borderWidth = 1
            dayView.layer.borderColor = UIColor.init(hex: "#CCCCCC", alpha: 1).cgColor
            dayView.backgroundColor = .white
            dayView.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
            
            self.daysContentView.addSubview(dayView)
            dayView.translatesAutoresizingMaskIntoConstraints = false
            dayView.leftAnchor.constraint(equalTo: self.daysContentView.leftAnchor, constant: 60).isActive = true
            if(content == nil){
                dayView.topAnchor.constraint(equalTo: self.daysContentView.topAnchor, constant: 10).isActive = true
            } else {
                dayView.topAnchor.constraint(equalTo: content!.bottomAnchor, constant: 10).isActive = true
            }
            content = dayView
            
            dayView.Action = {(_) in
                day.IsSelected = !day.IsSelected
                dayView.backgroundColor = day.IsSelected ? UIColor.init(hex: "#CCCCCC", alpha: 1) : .white
                self.updateAccountSettingsButton.isEnabled = true
            }
        }
        content?.bottomAnchor.constraint(equalTo: self.daysContentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func configuareDataPanelView(){
        
        self.scrollView.addSubview(self.datePanelContentView)
        self.datePanelContentView.translatesAutoresizingMaskIntoConstraints = false
        self.datePanelContentView.isHidden = true
        
        self.datePanelContentView.topAnchor.constraint(equalTo: self.hoursContentView.bottomAnchor, constant: 0).isActive = true
        self.datePanelContentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.datePanelContentView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        let label = UILabel()
        self.datePanelContentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 14)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.text = "Выберите даты"
        
        label.topAnchor.constraint(equalTo: self.datePanelContentView.topAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: self.datePanelContentView.leftAnchor, constant: 50).isActive = true
        label.rightAnchor.constraint(equalTo: self.datePanelContentView.rightAnchor, constant: -10).isActive = true
        
        
        self.datePanelContentView.addSubview(self.dateRangeSelector)
        self.dateRangeSelector.translatesAutoresizingMaskIntoConstraints = false
        self.dateRangeSelector.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        self.dateRangeSelector.leftAnchor.constraint(equalTo: self.datePanelContentView.leftAnchor, constant: 50).isActive = true
        self.dateRangeSelector.rightAnchor.constraint(equalTo: self.datePanelContentView.rightAnchor, constant: -20).isActive = true
        self.dateRangeSelector.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.dateRangeSelector.bottomAnchor.constraint(equalTo: self.datePanelContentView.bottomAnchor, constant: -10).isActive = true
        self.dateRangeSelector.fromDateLabel.Action = {(_) in
            self.currentDataPciker = "STARTDATE"
            self.datePicker.isHidden = false
            self.toolBar.isHidden = false
            let forrmat = DateFormatter()
            forrmat.dateFormat = "dd.MM.yyyy"
            if let data = forrmat.date(from: self.accountSettings!.CameraConnections.first!.DateStartStr) {
                self.datePicker.date = data
            }
            
        }
        self.dateRangeSelector.toDateLabel.Action = {(_) in
            self.currentDataPciker = "ENDDATE"
            self.datePicker.isHidden = false
            self.toolBar.isHidden = false
            let forrmat = DateFormatter()
            forrmat.dateFormat = "dd.MM.yyyy"
            if let data = forrmat.date(from: self.accountSettings!.CameraConnections.first!.DateEndStr) {
                self.datePicker.date = data
            }
        }
    }
    
    private var heightToBottomParentConstraint: NSLayoutConstraint!
    
    private func configuareHoursContentView(){
        
        self.scrollView.addSubview(self.hoursContentView)
        self.hoursContentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.hoursContentView.topAnchor.constraint(equalTo: self.typeCameraWorkContentView.bottomAnchor, constant: 0).isActive = true
        self.hoursContentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.hoursContentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        let title = UILabel()
        title.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        title.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        title.text = "Выберите часы работы"
        
        self.hoursContentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.hoursContentView.topAnchor, constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: self.hoursContentView.leftAnchor, constant: 50).isActive = true
        title.rightAnchor.constraint(equalTo: self.hoursContentView.rightAnchor, constant: -50).isActive = true

        
        self.labelSecond.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        self.labelSecond.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        self.labelSecond.text = "до"
        
        self.hoursContentView.addSubview(self.isWorkCameraAllHours)
        self.isWorkCameraAllHours.translatesAutoresizingMaskIntoConstraints = false
        self.isWorkCameraAllHours.OnChanged = {(status) in
            if(status) {
                self.accountSettings?.CameraConnections.first?.StartHour = 0
                self.accountSettings?.CameraConnections.first?.EndHour = 24
                
                self.labelSecond.isHidden = true
                self.fromHourButton.isHidden = true
                self.toHourButton.isHidden = true
                self.heightToBottomParentConstraint.isActive = true
            } else {
                self.labelSecond.isHidden = false
                self.fromHourButton.isHidden = false
                self.toHourButton.isHidden = false
                self.heightToBottomParentConstraint.isActive = false
            }
            self.updateAccountSettingsButton.isEnabled = true
        }
        
        self.isWorkCameraAllHours.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.isWorkCameraAllHours.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.isWorkCameraAllHours.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16).isActive = true
        self.isWorkCameraAllHours.leftAnchor.constraint(equalTo: self.hoursContentView.leftAnchor, constant: 50).isActive = true
        
        self.heightToBottomParentConstraint = self.isWorkCameraAllHours.bottomAnchor.constraint(equalTo: self.hoursContentView.bottomAnchor, constant: 0)
        
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.text = "Весь день  или  с"
        
        self.hoursContentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.isWorkCameraAllHours.rightAnchor, constant: 20).isActive = true
        label.centerYAnchor.constraint(equalTo: self.isWorkCameraAllHours.centerYAnchor).isActive = true
        
        label.halfTextColorChange(fullText: "Весь день  или  с", changeText: "или", textColor: UIColor.gray)
        
        self.hoursContentView.addSubview(self.fromHourButton)
        self.fromHourButton.translatesAutoresizingMaskIntoConstraints = false
        self.fromHourButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        self.fromHourButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.fromHourButton.leftAnchor.constraint(equalTo: self.hoursContentView.leftAnchor, constant: 50).isActive = true
        self.fromHourButton.topAnchor.constraint(equalTo: isWorkCameraAllHours.bottomAnchor, constant: 15).isActive = true
        self.fromHourButton.bottomAnchor.constraint(equalTo: hoursContentView.bottomAnchor, constant: -15).isActive = true
        self.fromHourButton.Action = {(_) in
            self.showPervHoursPanel()
        }
       
        
        self.hoursContentView.addSubview(self.labelSecond)
        self.labelSecond.translatesAutoresizingMaskIntoConstraints = false
        self.labelSecond.leftAnchor.constraint(equalTo: self.fromHourButton.rightAnchor, constant: 10).isActive = true
        self.labelSecond.centerYAnchor.constraint(equalTo: self.fromHourButton.centerYAnchor).isActive = true
        self.labelSecond.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.hoursContentView.addSubview(self.toHourButton)
        self.toHourButton.translatesAutoresizingMaskIntoConstraints = false
        self.toHourButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        self.toHourButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.toHourButton.leftAnchor.constraint(equalTo: labelSecond.rightAnchor, constant: 10).isActive = true
        self.toHourButton.centerYAnchor.constraint(equalTo: labelSecond.centerYAnchor).isActive = true
        self.toHourButton.bottomAnchor.constraint(equalTo: hoursContentView.bottomAnchor, constant: -15).isActive = true
        self.toHourButton.Action = {(_) in
            self.showUperHoursPanel()
        }
    }
    
    private func configuareIndicator(){
        
        self.view.addSubview(self.acitivitiIndicator)
        
        self.acitivitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.acitivitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.acitivitiIndicator.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.acitivitiIndicator.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.acitivitiIndicator.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.acitivitiIndicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    
    private func configuareToolbarButtons(){
              
          self.view.addSubview(self.closeButton)
          
          self.closeButton.translatesAutoresizingMaskIntoConstraints = false
          self.closeButton.bottomAnchor.constraint(equalTo: self.customPicker.topAnchor, constant: 0).isActive = true
          self.closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
          self.closeButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
          self.closeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
          self.closeButton.isHidden = true
          self.closeButton.Action = {(_) in
              self.closePicker()
          }
          
          self.view.addSubview(self.updateButton)
          self.updateButton.translatesAutoresizingMaskIntoConstraints = false
          self.updateButton.bottomAnchor.constraint(equalTo: self.customPicker.topAnchor, constant: 0).isActive = true
          self.updateButton.leftAnchor.constraint(equalTo: self.closeButton.rightAnchor, constant: 0).isActive = true
          self.updateButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
          self.updateButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
          self.updateButton.isHidden = true
          self.updateButton.Action = {(_) in
              self.updateDateProperties()
          }
       }
       
    private func configuareDataPicker(){
       
       self.view.addSubview(self.customPicker)
       self.customPicker.translatesAutoresizingMaskIntoConstraints = false
       
       self.customPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
       self.customPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
       self.customPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
       self.customPicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
       self.customPicker.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
       self.customPicker.tintColor = .white
       self.customPicker.dataSource = self
       self.customPicker.delegate = self
       self.customPicker.isHidden = true
       
    }
    
    private func showPicker(){
        self.customPicker.isHidden = false
        self.closeButton.isHidden = false
        self.updateButton.isHidden = false
    }

    private func updateDateProperties(){
        self.closePicker()
        self.updateModel()
    }

    private func closePicker(){
       self.customPicker.isHidden = true
       self.closeButton.isHidden = true
       self.updateButton.isHidden = true
    }


    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
    private let kPickerViewHeight: CGFloat = 240.0
       
       
    func showPicker(_ pickerView: UIPickerView) {
       
       let customView:UIView = UIView (frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        customView.backgroundColor = UIColor.white
       customView.addSubview(pickerView)
       
       self.textField.inputView = customView
       self.textField.becomeFirstResponder()
    }

   @objc func showUtsHoursPanel() {

        var arrayHours:[Int] = []
        let maxRangeHour = 12
        for i in 0...maxRangeHour * 2 {
            arrayHours.append(i - maxRangeHour)
        }

        let index = arrayHours.firstIndex(of: self.accountSettings!.TimeZoneOffsetInHours)!
        self.commonPicker?.SetPickerElements(arrayHours)
        self.commonPicker?.selectElement(arrayHours[index])

        self.commonPicker?.onSelected = {(data) in
            if let hour = data as? Int {
                self.accountSettings?.TimeZoneOffsetInHours = hour
                self.updateAccountSettingsButton.isEnabled = true
                self.utsButton.title = hour > 0 ? "UTS:+\(hour)" : "UTS:\(hour)"
            }
        }

        self.textField.becomeFirstResponder()
        //self.showPicker(hoursPicker)
    }
    
    
    @objc func showPervHoursPanel() {
        
        var arrayHours:[Int] = []
        for item  in 0...(self.accountSettings?.CameraConnections.first!.EndHour)!-1 {
           arrayHours.append(item)
        }
        
        let index = arrayHours.firstIndex(of: (self.accountSettings?.CameraConnections.first!.StartHour)!)!
        
        self.commonPicker?.SetPickerElements(arrayHours)
        self.commonPicker?.selectElement(arrayHours[index])

        self.commonPicker?.onSelected = {(data) in
           if let hour = data as? Int {
               self.accountSettings?.CameraConnections.first?.StartHour = hour
               self.updateAccountSettingsButton.isEnabled = true
               self.fromHourButton.title = String(hour)
           }
        }
        self.textField.becomeFirstResponder()
//        self.showPicker(hoursPicker)
    }
    
    @objc func showUperHoursPanel(){
        
        var arrayHours:[Int] = []
        for item in (self.accountSettings?.CameraConnections.first!.StartHour)!+1...24 {
           arrayHours.append(item)
        }
        
        let index = arrayHours.firstIndex(of: (self.accountSettings?.CameraConnections.first!.EndHour)!)!
        self.commonPicker?.SetPickerElements(arrayHours)
        self.commonPicker?.selectElement(arrayHours[index])
        
        self.commonPicker?.onSelected = {(data) in
           if let hour = data as? Int {
               self.accountSettings?.CameraConnections.first?.EndHour = hour
               self.updateAccountSettingsButton.isEnabled = true
               self.toHourButton.title = String(hour)
           }
        }
        
        self.textField.becomeFirstResponder()
//        self.showPicker(hoursPicker)
    }
       
    
    //MARK: - Function Select TypeWorkCamera
    
    private func SelectTypeCamera(_ view: RadioButton, cameraType: CameraTypeWork){
        
        if let button = self.selectedTypeCameraView {
            button.IsSelect = false
        }
        self.selectedTypeCameraView = view
        self.selectedTypeCameraView?.IsSelect = true
        
        var newSelectPanelView: UIView?
        if (cameraType.Title == "На выбранный интервал") {
            newSelectPanelView =  self.datePanelContentView
        } else if(cameraType.Title == "Определенные дни недели") {
            newSelectPanelView =  self.daysContentView
        }
        self.selectedVisibleView?.isHidden = true
        newSelectPanelView?.isHidden = false
        self.selectedVisibleView = newSelectPanelView
    }
    
    private func prepareUtsButton(){
        self.arrayPickerTitles.removeAll()
        let maxRangeHour = 12
        for i in 0...maxRangeHour * 2 {
           self.arrayPickerTitles.append("\(i - maxRangeHour)")
        }
        self.customPicker.reloadAllComponents()
        self.showPicker()
        self.customPicker.selectRow(maxRangeHour + self.accountSettings!.TimeZoneOffsetInHours, inComponent: 0, animated: false)
        self.currentDataPciker = "HOURS"
    }
    
    
    private func updateModel(){
        if self.currentDataPciker == "HOURS" {
            let currentTimeZone = self.customPicker.selectedRow(inComponent: 0) - 12
            self.accountSettings?.TimeZoneOffsetInHours = self.customPicker.selectedRow(inComponent: 0) - 12
            self.updateAccountSettingsButton.isEnabled = true
            self.utsButton.title = currentTimeZone > 0 ? "UTS:+\(currentTimeZone)" : "UTS:\(currentTimeZone)"
        }
        else if self.currentDataPciker == "FROMHOURS" {
            let index = self.customPicker.selectedRow(inComponent: 0)
            self.accountSettings?.CameraConnections.first?.StartHour = Int(self.arrayPickerTitles[index]) ?? 0
            self.updateAccountSettingsButton.isEnabled = true
            self.fromHourButton.title = self.arrayPickerTitles[index]
        }
        else if self.currentDataPciker == "TOHOURS" {
            let index = self.customPicker.selectedRow(inComponent: 0)
            self.accountSettings?.CameraConnections.first?.EndHour = Int(self.arrayPickerTitles[index]) ?? 24
            self.updateAccountSettingsButton.isEnabled = true
            self.toHourButton.title = self.arrayPickerTitles[index]
        }
    }
    
    
    //MARK: - Picker functions
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayPickerTitles.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }

   
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 25)
        label.textColor = .black
        label.textAlignment = .center
        label.text = self.arrayPickerTitles[row]
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
          return 70
    }
    
    
    //MARK:  - DatePicker functions
    let datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    
    func configaureDatePicker() {
             
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        datePicker.isHidden = true

        self.view.addSubview(datePicker)
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.datePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.datePicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.datePicker.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.toolBar.isHidden = true
        self.toolBar.items = [
            UIBarButtonItem(title: "Отмена", style: .done, target: self, action: #selector(closeDatePicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Обновить", style: .done, target: self, action: #selector(datePickerValueChanged))
        ]
        self.toolBar.sizeToFit()
        self.view.addSubview(self.toolBar)
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.toolBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.toolBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.toolBar.bottomAnchor.constraint(equalTo: self.datePicker.topAnchor).isActive = true
        self.datePicker.heightAnchor.constraint(equalToConstant: 200).isActive = true

    }
    
    private func updateAccountSettings(){
        do {
            guard let settings = self.accountSettings else { return }
            let selectDaysString = self.arrayDays.filter { $0.IsSelected }.map{ String($0.Id) }.joined(separator: ",")
            settings.CameraConnections.first?.SelectedDays = selectDaysString
            
            self.interactor?.updatePipeSettings(settings: settings)
        }
        catch let error {
            
        }
    }
    
    
    @objc dynamic func datePickerValueChanged(){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let selectedDate: String = dateFormatter.string(from: self.datePicker.date)
        if currentDataPciker == "STARTDATE" {
            self.accountSettings?.CameraConnections.first?.DateStartStr = selectedDate
        } else if currentDataPciker == "ENDDATE" {
            self.accountSettings?.CameraConnections.first?.DateEndStr = selectedDate
        }
        self.updateAccountSettingsButton.isEnabled = true
        self.closeDatePicker()
    }
    
    @objc dynamic func closeDatePicker(){
        self.toolBar.isHidden = true
        self.datePicker.isHidden = true
    }
}


extension Int: ElementToPickerDialog {
    public func PickerDialogElement() -> String {
        return "\(self)"
    }
}
