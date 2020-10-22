//
//  FullVideoRouterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/18/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UIKit

public protocol FullVideoRouterProtocol: BaseRouterProtocol {
    var viewer: (FullVideoViewerProtocol & UIViewController)? { get set}
    var interactor: FullVideoInteractorProtocol? { get set}
}
