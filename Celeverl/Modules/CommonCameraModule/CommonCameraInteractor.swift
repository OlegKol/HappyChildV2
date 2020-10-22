//
//  CommonCameraInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


//MARK: - CommonCameraInteractor
public class CommonCameraInteractor: CommonCameraInteractorProtocol {
    
    
    //MARK: - CommonCameraInteractorProtocol implementation
    public var presenter: CommonCameraPresenterProtcol?
    public var router: CommonCameraRouterProtocol?
    public var worker: CommonCameraWorkerProtocol?
    
    public var camerasListModel: [CameraModel]? = []
    public var currentCameraModel: CameraModel? = nil
    
    public var accountModel: UserModel? = nil
    
    public var dayliDocumentsList: [DocumentModel] = []
    
    private var queue = DispatchQueue.global(qos: .background)
    
    public func selectCamera(_ model: BaseModel) {
        if let camera = model as? CameraModel {
            self.currentCameraModel = camera
            self.router?.goToFullVideo()
        }
    }
    public func loadDefaultData() {
        self.queue.async {
            do {
                if let acccount = AccountService.shared.currentAccount {
                    self.camerasListModel = try self.worker?.getCameraList(userId: acccount.Id)
                    self.dayliDocumentsList = try self.worker?.getDayliDocuments(userId: acccount.Id) ?? []
                }
                self.presenter?.updateCameraList(self.camerasListModel!)
                self.presenter?.updateDocument(self.dayliDocumentsList)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    public func getDataSource() -> [String : Any] {
        var parameters =  [String: Any]()
        if let model = self.currentCameraModel {
            parameters[AppConstants.CAMERA_MODEL_PARAMETER] = model
        }
        return parameters
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        let dic = source.getDataSource()
        if dic[AppConstants.USER_PARAMETER] != nil {
            self.accountModel = dic[AppConstants.USER_PARAMETER] as? UserModel
        }
    }
    
}
