//
//  SettingsModel.swift
//  Cleverl
//
//  Created by Евгений on 2/16/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

//MARK: - SettingsModel
public class SettingsModel: BaseModel, Codable {
    
    public var TimeZoneOffsetInHours: Int = 0
    public var CameraConnections: [CameraConntection] = []
}



public class CameraConntection: Codable {
    public var Id: String = ""
    public var Url: String?
    public var CameraName: String = ""
    public var IsActive: Bool = false
    public var DateStart: Date?
    public var DateEnd: Date?
    public var StartHour: Int = 0
    public var EndHour: Int = 0
    public var NextRefreshingDateUts: Date?
    public var SelectedDays: String?
    public var type: Int = 0
    public var ProviderCameraUid: String?
    public var IsForWholeDay: Bool = false
    public var DateStartStr: String = ""
    public var DateEndStr: String = ""
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case Id
        case Url
        case CameraName
        case IsActive
        case DateStart
        case DateEnd
        case StartHour
        case EndHour
        case NextRefreshingDateUts
        case SelectedDays
        case ProviderCameraUid
        case IsForWholeDay
        case DateStartStr
        case DateEndStr
    }
    
    required public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let forrmater = DateFormatter()
        forrmater.dateFormat = "dd.MM.yyyy"
        
        Id = try values.decode(String.self, forKey: .Id)
        Url = try values.decode(String?.self, forKey: .Url)
        CameraName = try values.decode(String.self, forKey: .CameraName)
        IsActive = try values.decode(Bool.self, forKey: .IsActive)
        
        StartHour = try values.decode(Int.self, forKey: .StartHour)
        EndHour = try values.decode(Int.self, forKey: .EndHour)
        
        let refreshDate = try values.decode(String.self, forKey: .NextRefreshingDateUts)
        NextRefreshingDateUts = forrmater.date(from: refreshDate)
        
        SelectedDays = try values.decode(String?.self, forKey: .SelectedDays)
        type = try values.decode(Int.self, forKey: .type)
        ProviderCameraUid = try values.decode(String?.self, forKey: .ProviderCameraUid)
        IsForWholeDay = try values.decode(Bool.self, forKey: .IsForWholeDay)
        DateStartStr = try values.decode(String.self, forKey: .DateStartStr)
        DateEndStr = try values.decode(String.self, forKey: .DateEndStr)
        
        DateStart = forrmater.date(from: self.DateStartStr)
        DateEnd = forrmater.date(from: self.DateEndStr)
    }
}
