//
//  CameraTypeWork.swift
//  Cleverl
//
//  Created by Евгений on 3/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class CameraTypeWork: BaseModel {

    public var Title: String = ""
    public var Id: Int = 0
    
    public override init() {
        super.init()
    }
    
    convenience init(title: String, Id:Int){
        self.init()
        self.Id = Id
        self.Title = title
        super.IsSelected = false
    }
}
