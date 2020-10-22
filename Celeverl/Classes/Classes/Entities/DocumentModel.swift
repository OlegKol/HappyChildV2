//
//  DocumentModel.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class DocumentModel: Decodable {
    
    public var UrlToWatch: String? = nil
    public var dateStr: String? = nil{
        didSet{
            if let str = self.dateStr {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.date = formatter.date(from: str) ?? Date()
            } else {
                self.date = Date()
            }
        }
    }
    public var date: Date = Date()
    
    
    init() {
    }
    
    convenience init(dictionary: [String: Any]){
        self.init()
        self.dateStr = dictionary["Date"] as? String
        self.UrlToWatch = dictionary["UrlToWatch"] as? String
    }
    
    required public init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.UrlToWatch = try values.decode(String?.self, forKey: .UrlToWatch)
        self.dateStr = try values.decode(String.self, forKey: .dateStr)
        if let str = self.dateStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            self.date = formatter.date(from: str) ?? Date()
        }
    }
    
    enum CodingKeys : String, CodingKey {
        case dateStr = "Date"
        case UrlToWatch = "UrlToWatch"
    }
}
