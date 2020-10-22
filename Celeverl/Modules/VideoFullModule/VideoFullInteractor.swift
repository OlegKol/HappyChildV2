//
//  VideoFullInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/18/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class VideoFullInteractor: FullVideoInteractorProtocol {
    
    public var worker: FullVideoWorkerProtocol?
    public var presenter: FullVideoPresenterProtocol?
    public var router: FullVideoRouterProtocol?
    public var cameraModel: CameraModel?
    
    public func loadDefaultData() {
        
    }
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        let dic = source.getDataSource()
        if let model = dic[AppConstants.CAMERA_MODEL_PARAMETER] as? CameraModel  {
            self.cameraModel = model
        }
    }
    

    public func closePage() {
        self.router?.backRoute()
    }
    
}
