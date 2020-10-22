//
//  AccountCD.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/22/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import CoreData

@objc public class AccountCD: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var account_id: String?
    @NSManaged public var first_name: String?
    @NSManaged public var last_name: String?
    @NSManaged public var phone: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var last_sign_in: Date?

}
