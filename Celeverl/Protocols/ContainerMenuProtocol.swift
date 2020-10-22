//
//  ContainerMenuProtocol.swift
//  Cleverl
//
//  Created by Евгений on 2/25/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol ContainerMenuProtocol {
    
    var startTouchPoint: CGPoint { get set}
    var currentTouchPoint: CGPoint { get set}
    var startViewPoint: CGPoint { get set}
    var IsOpenMenu: Bool { get set}

    var IsListenTouchChanged: Bool { get set}
    var menuWidth: CGFloat { get set}

    func handleTouch(_ touch: UIPanGestureRecognizer)
    func openMenu()
    func closeMenu()
    func changeViewPositionX(_ deltaX: CGFloat)
}
