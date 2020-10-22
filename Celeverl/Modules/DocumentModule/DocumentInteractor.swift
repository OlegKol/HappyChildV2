//
//  DocumentInteractor.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class DocumentInteractor: DocumentInteractorProtocol {
    
    
    public var router: DocumentRouterProtocol?
    public var worker: DocumentWorkerProtocol?
    public var presenter: DocumentPresenterProtocol?
    
    public var IsBusy: Bool = false{
        didSet {
            self.presenter?.updatePageState(self.IsBusy)
        }
    }
    public var documentsList: [DocumentModel] = [] {
        didSet {
            self.updateDocuments(self.documentsList)
        }
    }
    
    public var currentDocument: DocumentModel?
    
    public func loadData() {
        self.IsBusy = true
        DispatchQueue.global(qos: .utility).async {
            do{
                guard let user = AccountService.shared.currentAccount else { self.IsBusy = false; return }
                if let result = try self.worker?.loadUserDocuments(user.Id) {
                    self.documentsList = result.sorted(by:) { $0.date < $1.date }
                }
            }
            catch let error {
                
            }
            self.IsBusy = false
        }
    }
    
    public func updateDocuments(_ data: [DocumentModel]) {
        self.presenter?.updateDocuments(data)
    }
    
    public func touchDocument(_ document: DocumentModel) {
        self.currentDocument = document
    }
    
    
    public func getDataSource() -> [String : Any] {
        return [:]
    }
    
    public func setCustomData(source: BaseDataSourceProtocol) {
        
    }
    
}
