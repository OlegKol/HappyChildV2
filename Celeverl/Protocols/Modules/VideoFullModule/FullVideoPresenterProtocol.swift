//
//  FullVideoPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/18/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol FullVideoPresenterProtocol: class {
    var viewer: FullVideoViewerProtocol? { get set}
}
