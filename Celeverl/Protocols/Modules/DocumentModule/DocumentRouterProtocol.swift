//
//  DocumentRouterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol DocumentRouterProtocol: class {
    
    var viewer: (DocumentViewerProtocol & UIViewController)? { get set}
}

