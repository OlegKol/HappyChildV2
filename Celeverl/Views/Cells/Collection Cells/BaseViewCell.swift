//
//  BaseViewCell.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class BaseViewCell: UICollectionViewCell, INotifyPropertyChanged {
    
    public var ListInvokes: [(String) -> Void] = []
    
    func OnPropertyChanged(_ propertyName: String) {
        for i in 0..<self.ListInvokes.count {
            self.ListInvokes[i](propertyName)
        }
    }
    
    static let resueseId: String = "BaseViewCell"
    
    public var BindingContext: AnyObject {
        didSet{
            OnPropertyChanged("BindingContext")
        }
    }
       
    public override init(frame: CGRect) {
        self.BindingContext = NSObject()
        super.init(frame: frame)
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateViewCell(){
        self.layer.layoutIfNeeded()
    }
    
    public func removeBindingProperties(){
        self.ListInvokes.removeAll()
    }
}
