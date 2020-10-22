//
//  FeedBackViewer.swift
//  Cleverl
//
//  Created by Евгений on 4/10/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class FeedBackViewer: UIViewController {
     
    
    //MARK: - Properties
        var titleView:UILabel = {
            var label = UILabel()
            label.textColor = AppConstants.APP_DEFAULT_TEXT_COLOR
            label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 22)
            return label
        }()
        
        public lazy var field: UITextView = {
            var field = UITextView()
            field.backgroundColor = UIColor(red: 0.929, green: 0.929, blue: 0.929, alpha: 1)
            field.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 16)
            field.keyboardType = .default
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
    
        public lazy var sendFeedBackButton: AppCustomButton = {
            var button = AppCustomButton()
            button.tintColor = .white
            button.titleLabel?.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
            button.backgroundColor = AppConstants.APP_DEFAULT_TEXT_COLOR
            button.layer.cornerRadius = 10
            button.title = "Отправить"
            return button
        }()
    
        var errorTitleView: UILabel = {
           var label = UILabel()
           label.textColor = .systemRed
           label.numberOfLines = 0
           label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 18)
           return label
        }()
        
        
        override public func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            self.configuareViews()
            self.registerForKeyboardNotifications()
        }
        
        
        //MARK: - Confgiaure Views
        private func configuareViews(){
            self.configuareTitleView()
            self.configuareTextField()
            self.configuareAnswerAPI()
            self.configuareSendButton()
            self.configuareBusyView()
        }
        
        private func configuareTitleView(){
            
            self.view.addSubview(self.titleView)
            self.titleView.text = "Форма обратной связи"
            
            self.titleView.translatesAutoresizingMaskIntoConstraints = false
            self.titleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
            self.titleView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
            self.titleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        }
        
        func configuareTextField() {
            self.view.addSubview(self.field)
            self.field.translatesAutoresizingMaskIntoConstraints = false
            self.field.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 10).isActive = true
            self.field.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
            self.field.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
            self.field.heightAnchor.constraint(equalToConstant: 300).isActive = true
        }
        
        private func configuareSendButton(){
            self.view.addSubview(self.sendFeedBackButton)
            self.sendFeedBackButton.translatesAutoresizingMaskIntoConstraints = false
            self.sendFeedBackButton.title = "Отправить"
            self.sendFeedBackButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.sendFeedBackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            self.sendFeedBackButton.widthAnchor.constraint(equalToConstant: 174).isActive = true
            self.sendFeedBackButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
            self.sendFeedBackButton.Action = {(_) in
                self.sendFeedBack()
            }
        }
    
        private func configuareAnswerAPI(){
            self.view.addSubview(self.errorTitleView)
            self.errorTitleView.textAlignment = .center

            self.errorTitleView.translatesAutoresizingMaskIntoConstraints = false
            self.errorTitleView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
            self.errorTitleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.errorTitleView.topAnchor.constraint(equalTo: self.field.bottomAnchor, constant: 10).isActive = true
            self.errorTitleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
    
    
    
    func sendFeedBack(){
        self.busyView.startAnimating()
        guard let account = AccountService.shared.currentAccount, let message = self.field.text else { self.busyView.stopAnimating(); return }
        DispatchQueue.global().async {
            do {
                let result = try API.sendFeedBack(from: account.Id, text: message)
                DispatchQueue.main.async {
                    if(result) {
                        self.errorTitleView.textColor = .systemGreen
                        self.errorTitleView.text = "Отзыв успешно отправлен"
                    }
                    else {
                        self.errorTitleView.textColor = .systemRed
                        self.errorTitleView.text = "Возникла ошибка. Попробуйте позже"
                    }
                   let time = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { timer in
                    self.errorTitleView.text = ""
                   })
                }
            }
            catch let error {
                    
            }
            DispatchQueue.main.async {
                self.busyView.stopAnimating()
                self.field.text = ""
            }
        }
    }
}




public class API {
    
    public static func sendFeedBack(from userId: String, text: String) throws -> Bool {
        var result: Bool = false

        var urlComponent = URLComponents(string: "https://happychild.tech/api/MobileAppFeedback")
        urlComponent?.queryItems = [
            URLQueryItem(name: "userId", value: userId),
            URLQueryItem(name: "text", value: text)
        ]

        let response = NetworkService.getAsync(urlComponent!)

        if response.error != nil {
            throw CustomError.invalid(message: response.error!.localizedDescription)
        }
        if let data = response.data {
            let json = try! JSONSerialization.jsonObject(with:data, options :[]) as! [String:Any]
            result = json["success"] as? Bool ?? false
        }
        return result
    }
}


extension UITextView{

    func setPlaceholder() {

        let placeholderLabel = UILabel()
        placeholderLabel.text = "Оставьте ваш комментарий или пожелание о работе приложения"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
    }

    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }

}
