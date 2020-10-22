//
//  INotifyPropertyChage.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation

protocol INotifyPropertyChanged: class {
    func OnPropertyChanged(_ propertyName: String)
    var ListInvokes:[(_ propetyName:String)-> Void] {get set}
}
