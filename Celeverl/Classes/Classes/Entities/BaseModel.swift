
//  BaseEntity.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.


import Foundation

public class BaseModel:NSObject, INotifyPropertyChanged {
    
    public var IsSelected:Bool = false
    
    func OnPropertyChanged(_ propertyName: String) {
        for i in 0..<self.ListInvokes.count {
                   self.ListInvokes[i](propertyName)
        }
    }
    public var ListInvokes:[(String) -> Void] = []
    
    public override init() {
        super.init()
        self.ListInvokes.append(self.PropetyChanged(propertyName:))
    }
    
    public func PropetyChanged(propertyName: String){
        
    }
    
    
}
 
