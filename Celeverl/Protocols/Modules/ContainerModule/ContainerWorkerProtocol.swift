//
//  ContainerWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/9/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation


public protocol ContainerWorkerProtocol: class {
    
    func loadUserSttings(user: UserModel) throws -> UserModel?
}
