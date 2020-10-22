//
//  CameraViewerProtocol.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol CameraViewerProtocol:class {
    
    var interactor: CameraInteractorProtocol? { get set }
    var cameras: [CameraModel]? { get set }
    
    
    func updateStatePage(_ state: Bool)
    func getCameraList(cameras: [CameraModel])
    func setCurrentCamera(camera: CameraModel)
    func addCameraId()
    func setCameraTypeWork(type: TypeCameraWork)
    func getTypeCameraWork(types: [TypeCameraWork])
    func updateSelectedDateLabel(date: Date)
    
    func updatePayer(_ type: TypeCameraWork, _ url: URL)
    
    func changeStateCameraButton(_ state: Bool)
}
