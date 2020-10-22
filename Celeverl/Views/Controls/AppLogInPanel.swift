//
//  AppLogInPanel.swift
//  HappyChild
//
//  Created by Евгений on 11/11/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

//MARK: - LognInPanel
public class LognInPanel: UIView {
    
    //MARK: - Views
    public var title: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    public var field: UITextField = {
        var field = UITextField()
        field.backgroundColor = UIColor(red: 0.929, green: 0.929, blue: 0.929, alpha: 1)
        field.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        field.layer.cornerRadius = 10
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: field.frame.height))
        field.leftViewMode = UITextField.ViewMode.always
        return field
    }()
    public var button: AppCustomButton = {
        var button = AppCustomButton()
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        return button
    }()
    public var codeButton: AppCustomButton = {
        var button = AppCustomButton()
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        return button
    }()
    public var errorLabel:UILabel = {
        var label = UILabel()
        label.textColor = .systemRed
        label.numberOfLines = 0
        return label
    }()
    public var agreementTitleView: UILabel = {
       var label = UILabel()
       label.textColor = .systemGray
       label.numberOfLines = 0
       label.textAlignment = .center
       return label
    }()
    
    //MARK: - Properties
    public var errorTextColor: UIColor = .red {
        didSet{
            self.errorLabel.textColor = self.errorTextColor
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.configuarePanel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Configaure functions
    private func configuarePanel(){
        
        self.addSubview(self.title)
        self.configuareTitle()
        
        self.addSubview(self.button)
        self.configuareButton()
        
        self.addSubview(self.field)
        self.configuareTextField()
        
        self.addSubview(self.codeButton)
        self.configuareSendButton()
        

        self.addSubview(self.agreementTitleView)
        self.cogfiguareAgreementView()
        
        self.addSubview(self.errorLabel)
        self.configuareErrorLabel()
    }
    
    open func configuareTitle() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.title.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.title.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    open func configuareButton() {
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 32).isActive = true
        self.button.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    open func configuareTextField() {
        self.field.translatesAutoresizingMaskIntoConstraints = false
        self.field.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 32).isActive = true
        self.field.leftAnchor.constraint(equalTo: self.button.rightAnchor, constant: 0).isActive = true
        self.field.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        self.field.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    open func configuareSendButton(){
        self.codeButton.translatesAutoresizingMaskIntoConstraints = false
        self.codeButton.topAnchor.constraint(equalTo: self.field.bottomAnchor, constant: 24).isActive = true
        self.codeButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.codeButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.codeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    open func cogfiguareAgreementView(){

        self.agreementTitleView.translatesAutoresizingMaskIntoConstraints = false
        self.agreementTitleView.topAnchor.constraint(equalTo:codeButton.bottomAnchor, constant: 20).isActive = true
        self.agreementTitleView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.agreementTitleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.agreementTitleView.isUserInteractionEnabled = true
    }
    
    open func configuareErrorLabel(){
        self.errorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.errorLabel.topAnchor.constraint(equalTo: self.agreementTitleView.bottomAnchor, constant: 20).isActive = true
        self.errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.errorLabel.bottomAnchor.constraint(equalTo:self.bottomAnchor , constant: -10).isActive = true
       
    }
    
    //MARK: - Animation functions
    func HideError(){
        CATransaction.begin()
        let hideTextAnimation = CABasicAnimation(keyPath: "textColor")
        hideTextAnimation.fromValue = self.errorLabel.textColor
        hideTextAnimation.toValue = UIColor.clear
        hideTextAnimation.duration = 1
        CATransaction.setCompletionBlock({
            self.errorLabel.textColor = UIColor.clear
        })
        CATransaction.commit()
    }
    
    func ShowError(){
        CATransaction.begin()
        let showErrorTextAnimation = CABasicAnimation(keyPath: "textColor")
        showErrorTextAnimation.fromValue = self.errorLabel.textColor
        showErrorTextAnimation.toValue = self.errorTextColor
        showErrorTextAnimation.duration = 1
        CATransaction.setCompletionBlock({
            self.errorLabel.textColor = self.errorTextColor
        })
        CATransaction.commit()
    }
    
}
