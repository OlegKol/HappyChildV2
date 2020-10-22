//
//  CameraViewCell.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class NotificationViewCell: BaseUITableViewCell {
    
    static let resueseId: String = "NotificationViewCell"
    
    private var titleView: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: AppConstants.APP_ROBOTO_BOLD, size: 16)
        label.textColor = AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
        return label
    }()
    
    private var descriptionView: UILabel = {
       var label = UILabel()
       label.numberOfLines = 0
       label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
       label.textColor =  AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
       return label
    }()
    
    private var additiontTextView: UILabel = {
       var label = UILabel()
       label.numberOfLines = 0
       label.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
       label.textColor =  AppConstants.APP_DEFAULT_DARK_BLUE_COLOR
       return label
    }()
    
    public var backView: UIView = {
        var back = UIView()
        back.layer.cornerRadius = 8
        back.layer.masksToBounds = true
        back.backgroundColor = .systemGreen
        return back
    }()
    
    public var dataView: UILabel = {
        var dataLabel = UILabel()
        dataLabel.font = UIFont(name: AppConstants.APP_ROBOTO_REGULAR, size: 14)
        dataLabel.textColor = UIColor.init(hex: "#868686", alpha: 1)
        return dataLabel
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MenuTableViewCell.self.resueseId)
        self.configuareViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func OnPropertyChanged(_ propertyName: String) {
        if propertyName == "BindingContext" {
            self.updateView()
        }
    }
    
    private func updateView(){
        guard let model = self.BindingContext as? NotificationModel else { return }
        
        self.titleView.text = model.title
        self.descriptionView.text = model.description
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        if let date = formatter.date(from: model.usersDateStr!) {
            let shortTime = DateFormatter()
            shortTime.dateFormat = "HH:mm"
            self.dataView.text = shortTime.string(from: date)
        }
        self.additiontTextView.text = model.ExtraData
    }
    
    func data(fromHexaStr hexaStr: String) -> Data? {
        var data = Data(capacity: hexaStr.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: hexaStr, range: NSMakeRange(0, hexaStr.utf16.count)) { match, flags, stop in
            let byteString = (hexaStr as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        return data
    }
    
    private func configuareViews(){
        self.confgiaureBackView()
        self.configuareTitleView()
        self.configuareDescriptionView()
        self.configuareAdditionView()
        self.configuareDataView()
    }
    
    private func configuareTitleView(){
        self.addSubview(self.titleView)
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        self.titleView.leftAnchor.constraint(equalTo: self.backView.leftAnchor, constant: 16).isActive = true
        self.titleView.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 16).isActive = true
        self.titleView.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -16).isActive = true
    }
    
    private func configuareDescriptionView(){
        self.addSubview(self.descriptionView)
        self.descriptionView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionView.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -16).isActive = true
        self.descriptionView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 16).isActive = true
        self.descriptionView.leftAnchor.constraint(equalTo: self.backView.leftAnchor, constant: 16).isActive = true
    }
    
    private func configuareAdditionView(){
        self.addSubview(self.additiontTextView)
        self.additiontTextView.translatesAutoresizingMaskIntoConstraints = false
        self.additiontTextView.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -16).isActive = true
        self.additiontTextView.topAnchor.constraint(equalTo: self.descriptionView.bottomAnchor, constant: 5).isActive = true
        self.additiontTextView.leftAnchor.constraint(equalTo: self.backView.leftAnchor, constant: 16).isActive = true
    }
    
    private func confgiaureBackView(){
        self.addSubview(self.backView)
        self.backView.translatesAutoresizingMaskIntoConstraints = false
        self.backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.backView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        self.backView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        self.backView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        self.backView.backgroundColor = .white
    }
    
    private func configuareDataView(){
        self.addSubview(self.dataView)
        self.dataView.translatesAutoresizingMaskIntoConstraints = false
        self.dataView.topAnchor.constraint(equalTo: self.additiontTextView.bottomAnchor, constant: 5).isActive = true
        self.dataView.bottomAnchor.constraint(equalTo: self.backView.bottomAnchor, constant: -16).isActive = true
        self.dataView.rightAnchor.constraint(equalTo: self.backView.rightAnchor, constant: -16).isActive = true
    }
}

extension String {

    func hexaDecoededString(characters : String) -> String {

        var newData = Data()
        var emojiStr: String = ""
        for char in characters {

            let str = String(char)
            if str == "\\" || str.lowercased() == "x" {
                emojiStr.append(str)
            }
            else if emojiStr.hasPrefix("\\x") || emojiStr.hasPrefix("\\X") {
                emojiStr.append(str)
                if emojiStr.count == 4 {
                    /// It can be a hexa value
                    let value = emojiStr.replacingOccurrences(of: "\\x", with: "")
                    if let byte = UInt8(value, radix: 16) {
                        newData.append(byte)
                    }
                    else {
                        newData.append(emojiStr.data(using: .utf8)!)
                    }
                    /// Reset emojiStr
                    emojiStr = ""
                }
            }
            else {
                /// Append the data as it is
                newData.append(str.data(using: .utf8)!)
            }
        }

        let decodedString = String(data: newData, encoding: String.Encoding.utf8)
        return decodedString ?? ""
    }
}
