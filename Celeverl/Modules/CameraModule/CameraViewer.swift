//
//  CameraViewer.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit
import DatePickerDialog
import iOSDropDown
import AVKit
import Alamofire

//MARK: - CameraViewer
public class CameraViewer: UIViewController, CameraViewerProtocol, UIPickerViewDataSource, UIPickerViewDelegate, VLCMediaPlayerDelegate, ScreenPlayerProtocol {
   
    //MARK: - CameraViewerProtocol
    public var interactor: CameraInteractorProtocol?
    public var cameras: [CameraModel]?
    public var typesCameraWork: [TypeCameraWork] = []
    public var type: TypeCameraWork?
    
    public func getCameraList(cameras: [CameraModel]) {
        self.cameras = cameras
    }
    
    public func setCurrentCamera(camera: CameraModel) {
        DispatchQueue.main.async {
            let cameraIndex = self.cameras!.firstIndex(of: camera)!
            self.prevCameraButton.isHidden = cameraIndex == 0
            self.nextCameraButton.isHidden = cameraIndex == self.cameras!.count - 1
        }
    }
    
    public func addCameraId() {
        
    }
    
    public func setCameraTypeWork(type: TypeCameraWork) {
        DispatchQueue.main.async {
            self.stateButton.title = type.Title
            self.currentDatePickerLabel.isHidden = type.Title != "Архив"
        }
    }
    
    public func getTypeCameraWork(types: [TypeCameraWork]) {
        self.typesCameraWork = types
        DispatchQueue.main.async {
            self.customPicker.reloadAllComponents()
        }
    }
    
    public func updateSelectedDateLabel(date: Date) {
        let forrmater = DateFormatter()
        forrmater.locale = Locale(identifier: "ru_RU")
        forrmater.dateFormat = "dd MMM HH:mm"
        DispatchQueue.main.async {
            self.currentDatePickerLabel.title = forrmater.string(from: date)
        }
    }
    
    public func updatePayer(_ type: TypeCameraWork, _ url: URL) {
        DispatchQueue.main.async {
            self.currentPlayer?.stop()
            self.currentPlayer = nil
            let result = type.Title == "Онлайн"
            self.streamPlayer.isHidden = result
            self.onlinePlayer.isHidden = !result
            self.currentPlayer = result == true ? self.onlinePlayer : self.streamPlayer
            self.currentPlayer?.setUrl(url: url)
            self.addCameraLabel.isHidden = true
        }
    }
    
    public func updateStatePage(_ state: Bool) {
        DispatchQueue.main.async {
            if state {
                self.busyView.startAnimating()
            } else {
                self.busyView.stopAnimating()
            }
        }
    }
    
    public func changeStateCameraButton(_ state: Bool) {
        DispatchQueue.main.async {
            self.addCameraLabel.isHidden = state
        }
    }
    
    var currentPlayer: BasePlayerProtocol?
    
    var onlineFullTopConstraint: NSLayoutConstraint?
    var onlineFullLeftConstraint: NSLayoutConstraint?
    var onlineFullRightConstraint: NSLayoutConstraint?
    var onlineFullBottomConstraint:NSLayoutConstraint?
    
    var onlineShortTopConstraint: NSLayoutConstraint?
    var onlineShortLeftConstraint: NSLayoutConstraint?
    var onlineShortRightConstraint: NSLayoutConstraint?
    var onlineShortBottomConstraint:NSLayoutConstraint?
    
    var streamFullTopConstraint: NSLayoutConstraint?
    var streamFullLeftConstraint: NSLayoutConstraint?
    var streamFullRightConstraint: NSLayoutConstraint?
    var streamFullBottomConstraint:NSLayoutConstraint?
       
    var streamShortTopConstraint: NSLayoutConstraint?
    var streamShortLeftConstraint: NSLayoutConstraint?
    var streamShortRightConstraint: NSLayoutConstraint?
    var streamShortBottomConstraint:NSLayoutConstraint?
       
    //MARK: - Views
    public var busyView: UIActivityIndicatorView = {
       var view = UIActivityIndicatorView()
       view.style = .large
       view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.85)
       view.color = .white
       return view
    }()
    
    public var stateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_MEDIUM, size: 20)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.text = "Режим просмотра"
        return label
    }()
    
    public var stateButton: AppCustomButton = {
        var label = AppCustomButton()
        label.titleLabel?.font = UIFont(name: AppConstants.APP_AVENIR, size: 16)
        label.setTitleColor(.white, for: .normal)
        label.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.layer.cornerRadius = 3
        return label
    }()
    
    public var playerContent: UIView = {
        var view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var onlinePlayer: OnlinePlayer = {
        var player = OnlinePlayer()
        player.backgroundColor = .black
        return player
    }()
    var streamPlayer: StreamPlayer = {
        var player = StreamPlayer()
        player.backgroundColor = .black
        return player
    }()
    
    var textField: UITextField = UITextField()
    
    
    public var currentCameraLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_MEDIUM, size: 14)
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        return label
    }()
    
    public var currentDatePickerLabel: AppCustomButton = {
        var label = AppCustomButton()
        label.titleLabel?.textAlignment = .center
        label.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_MEDIUM, size: 20)
        label.setTitleColor(AppConstants.APP_DEFAULT_TEXT_COLOR, for: .normal)
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 2
        label.layer.borderColor = AppConstants.APP_DEFAULT_TEXT_COLOR.cgColor
        label.backgroundColor = .white
        return label
    }()
    
    var addCameraLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.text = "В данный момент у вас нет доступных камер. Пожалуйста, нажмите сюда, чтобы добавить камеру."
        label.backgroundColor = UIColor.init(white: 1, alpha: 0.15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        label.isHidden = true
        return label
    }()
    
    public var prevCameraButton: UIView = {
        var view = UIView()
        return view
    }()
    
    public var nextCameraButton: UIView = {
        var view = UIView()
        return view
    }()
    
    public var customPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    public var closeButton: AppCustomButton = {
        var button = AppCustomButton()
        button.title = "Отмена"
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 22)
        button.titleLabel?.textColor = .black
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return button
    }()
    
    public var updateButton: AppCustomButton = {
        var button = AppCustomButton()
        button.title = "Обновить"
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 22)
        button.titleLabel?.textColor = .black
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        return button
    }()
    
    public var addCameraButton: AppCustomButton = {
        var button = AppCustomButton()
        button.title = "+"
        button.titleLabel?.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 22)
        button.setTitleColor(AppConstants.APP_DEFAULT_TEXT_COLOR, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    public var datePicker: DropDown = {
        var datepicker = DropDown()
        return datepicker
    }()
    
     //MARK: - ViewController
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUpUI()
        self.interactor?.setDefaultData()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.interactor?.loadCamerasList()
    }
    
    
    private func SetUpUI(){
        self.configuareLabel()
        self.configuareStateButton()
        
        self.configuareNextCameraButton()
        self.configuarePrevCameraButton()
        
        self.configuareCurrentCameraLabel()
        
        self.configuarePlayer()
        
        self.configuareAddCameraButton()
        
        self.configuareDataPicker()
        self.configuareToolbarButtons()
        
        self.configaureBusy()
        
        self.view.addSubview(self.textField)
        self.textField.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
        self.textField.isHidden = true
    }
    
   
    
    private func configuareLabel(){
        self.view.addSubview(self.stateLabel)
        self.stateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stateLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.stateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
    }
    
    private func configuareStateButton(){
        self.view.addSubview(self.stateButton)
        self.stateButton.translatesAutoresizingMaskIntoConstraints = false
        self.stateButton.centerYAnchor.constraint(equalTo: self.stateLabel.centerYAnchor).isActive = true
        self.stateButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.stateButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.stateButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.stateButton.Action = {(_) in
            self.showTypesCameraWorkPanel()
            //self.showPicker()
        }
    }
    
    private func configuareNextCameraButton(){
        self.view.addSubview(self.nextCameraButton)
        self.nextCameraButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextCameraButton.topAnchor.constraint(equalTo: self.stateButton.bottomAnchor, constant: 10).isActive = true
        self.nextCameraButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.nextCameraButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.nextCameraButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func configuarePrevCameraButton(){
        self.view.addSubview(self.prevCameraButton)
        self.prevCameraButton.translatesAutoresizingMaskIntoConstraints = false
        self.prevCameraButton.centerYAnchor.constraint(equalTo: self.nextCameraButton.centerYAnchor).isActive = true
        self.prevCameraButton.rightAnchor.constraint(equalTo: self.nextCameraButton.leftAnchor, constant: -10).isActive = true
        self.prevCameraButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.prevCameraButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func configuareAddCameraButton(){
        self.view.addSubview(self.addCameraLabel)
        self.addCameraLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addCameraLabel.leftAnchor.constraint(equalTo: self.playerContent.leftAnchor).isActive = true
        self.addCameraLabel.rightAnchor.constraint(equalTo: self.playerContent.rightAnchor).isActive = true
        self.addCameraLabel.topAnchor.constraint(equalTo: self.playerContent.topAnchor).isActive = true
        self.addCameraLabel.bottomAnchor.constraint(equalTo: self.playerContent.bottomAnchor).isActive = true
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(addCamera))
        touch.numberOfTapsRequired = 1
        self.addCameraLabel.addGestureRecognizer(touch)
    }
    
    private func configuareCurrentCameraLabel(){
        self.view.addSubview(self.currentCameraLabel)
        self.currentCameraLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currentCameraLabel.centerYAnchor.constraint(equalTo: self.nextCameraButton.centerYAnchor).isActive = true
        self.currentCameraLabel.leftAnchor.constraint(equalTo: self.stateLabel.leftAnchor, constant: 0).isActive = true
        self.currentCameraLabel.heightAnchor.constraint(equalTo: self.prevCameraButton.heightAnchor).isActive = true
    }
    
    private func configuarePlayer(){
        self.view.addSubview(self.playerContent)
        self.playerContent.translatesAutoresizingMaskIntoConstraints = false
        self.playerContent.topAnchor.constraint(equalTo: self.currentCameraLabel.bottomAnchor, constant: 10).isActive = true
        self.playerContent.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.playerContent.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.playerContent.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        self.view.addSubview(self.currentDatePickerLabel)
        self.currentDatePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currentDatePickerLabel.isHidden = true
        self.currentDatePickerLabel.topAnchor.constraint(equalTo: self.playerContent.bottomAnchor, constant: 20).isActive = true
        self.currentDatePickerLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.currentDatePickerLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.currentDatePickerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.currentDatePickerLabel.Action = {(_) in
           self.selectDate()
        }
        
        self.view.addSubview(self.onlinePlayer)
        self.onlinePlayer.translatesAutoresizingMaskIntoConstraints = false
        self.onlineShortTopConstraint = self.onlinePlayer.topAnchor.constraint(equalTo: self.playerContent.topAnchor)
        self.onlineShortLeftConstraint = self.onlinePlayer.leftAnchor.constraint(equalTo: self.playerContent.leftAnchor)
        self.onlineShortRightConstraint = self.onlinePlayer.rightAnchor.constraint(equalTo: self.playerContent.rightAnchor)
        self.onlineShortBottomConstraint = self.onlinePlayer.bottomAnchor.constraint(equalTo: self.playerContent.bottomAnchor)
        
        self.onlineShortTopConstraint?.isActive = true
        self.onlineShortLeftConstraint?.isActive = true
        self.onlineShortRightConstraint?.isActive = true
        self.onlineShortBottomConstraint?.isActive = true
        
        self.onlineFullTopConstraint = self.onlinePlayer.topAnchor.constraint(equalTo: self.view.topAnchor)
        self.onlineFullLeftConstraint = self.onlinePlayer.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        self.onlineFullRightConstraint = self.onlinePlayer.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        self.onlineFullBottomConstraint = self.onlinePlayer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.onlinePlayer.delegateScreen = self
        
        self.view.addSubview(self.streamPlayer)
        self.streamPlayer.translatesAutoresizingMaskIntoConstraints = false
        self.streamShortTopConstraint = self.streamPlayer.topAnchor.constraint(equalTo: self.playerContent.topAnchor)
        self.streamShortLeftConstraint = self.streamPlayer.leftAnchor.constraint(equalTo: self.playerContent.leftAnchor)
        self.streamShortRightConstraint = self.streamPlayer.rightAnchor.constraint(equalTo: self.playerContent.rightAnchor)
        self.streamShortBottomConstraint = self.streamPlayer.bottomAnchor.constraint(equalTo: self.playerContent.bottomAnchor)
        
        self.streamShortTopConstraint?.isActive = true
        self.streamShortLeftConstraint?.isActive = true
        self.streamShortRightConstraint?.isActive = true
        self.streamShortBottomConstraint?.isActive = true
        
        self.streamFullTopConstraint = self.streamPlayer.topAnchor.constraint(equalTo: self.view.topAnchor)
        self.streamFullLeftConstraint = self.streamPlayer.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        self.streamFullRightConstraint = self.streamPlayer.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        self.streamFullBottomConstraint = self.streamPlayer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        
        self.streamPlayer.delegateScreen = self
    }
    
    private func configaureBusy(){
       self.view.addSubview(self.busyView)
       self.busyView.translatesAutoresizingMaskIntoConstraints = false
       self.busyView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
       self.busyView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
       self.busyView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
       self.busyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    
    private func selectDate() {
        let maxDate = Date()
        DatePickerDialog(locale: Locale(identifier: "ru_MD"), showCancelButton: false).show("Выбор даты и времени", doneButtonTitle: "Выполнено", maximumDate: maxDate, datePickerMode: .dateAndTime) { (date) -> Void in
            guard let selectDate = date else { return }
            self.interactor?.updateSelectedDate(selectDate)
        }
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
            self.interactor?.updateSelectedTypeCameraWork(self.customPicker.selectedRow(inComponent: 0))
            self.closePicker()
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
    
    private func configuareDatePicker(){
        self.view.addSubview(self.datePicker)
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.datePicker.widthAnchor.constraint(equalToConstant: 300).isActive = true
        self.datePicker.heightAnchor.constraint(equalToConstant: 500).isActive = true
        self.datePicker.backgroundColor = .systemRed
    }
    
    
    private let kPickerViewHeight: CGFloat = 240.0
    
    
    func showPicker(_ pickerView: UIPickerView) {
        
        let customView:UIView = UIView (frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight))
        customView.backgroundColor = UIColor.white
        customView.addSubview(pickerView)
        
        self.textField.inputView = customView
        self.textField.becomeFirstResponder()
    }
    
    
    @objc func showTypesCameraWorkPanel() {
        
        let typeCameraWorkPicker = CommonPickerDialogView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kPickerViewHeight), arrays: (self.interactor?.typeCameraWork)!)
        
        if let current = self.interactor?.currentTypeCameraWork {
            typeCameraWorkPicker.currentElement = current
        }
        
        typeCameraWorkPicker.onSelected = {(element) in
            if let type = element as? TypeCameraWork {
                let index = (self.interactor?.typeCameraWork)!.lastIndex(of: type)
                self.interactor?.updateSelectedTypeCameraWork(index!)
            }
        }
        
        showPicker(typeCameraWorkPicker)
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event)
           self.view.endEditing(true)
    }
    
    //MARK: - Custom Picker
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.customPicker {
            return self.typesCameraWork.count
        }
        return 0
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.customPicker {
            return 1
        }
        else {
            return 1
        }
    }
     
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 25)
        label.textColor = .black
        label.textAlignment = .center
        if pickerView == self.customPicker {
          if self.typesCameraWork.count > 0 {
              label.text = "\(self.typesCameraWork[row].Title)"
          }
        }
        return label
    }
     
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    
    private func showPicker(){
        self.customPicker.isHidden = false
        self.closeButton.isHidden = false
        self.updateButton.isHidden = false
    }
    
    private func closePicker(){
        self.customPicker.isHidden = true
        self.closeButton.isHidden = true
        self.updateButton.isHidden = true
    }
    
    
    
    @objc func addCamera(){
        let alertController = UIAlertController(title: "Регистрация камеры", message: "Вам необходимо зарегистрировать камеру. Если вы используете CamDrive, пожалуйста введите MAC адрес с обратной стороны камеры. Если у вас камера другой марки, обратитесь в службу поддержки.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            let key = alertController.textFields?[0].text
            if( key == ""){
                alertWindow("Вы должны ввести код")
            }
            else{
                self.registerCamera(key: key!)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "введите номер камеры"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func registerCamera(key:String){
        if Connectivity.isConnectedToInternet {
            if let dict = self.interactor?.currentCamera {
                var paramDict = [String:Any]()

                paramDict["userId"] =  dict.userId
                paramDict["cameraId"] = dict.Id
                paramDict["key"] =  key
                paramDict["isTest"] =  "false"
                paramDict["isSuccess"] = "true"

                print(paramDict)

                guard let url = URL(string: cameraAdd) else {return}

                Alamofire.request(url,method: .get,parameters: paramDict).responseJSON{ (response) in
                           switch response.result {
                           case .success:
                               print(response)
                               let dictResponse = response.result.value as! NSDictionary
                               let is_success = dictResponse["success"] as! Bool
                               
                               if (!is_success){

                                   let alert = UIAlertController(title: "Ошибка", message: "Ошибка регистрации камеры! Повторите попытку или обратитесь в службу поддержки", preferredStyle: .alert)
                                   alert.view.tintColor = UIColor.black
                                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(void) in
                                                 return
                                   }))

                                   self.present(alert, animated: true, completion: nil)
                               }
                               else{
                                    self.interactor?.loadCamerasList()
                               }
                               break
                           case .failure(let error):
                               alertWindow(kCouldnotconnect)
                               print(error)
                           }

                       }
                   }
            } else {
                alertWindow(kInternetNotAvailable)
            }
    }
    
    
    
    //MARK: - ScreenPlayerProtocol
    public func openPlayer(_ player: BasePlayerProtocol, _ state: StateScreenPlayer) {
        if self.onlinePlayer == player as! NSObject {
            state == .short ? self.shortScreenOnlinePlayer() : self.fullScreenOnlinePlayer()
        }
        else if self.streamPlayer == player as! NSObject {
            state == .short ? self.shortSreenStreamPlayer() : self.fullScreenStreamPlayer()
        }
    }
    
    
    private func fullScreenOnlinePlayer(){
        self.onlineShortTopConstraint?.isActive = false
        self.onlineShortLeftConstraint?.isActive = false
        self.onlineShortRightConstraint?.isActive = false
        self.onlineShortBottomConstraint?.isActive = false
        
        self.onlineFullTopConstraint?.isActive = true
        self.onlineFullLeftConstraint?.isActive = true
        self.onlineFullRightConstraint?.isActive = true
        self.onlineFullBottomConstraint?.isActive = true
    }
    
    private func shortScreenOnlinePlayer(){
        self.onlineFullTopConstraint?.isActive = false
        self.onlineFullLeftConstraint?.isActive = false
        self.onlineFullRightConstraint?.isActive = false
        self.onlineFullBottomConstraint?.isActive = false
        
        self.onlineShortTopConstraint?.isActive = true
        self.onlineShortLeftConstraint?.isActive = true
        self.onlineShortRightConstraint?.isActive = true
        self.onlineShortBottomConstraint?.isActive = true
    }
    
    
    private func fullScreenStreamPlayer(){
        self.streamShortTopConstraint?.isActive = false
        self.streamShortLeftConstraint?.isActive = false
        self.streamShortRightConstraint?.isActive = false
        self.streamShortBottomConstraint?.isActive = false
        
        self.streamFullTopConstraint?.isActive = true
        self.streamFullLeftConstraint?.isActive = true
        self.streamFullRightConstraint?.isActive = true
        self.streamFullBottomConstraint?.isActive = true
    }
    
    private func shortSreenStreamPlayer(){
        self.streamFullTopConstraint?.isActive = false
        self.streamFullLeftConstraint?.isActive = false
        self.streamFullRightConstraint?.isActive = false
        self.streamFullBottomConstraint?.isActive = false
        
        self.streamShortTopConstraint?.isActive = true
        self.streamShortLeftConstraint?.isActive = true
        self.streamShortRightConstraint?.isActive = true
        self.streamShortBottomConstraint?.isActive = true
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopWorkPlayer()
    }
    
    func stopWorkPlayer(){
        self.currentPlayer?.pause()
        self.currentPlayer?.state = .short
    }
}
