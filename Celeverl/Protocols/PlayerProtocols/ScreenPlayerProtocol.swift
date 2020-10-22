//
//  ScreenPlayerProtocol.swift
//  Cleverl
//
//  Created by Евгений on 5/12/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public protocol ScreenPlayerProtocol: class {
    func openPlayer(_ player: BasePlayerProtocol, _ state: StateScreenPlayer)
}
