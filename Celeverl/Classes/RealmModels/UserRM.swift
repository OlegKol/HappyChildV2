//
//  UserRM.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/4/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import RealmSwift

//MARK: - UserRM
public class UserRM: Object {
    
    @objc dynamic var Id: String = ""
    @objc dynamic var GroupId: String = ""
    @objc dynamic var IsGroupCreator: Bool = false
    @objc dynamic var Language:String = ""
    @objc dynamic var UserOnlineStreamingServiceUrl: String?
    @objc dynamic var TimeZoneOffsetInHours: String? = nil
    @objc dynamic var OnlineDataAnalysisSettings: String?
    @objc dynamic var DailyReportSettings: String?
    @objc dynamic var Email: String? = nil
    @objc dynamic var EmailConfirmed: Bool = false
    @objc dynamic var PhoneNumber: String? = nil
    @objc dynamic var PhoneNumberConfirmed: Bool = false
    @objc dynamic var UserName: String = ""
    
    override public static func primaryKey() -> String? {
        return "Id"
    }
    
    override public static func indexedProperties() -> [String] {
        return ["PhoneNumber","Id"]
    }
    
    public class func contertToUserRM(_ model: UserModel) -> UserRM {
        
        let user = UserRM()
        
        user.Id = model.Id
        user.GroupId = model.GroupId
        user.IsGroupCreator = model.IsGroupCreator
        user.Language = model.Language
        user.UserOnlineStreamingServiceUrl = model.UserOnlineStreamingServiceUrl
        user.TimeZoneOffsetInHours = model.TimeZoneOffsetInHours
        user.OnlineDataAnalysisSettings = model.OnlineDataAnalysisSettings
        user.DailyReportSettings = model.DailyReportSettings
        user.Email = model.Email
        user.EmailConfirmed = model.EmailConfirmed
        user.PhoneNumber = model.PhoneNumber
        user.PhoneNumberConfirmed = model.PhoneNumberConfirmed
        user.UserName = model.UserName
        
        return user
    }
    
    
    public func toUserModel() -> UserModel {
        
        let model = UserModel()
        
        model.Id = self.Id
        model.GroupId = self.GroupId
        model.IsGroupCreator = self.IsGroupCreator
        model.Language = self.Language
        model.UserOnlineStreamingServiceUrl = self.UserOnlineStreamingServiceUrl
        model.TimeZoneOffsetInHours = self.TimeZoneOffsetInHours
        model.OnlineDataAnalysisSettings = self.OnlineDataAnalysisSettings
        model.DailyReportSettings = self.DailyReportSettings
        model.Email = self.Email
        model.EmailConfirmed = self.EmailConfirmed
        model.PhoneNumber = self.PhoneNumber
        model.PhoneNumberConfirmed = self.PhoneNumberConfirmed
        model.UserName = self.UserName
        
        return model
    }
}
