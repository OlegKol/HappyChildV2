//
//  NotificationEntity.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/3/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class NotificationModel: Decodable {
    
    var Id: String
    var title: String
    var description: String
    var typeNotify: Int
    var creationTimeUsers: String?
    var usersDateStr: String?
    var urlVideo: String?
    var userId: String?
    var hasBeenSentToUser: Bool
    var ExtraData: String?
    
    convenience init(dictionary: [String: Any]){
        self.init()
        self.Id = dictionary["PseudoId"] as? String ?? ""
        self.typeNotify = dictionary["Type"] as? Int ?? 0
        self.creationTimeUsers = dictionary["CreationTimeUsers"] as? String
        self.title = dictionary["Header"] as? String ?? "Simple Title"
        self.description = dictionary["Message"] as? String ?? "Description"
        self.usersDateStr = dictionary["UsersDateStr"] as? String
        self.urlVideo = dictionary["UrlToWatchVideo"] as? String
        self.userId = dictionary["ApplicationUserId"] as? String
        self.hasBeenSentToUser = dictionary["HasBeenSentToUser"] as? Bool ?? false
    }
    
    init(){
        self.Id = ""
        self.title = ""
        self.description = ""
        self.typeNotify = 0
        self.hasBeenSentToUser = false
    }
    
    enum CodingKeys : String, CodingKey {
        case Id = "PseudoId"
        case typeNotify = "Type"
        case creationTimeUsers = "CreationTimeUsers"
        case title = "Header"
        case description = "Message"
        case usersDateStr = "UsersDateStr"
        case urlVideo = "UrlToWatchVideo"
        case userId = "ApplicationUserId"
        case hasBeenSentToUser = "HasBeenSentToUser"
        case ExtraData = "ExtraData"
    }
    
    public func getId() -> String {
        return self.Id
    }

}
