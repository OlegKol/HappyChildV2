//
//  VideoFullRouter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/18/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public class FullVideoRouter: FullVideoRouterProtocol {
    
    public var viewer: (UIViewController & FullVideoViewerProtocol)?
    public var interactor: FullVideoInteractorProtocol?
    
    public func backRoute() {
        self.viewer?.dismiss(animated: true, completion: nil)
    }
}
