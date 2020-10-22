//
//  DocumentPresenterProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol DocumentPresenterProtocol: class {
    
    var viewer: DocumentViewerProtocol? { get set}
    
    func updateDocuments(_ data: [DocumentModel])
    
    func updatePageState(_ state: Bool)
}
