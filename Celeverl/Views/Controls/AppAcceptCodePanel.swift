//
//  AppLogInPanel.swift
//  HappyChild
//
//  Created by Евгений on 11/11/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

//MARK: - AppAcceptCodePanel
public class AppAcceptCodePanel: UIView {
    
    //MARK: - Properties
    public var title: UILabel = {
        var label = UILabel()
        return label
    }()
    public var field: UITextField = {
        var field = UITextField()
        return field
    }()
    public var sendCodeButton: AppCustomButton = {
        var button = AppCustomButton()
        return button
    }()
    public var errorLabel: UILabel = {
        var label = UILabel()
        return label
    }()
    
    public var titleText:String = "" {
        didSet{
            self.title.text = self.titleText
        }
    }
    
    public var errorText: String = "" {
        didSet{
            self.errorLabel.text = self.errorText
        }
    }
    
    public var placeHolderText: String = "" {
        didSet{
            self.field.placeholder = self.placeHolderText
        }
    }
    
    public var buttonText: String = "" {
        didSet{
            self.sendCodeButton.title = self.buttonText
        }
    }
    
    public var errorTextColor: UIColor = .red {
        didSet{
            self.errorLabel.textColor = self.errorTextColor
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.createPanel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - ConfiguareFunctions
    private func createPanel(){
        
        self.addSubview(self.title)
        self.configuareTitle()
        
        
        self.addSubview(self.field)
        self.configuareTextField()
        
        self.addSubview(self.sendCodeButton)
        self.configuareSendButton()
        
        self.addSubview(self.errorLabel)
        self.configuareErrorLabel()
    }
    
    open func configuareTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 50).isActive = true
        title.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 20)
        title.textColor = .black
        title.lineBreakMode = .byTruncatingHead
        title.numberOfLines = 1
    }
    
    open func configuareTextField() {
        field.translatesAutoresizingMaskIntoConstraints = false
        field.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 20).isActive = true
        field.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        field.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.backgroundColor = UIColor(red: 0.929, green: 0.929, blue: 0.929, alpha: 1)
        field.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = UITextField.ViewMode.always
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 10
        field.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 20)
    }
    
    open func configuareSendButton(){
        sendCodeButton.translatesAutoresizingMaskIntoConstraints = false
        sendCodeButton.topAnchor.constraint(equalTo: self.field.bottomAnchor, constant: 20).isActive = true
        sendCodeButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        sendCodeButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        sendCodeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendCodeButton.tintColor = .white
        sendCodeButton.titleLabel?.font = UIFont(name: AppConstants.APP_AVENIR_BOLD, size: 18)
        sendCodeButton.layer.cornerRadius = 10
    }
    
    open func configuareErrorLabel(){
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.topAnchor.constraint(equalTo: self.sendCodeButton.bottomAnchor, constant: 10).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorLabel.font = UIFont(name:AppConstants.APP_AVENIR_BOLD, size: 18)
        errorLabel.textColor = .clear
        errorLabel.numberOfLines = 3
    }
    
    
    //MARK: - ErrorFunctions
    func hideError(){
        CATransaction.begin()
        let hideTextAnimation = CABasicAnimation(keyPath: "textColor")
        hideTextAnimation.fromValue = self.errorLabel.textColor
        hideTextAnimation.toValue = UIColor.clear
        hideTextAnimation.duration = 1
        self.errorLabel.layer.add(hideTextAnimation, forKey: nil)
        
        CATransaction.setCompletionBlock({
            self.errorLabel.textColor = UIColor.clear
        })
        CATransaction.commit()
    }
    
    func showError(){
        CATransaction.begin()
        let showErrorTextAnimation = CABasicAnimation(keyPath: "textColor")
        showErrorTextAnimation.fromValue = self.errorLabel.textColor
        showErrorTextAnimation.toValue = self.errorTextColor
        showErrorTextAnimation.duration = 1
        self.errorLabel.layer.add(showErrorTextAnimation, forKey: nil)
        CATransaction.setCompletionBlock({
            self.errorLabel.textColor = self.errorTextColor
        })
        CATransaction.commit()
    }
}
