//
//  CountryCodeModel.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/11/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class CountryCodeModel:BaseModel {
    
    public var Id:String = ""
    public var Title:String = ""
    public var Code: Int = 0
    
    public convenience init(id: String, title: String, code: Int){
        self.init()
        self.Id = id
        self.Title = title
        self.Code = code
    }
    
    public override init() {
        super.init()
        self.Id = ""
        self.Title = ""
        self.Code = 0
    }
}
