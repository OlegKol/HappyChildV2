//
//  DocumentWorkerProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation


public protocol DocumentWorkerProtocol: class {
    
    func loadUserDocuments(_ userId: String) throws -> [DocumentModel]
}
