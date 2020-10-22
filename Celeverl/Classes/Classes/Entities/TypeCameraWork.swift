//
//  TypeCameraWork.swift
//  Cleverl
//
//  Created by Евгений on 5/2/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class TypeCameraWork: NSObject {
    
    public var Id: String
    public var Title: String
    
    init(_ title: String){
        self.Id = UUID().uuidString
        self.Title = title
    }
}
