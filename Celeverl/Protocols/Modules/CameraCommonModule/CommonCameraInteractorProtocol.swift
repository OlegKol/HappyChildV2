//
//  CommonCameraInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol CommonCameraInteractorProtocol: BaseDataSourceProtocol {
    
    var presenter:CommonCameraPresenterProtcol? { get set}
    var router: CommonCameraRouterProtocol? { get set}
    var worker : CommonCameraWorkerProtocol? { get set}
    
    var camerasListModel: [CameraModel]? {get set}
    var currentCameraModel: CameraModel? { get set}
    
    var dayliDocumentsList: [DocumentModel] {get set}
    var accountModel: UserModel? { get set}
    
    func loadDefaultData()
    func selectCamera(_ model: BaseModel)
}
