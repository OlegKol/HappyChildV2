//
//  DocumentPresenter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class DocumentPresenter: DocumentPresenterProtocol {
   
    public var viewer: DocumentViewerProtocol?
    
    public func updateDocuments(_ data: [DocumentModel]) {
        self.viewer?.updateDocuments(data)
    }
    
    public func updatePageState(_ state: Bool) {
        self.viewer?.updatePageState(state)
    }

}
