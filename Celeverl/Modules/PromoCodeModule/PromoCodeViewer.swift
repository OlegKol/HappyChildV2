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
public class PromoCodeViewer: UIViewController, PromoCodeViewerProtocol, UITextFieldDelegate {
    
    public var interactor: PromoCodeInteractorProtocol?
    public var router: PromoCodeRouterProtocol?
    
    public func showMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorTitleView.textColor = .systemGreen
            self.errorTitleView.text = message
        }
    }
    
    public func showError(_ error: String) {
        DispatchQueue.main.async {
            self.errorTitleView.text = error
        }
    }
    
    public func hideError() {
        
    }
    
    public func changedBusyState(_ state: Bool) {
        DispatchQueue.main.async {
            if (state) {
                self.busyView.startAnimating()
            } else {
                self.busyView.stopAnimating()
            }
        }
    }
    
    //MARK: - Properties
    var titleView:UILabel = {
        var label = UILabel()
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 22)
        return label
    }()
    
    var titleCodeView:UILabel = {
        var label = UILabel()
        label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 18)
        return label
    }()
    
    var errorTitleView: UILabel = {
        var label = UILabel()
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 18)
        return label
    }()
    
    public lazy var field: UITextField = {
        var field = UITextField()
        field.backgroundColor = UIColor(red: 0.929, green: 0.929, blue: 0.929, alpha: 1)
        field.layer.cornerRadius = 10
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.leftViewMode = UITextField.ViewMode.always
        field.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
        field.keyboardType = .default
        field.placeholder = "Введите код"
        field.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        return field
    }()
    
    public var busyView: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView()
        view.style = .large
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.85)
        view.color = .white
        return view
    }()
    public lazy var codeButton: AppCustomButton = {
        var button = AppCustomButton()
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
        button.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configuareViews()
        self.registerForKeyboardNotifications()
    }
    
    
    //MARK: - Confgiaure Views
    private func configuareViews(){
        self.configuareTitleView()
        self.configuareCodeTitleView()
        self.configuareTextField()
        self.configuareSendButton()
        self.configuareErrorTitleView()
        self.configuareBusyView()
    }
    
    private func configuareTitleView(){
        
        self.view.addSubview(self.titleView)
        self.titleView.text = "Промокоды"
        self.titleView.textAlignment = .center
        
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.titleView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.titleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    private func configuareCodeTitleView(){
        
        self.view.addSubview(self.titleCodeView)
//        self.titleCodeView.text = "Введите код"
        self.titleCodeView.textAlignment = .center
        
        self.titleCodeView.translatesAutoresizingMaskIntoConstraints = false
        self.titleCodeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.titleCodeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.titleCodeView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 150).isActive = true
    }
    
     func configuareTextField() {
        
        self.view.addSubview(self.field)
        
        self.field.translatesAutoresizingMaskIntoConstraints = false
        self.field.topAnchor.constraint(equalTo: self.titleCodeView.bottomAnchor, constant: 30).isActive = true
        self.field.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.field.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.field.addTarget(self, action: #selector(changedCodeField), for: .editingChanged)
    }
    
    private func configuareSendButton(){
        self.view.addSubview(self.codeButton)
        
        self.codeButton.translatesAutoresizingMaskIntoConstraints = false
        self.codeButton.title = "Отправить"
        
        self.codeButton.translatesAutoresizingMaskIntoConstraints = false
        self.codeButton.topAnchor.constraint(equalTo: self.field.bottomAnchor, constant: 20).isActive = true
        self.codeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.codeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.codeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.codeButton.Action = {(_) in
            self.interactor?.checkCode()
        }
    }
    
    private func configuareErrorTitleView(){
        
        self.view.addSubview(self.errorTitleView)
        self.errorTitleView.textAlignment = .center
        
        self.errorTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.errorTitleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        self.errorTitleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.errorTitleView.topAnchor.constraint(equalTo: self.codeButton.bottomAnchor, constant: 10).isActive = true
    }
    
    
    @objc private func changedCodeField() {
        guard let textCode = self.field.text else {return }
        self.errorTitleView.text = ""
        self.interactor?.changeCode(textCode)
    }
    
    private func configuareBusyView(){
        self.view.addSubview(self.busyView)
        self.busyView.translatesAutoresizingMaskIntoConstraints = false
        self.busyView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.busyView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.busyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.busyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event)
           self.view.endEditing(true)
    }
    
    
    //MARK: - Text field functions
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    @objc func handleKeyboardNotification( notification: NSNotification){
       
//       var pointY:CGFloat = 0.0
//
//       if notification.name == UIResponder.keyboardWillShowNotification, let userInfo = notification.userInfo {
//            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//            pointY = -frame.height
//       }
//       else if notification.name == UIResponder.keyboardWillHideNotification {
//           pointY = 0
//       }
//
//       UIView.animate(withDuration: 0.2, animations: {
//           self.view.frame.origin.y = pointY
//       })
    }

    func registerForKeyboardNotifications(){
       NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterForKeyboardNotifications(){
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    deinit {
       self.unregisterForKeyboardNotifications()
    }
}
