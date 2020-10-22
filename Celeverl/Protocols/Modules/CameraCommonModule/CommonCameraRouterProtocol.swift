//
//  CommonCameraRouterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol CommonCameraRouterProtocol: class {
    
    var viewer: (CommonCameraViewerProtocol & UIViewController)? {get set}
    var interactor: CommonCameraInteractorProtocol? { get set}
    
    func goToFullVideo()
    
}
