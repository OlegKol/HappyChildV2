//
//  CameraInteractor.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class CameraInteractor: NSObject, CameraInteractorProtocol {
    
    public var IsBusy: Bool = false {
        didSet {
            self.viewer?.updateStatePage(self.IsBusy)
        }
    }
    
    public var worker: CameraWorkerProtocol?
    weak public var viewer: CameraViewerProtocol?
    
    public var cameraList: [CameraModel] = [] {
        didSet {
            self.viewer?.getCameraList(cameras: self.cameraList)
            self.checkVisibleAddCameraButton()
        }
    }
    
    @objc dynamic public var currentCamera: CameraModel? {
        didSet {
            if let camera = self.currentCamera {
                self.viewer?.setCurrentCamera(camera: camera)
                self.OnUpdateSetUpCameras()
            }
        }
    }
    
    public var typeCameraWork: [TypeCameraWork] = []
    @objc dynamic public var currentTypeCameraWork: TypeCameraWork? {
        didSet {
            if let type = self.currentTypeCameraWork {
                self.viewer?.setCameraTypeWork(type: type)
                self.OnUpdateSetUpCameras()
            }
        }
    }
    
    @objc dynamic public var currentSelectedTime: Date = Date() {
        didSet {
            self.viewer?.updateSelectedDateLabel(date: self.currentSelectedTime)
            self.OnUpdateSetUpCameras()
        }
    }
    
    public func setDefaultData() {
        DispatchQueue.global(qos: .utility).async {
            self.typeCameraWork = [TypeCameraWork("Онлайн"), TypeCameraWork("Архив")]
            self.setCurrentTypeWorkCamera(self.typeCameraWork[0])
            self.viewer?.getTypeCameraWork(types: self.typeCameraWork)
            self.currentSelectedTime = Date()
        }
    }
    
    public func loadCamerasList() {
        self.IsBusy = true
        DispatchQueue.global(qos: .utility).async {
           do {
                guard let user = AccountService.shared.currentAccount else { return }
                self.cameraList = try self.worker?.getCameraList(userId: user.Id) ?? []
                guard self.cameraList.count != 0 else { return }
                self.setCurrentCamera(self.cameraList[0])
           }
           catch  let _ {
                self.IsBusy = false
           }
            self.IsBusy = false
        }
    }
    
    public func addCameraId(cameraId: String) {
        
    }
    
    
    private func setCurrentTypeWorkCamera(_ type: TypeCameraWork) {
        self.currentTypeCameraWork = type
    }
    
    private func setCurrentCamera(_ camera: CameraModel) {
        self.currentCamera = camera
    }
    
    public func updateSelectedDate(_ date: Date) {
        self.currentSelectedTime = date
    }
    
    public func updateSelectedTypeCameraWork(_ index: Int) {
        self.setCurrentTypeWorkCamera(self.typeCameraWork[index])
    }
    
    var datePicker_timeStamp = 0
    var default_length_second = 3600
    var length = 0
    
    func makePlaybackUrl(_ camera: CameraModel) -> URL? {
        var url = "http://171.25.232.16/nvr/hls/ecc5f6a38139426786f26ce87a42a358/1582009015/120/index.m3u8"
        let ProviderCameraUid = camera.ProviderCameraUid
        let camera_ip = camera.Url.split(separator: ":")[1]
        
        let timestamp = Int(self.currentSelectedTime.timeIntervalSince1970)  - (camera.utsOffset * 3600) + (3 * 3600)
        length = default_length_second
        let distance = Int(Date().timeIntervalSince1970) - Int(self.currentSelectedTime.timeIntervalSince1970)
        if (distance < default_length_second && distance > 0) {
          length = distance
        }
        url = "http:\(camera_ip)/nvr/hls/\(ProviderCameraUid)/\(timestamp)/\(length)/index.m3u8"
        
        let value = URL(string: url)
        return value
    }
    
    
    @objc
    private func OnUpdateSetUpCameras(){
        if let type = self.currentTypeCameraWork, let camera = self.currentCamera {
            let url = type.Title == "Онлайн" ? URL(string: camera.Url) : self.makePlaybackUrl(camera)
            if let existUrl = url {
                self.viewer?.updatePayer(type, existUrl)
            }
        }
    }
    
    private func checkVisibleAddCameraButton() {
        if self.cameraList.count == 1 && (self.cameraList.first?.ProviderCameraUid == "" &&  self.cameraList.first?.Url == "") {
            self.viewer?.changeStateCameraButton(false)
        }
        else{
            self.viewer?.changeStateCameraButton(true)
        }
    }
    
}
