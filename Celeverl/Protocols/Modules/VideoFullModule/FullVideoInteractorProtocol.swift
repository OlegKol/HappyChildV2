//
//  FullVideoInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/18/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol FullVideoInteractorProtocol: BaseDataSourceProtocol {
    var presenter:FullVideoPresenterProtocol? { get set}
    var router: FullVideoRouterProtocol? {get set}
    var worker: FullVideoWorkerProtocol? { get set}
    var cameraModel: CameraModel? { get set}
    
    func loadDefaultData()
    func closePage()
    
}
