//
//  DocumentInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol DocumentInteractorProtocol: BaseDataSourceProtocol {
    
    var router: DocumentRouterProtocol? { get set }
    var worker: DocumentWorkerProtocol? { get set }
    var presenter: DocumentPresenterProtocol? { get set }
    
    var IsBusy: Bool { get set }
    var documentsList: [DocumentModel] { get set }
    var currentDocument: DocumentModel? { get set }
    
    func loadData()
    
    func updateDocuments(_ data: [DocumentModel])
    
    func touchDocument(_ document: DocumentModel)
}
