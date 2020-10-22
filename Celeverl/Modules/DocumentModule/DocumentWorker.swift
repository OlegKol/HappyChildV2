//
//  DocumentWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class DocumentWorker: DocumentWorkerProtocol {
    
    public func loadUserDocuments(_ userId: String) throws -> [DocumentModel] {
        
        var documents: [DocumentModel] = []
        var url = URLComponents(string: AppConstants.APP_GET_LAST_TEN_DOCUMENTS_URL)
        
        url?.queryItems = [
            URLQueryItem(name: "userId", value: userId)
        ]
        
        if (AccountService.shared.currentAccount != nil) && AccountService.shared.currentAccount?.PhoneNumber == "7777777777" {
            url?.queryItems?.append(URLQueryItem(name: "isTest", value: "true"))
        }

        guard let urlComponent = url else { return documents }
        let response = NetworkService.getAsync(urlComponent)
        if response.error != nil {
            throw CustomError.invalid(message: response.error!.localizedDescription)
        }
        if let data = response.data {
            do{
                documents = try ConvertService.converTo(data) ?? []
            }
            catch let parsingError {
                print(parsingError)
                throw parsingError
            }
        }
        return documents
    }
    
}
