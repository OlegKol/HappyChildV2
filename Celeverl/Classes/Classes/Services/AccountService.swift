//
//  AccountsService.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/22/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import CoreData
import UIKit


//MARK: - AccountsService
public class AccountService: NSObject {
    
    public static var shared: AccountService = AccountService()
    
    private var realmService: RealmService = RealmService.shared
    private var appDelegate: AppDelegate?
    private var account: UserModel?
    
    private override init() {
        super.init()
    }
    
    public func writeAccount(_ account: UserModel) throws {
        self.account = account
    }
    
    
    public var currentAccount: UserModel? {
        get{
            return self.account
        }
    }
    
}
