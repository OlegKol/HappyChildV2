//
//  PromoCodeRouter.swift
//  Cleverl
//
//  Created by Евгений on 2/19/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class PromoCodeRouter: PromoCodeRouterProtocol {
    
    public var dataSource: BaseDataSourceProtocol?
    public var viewer: (UIViewController & PromoCodeViewerProtocol)?
    
    public func backToView() {
        self.viewer?.dismiss(animated: true, completion: nil)
    }
    
    
}
