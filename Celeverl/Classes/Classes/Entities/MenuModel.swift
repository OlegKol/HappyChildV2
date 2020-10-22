//
//  MenuTableItemModel.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/25/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public class MenuModel: BaseModel {
    
    public var Id: Int = 0
    public var Name: String = ""
    public var Image: String = ""
    public var typePage: TypePage = TypePage.Camera
    
    init(id: Int, name: String, image:String, typePage: TypePage){
        self.Id = id
        self.Name = name
        self.Image = image
        self.typePage = typePage
    }
}

public enum TypePage {
    case Camera
    case Setting
    case Profile
    case Documents
    case Tasks
    case Balance
    case Help
    case PromoCode
    case FeedBack
}

