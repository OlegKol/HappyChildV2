//
//  Camera.swift
//  HappyChild
//
//  Created by Евгений on 11/14/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation

public class CameraModel: BaseModel, Codable {
    
    public var Id: String
    public var Url:String
    public var ProviderCameraUid: String
    public var userId:String
    public var utsOffset:Int
    
    private enum CodingKeys: String, CodingKey {
        case Id
        case Url
        case ProviderCameraUid
        case userId
        case utsOffset
    }
    
    override init() {
        self.Id = ""
        self.Url = ""
        self.ProviderCameraUid = ""
        self.userId = ""
        self.utsOffset = 0
    }
    
    required public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.Id = try values.decode(String.self, forKey: .Id)
        self.Url = try values.decode(String.self, forKey: .Url)
        self.ProviderCameraUid = try values.decode(String.self, forKey: .ProviderCameraUid)
        self.userId = try values.decode(String.self, forKey: .userId)
        self.utsOffset = try values.decode(Int.self, forKey: .utsOffset)
    }
    
    convenience init(dic: [String:Any]){
        self.init()
        self.Id = dic["Id"] as? String ?? ""
        self.Url = dic["Url"] as? String ?? ""
        self.ProviderCameraUid = dic["ProviderCameraUid"] as? String ?? ""
        self.userId = dic["userId"] as? String ?? ""
        self.utsOffset = dic["utsOffset"] as? Int ?? 0
    }

}
