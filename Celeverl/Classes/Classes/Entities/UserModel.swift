//
//  UserModel.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/26/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public class UserModel: BaseModel, Codable {
    
    public var Id:String = ""
    public var GroupId: String = ""
    public var IsGroupCreator: Bool = false
    public var Language:String = ""
    public var UserOnlineStreamingServiceUrl: String?
    public var TimeZoneOffsetInHours: String? = nil
    public var Balance: Balance?
    public var OnlineDataAnalysisSettings: String?
    public var DailyReportSettings: String?
    public var TasksForNanny: [String]?
    public var Email: String? = nil
    public var EmailConfirmed: Bool = false
    public var PhoneNumber: String? = nil
    public var PhoneNumberConfirmed: Bool = false
    public var UserName: String = ""
    public var CameraConnections: [cameraModel] = []
    public var Children: [UserModel]?
    
    override init(){
        super.init()
    }
    
    convenience init(_ dictionary: [String: Any]) {
        self.init()
        self.Id = dictionary["Id"] as? String ?? ""
        self.GroupId = dictionary["GroupId"] as? String ?? ""
        self.UserName = dictionary["UserName"] as? String ?? ""
        self.PhoneNumber = dictionary["PhoneNumber"] as? String ?? ""
        self.Email = dictionary["Email"] as? String ?? ""
        self.IsGroupCreator = dictionary["IsGroupCreator"] as? Bool ?? false
        self.Language = dictionary["Language"] as? String ?? ""
        self.TimeZoneOffsetInHours = dictionary["TimeZoneOffsetInHours"] as? String ?? nil
        let cameraList = dictionary["CameraConnections"] as! [[String:Any]]
        self.CameraConnections = cameraList.compactMap {return cameraModel(from: $0)}
    }
}


public class cameraModel: BaseModel, Codable {
    public var Id: String = ""
    public var Url: String? = ""
    public var CameraName: String? = ""
    public var IsActive: Bool = false
    public var DateStart: Date? = Date()
    public var DateEnd: Date? = Date()
    public var StartHour: Int? = nil
    public var EndHour: Int?  = nil
    public var NextRefreshingDateUts: String? = nil
    public var SelectedDays: [Int] = []
    public var TypeCamera: Int = 0
    public var IsForWholeDay: Bool = false
    public var DateStartStr: String = ""
    public var DateEndStr: String = ""
    
    private enum CodingKeys : String, CodingKey {
       case TypeCamera = "Type"
    }
    
    override init(){
        super.init()
    }
    convenience init(from dictionary: [String:Any]){
        self.init()
        self.Id = dictionary["Id"] as? String ?? ""
        self.Url = dictionary["Url"] as? String ?? ""
        self.CameraName = dictionary["CameraName"] as? String ?? ""
        self.IsActive = dictionary["IsActive"] as? Bool ?? false
        self.DateStart = dictionary["DataStart"] as? Date ?? nil
        self.DateEnd = dictionary["DateEnd"] as? Date ?? nil
        self.StartHour = dictionary["StartHour"] as? Int ?? 0
        self.EndHour = dictionary["EndHour"] as? Int ?? 0
        self.NextRefreshingDateUts = dictionary["NextRefreshingDateUts"] as? String
        self.TypeCamera = dictionary["TypeCamera"] as? Int ?? 0
    }
} 

public class Balance: BaseModel, Codable {
    public var Id: String = ""
    public var HappyChildAnalysisHours: Int = 0
    public var DateStart: Date = Date()
    public var DateEnd: Date = Date()
    public var ChangeHistory: [String] = []
    public var DateEndStr: String = ""
}



