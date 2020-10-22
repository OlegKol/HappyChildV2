//
//  CameraInteractorProtocol.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol CameraInteractorProtocol: class {
    
    var worker:CameraWorkerProtocol? { get set }
    var viewer: CameraViewerProtocol? { get set }
    
    var currentCamera: CameraModel? { get set }
    var cameraList: [CameraModel] { get set}
    
    var typeCameraWork: [TypeCameraWork] { get set}
    var currentTypeCameraWork: TypeCameraWork? { get set }
    
    var currentSelectedTime: Date { get set }
    var IsBusy: Bool { get set}
    
    func setDefaultData()
    func loadCamerasList()
    func addCameraId(cameraId: String)
    
    func updateSelectedDate(_ date: Date)
    func updateSelectedTypeCameraWork(_ index: Int)
}
