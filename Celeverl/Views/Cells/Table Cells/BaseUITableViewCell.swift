//
//  BaseUITableViewCell.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/25/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class BaseUITableViewCell: UITableViewCell, INotifyPropertyChanged {
    
    public var ListInvokes: [(String) -> Void] = []
    
    func OnPropertyChanged(_ propertyName: String) {
       for i in 0..<self.ListInvokes.count {
           self.ListInvokes[i](propertyName)
       }
    }
    
    public var BindingContext: AnyObject = NSObject() {
       didSet{
           OnPropertyChanged("BindingContext")
       }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
