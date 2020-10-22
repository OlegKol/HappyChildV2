//
//  UserInfoModel.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/12/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class UserInfoModel: NSObject {
    
    var Id: String = ""
    var Name: String = ""
    var LastName: String = ""
    var Phone: String? = ""
    var BirthDay: Date?
    var code: String = ""
    
    convenience init(dictionary: [String:Any]) {
        self.init()
        self.Id = dictionary["Id"] as? String ??  UUID().uuidString
        self.Name = dictionary["FirstName"] as? String ?? ""
        self.LastName = dictionary["LastName"] as? String ?? ""
        self.Phone = dictionary["phone"] as? String ?? ""
        self.BirthDay = dictionary["birthday"] as? Date ?? Date()
    }
    
    override init(){
        super.init()
        
    }
}
