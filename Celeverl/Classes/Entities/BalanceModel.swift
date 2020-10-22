//
//  BalanceModel.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/20/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

//MARK: - BalanceModel
public class BalanceModel: BaseModel, Codable {
    
    @objc public var Id:String = ""
    @objc public var HappyChildAnalysisHours: Int = 0
    @objc public var DateEndStr: String = ""
    @objc public var History: [HistoryBalanceModel] = []
    
    override init(){
        super.init()
    }
       
    convenience init(_ dic: [String: Any]) {
        self.init()
        self.Id = dic["Id"] as? String ?? ""
        self.DateEndStr = dic["DateEndStr"] as? String ?? ""
        self.HappyChildAnalysisHours = dic["HappyChildAnalysisHours"] as? Int ?? 0
        let list = dic["History"] as? [[String:Any]]
        self.History = list?.map(){ (body) in return  HistoryBalanceModel(body) } ?? []
    }
    
}

//MARK: - HistoryBalanceModel
public class HistoryBalanceModel: BaseModel, Codable {
    
    @objc public var ChangeDateStr:String = ""
    @objc public var HappyChildAnalysisHoursChangeValue: Int = 0
    
    override init(){
        super.init()
    }
       
    convenience init(_ dic: [String: Any]) {
        self.init()
        self.ChangeDateStr = dic["ChangeDateStr"] as? String ?? ""
        self.HappyChildAnalysisHoursChangeValue = dic["HappyChildAnalysisHoursChangeValue"] as? Int ?? 0
    }
    
    convenience init(_ changeDateStr: String, _ happyChildAnalysisHoursChangeValue: Int) {
        self.init()
        self.ChangeDateStr = changeDateStr
        self.HappyChildAnalysisHoursChangeValue = happyChildAnalysisHoursChangeValue
    }
}
