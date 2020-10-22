//
//  RealmService.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/4/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import RealmSwift


//MARK: - RealmService
public class RealmService: NSObject {
    
    public static var shared: RealmService = RealmService()
    private var queue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    
    private override init() {
        super.init()
    }
    
    public func writeUser(_ user: UserRM) -> Bool{
        var result = false
        let semaphore = DispatchSemaphore(value: 0)
        self.queue.async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(user)
                result = true
                semaphore.signal()
            }
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return result
    }
    
    public func getAllUsers() -> Results<UserRM> {
        
        var users:Results<UserRM>?
        let semaphore = DispatchSemaphore(value: 0)
        self.queue.async {
            let realm = try! Realm()
            users = realm.objects(UserRM.self)
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return users!
    }
    
    public func deleteAllUsers(){
        let semaphore = DispatchSemaphore(value: 0)
        self.queue.async {
            let realm = try! Realm()
            let users = realm.objects(UserRM.self)
            try! realm.write {
                realm.delete(users)
                semaphore.signal()
            }
        }
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    public func hasAccount() -> Bool {
        var result = false
        if self.getAccount() != nil {
           result = true
        }
        return result
    }
    
    public func getAccount() -> UserModel? {
        
        var user: UserModel? = nil
        let semaphore = DispatchSemaphore(value: 0)
        self.queue.async {
            let realm = try! Realm()
            let data = realm.objects(UserRM.self).first
            user = data?.toUserModel()
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return user
    }
    
}
