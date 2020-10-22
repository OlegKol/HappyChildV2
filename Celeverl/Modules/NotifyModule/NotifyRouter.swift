//
//  NotifyRouter.swift
//  Celeverl
//
//  Created by Евгений on 2/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit


public class NotifyRouter: NotifyRouterProtocol {
    
    public var dataSource: BaseDataSourceProtocol?
    
    public var viewer: (UIViewController & NotifyViewerProtocol)?
    
    public func backToView() {
        self.viewer?.dismiss(animated: true, completion: nil)
    }
}
