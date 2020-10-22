//
//  BasePlayerProtocol.swift
//  Cleverl
//
//  Created by Евгений on 4/30/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public protocol BasePlayerProtocol {
    
    var orientation: Orientation { get set }
    var state: StateScreenPlayer { get set }
    var delegateScreen: ScreenPlayerProtocol? { get set}
    
    func play()
    func stop()
    func pause()
    func setUrl(url: URL)
    func changeStateScreenPlayer(_ state: StateScreenPlayer)
}


public enum Orientation {
    case portrait
    case landscape
}

public enum State {
    case play
    case pause
    case stop
}

public enum StateScreenPlayer {
    case full
    case short
}
