//
//  CommonCameraPresenter.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/16/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public class CommonCameraPresenter: CommonCameraPresenterProtcol {
    
    public var viewer: CommonCameraViewerProtocol?
    
    public func updateCameraList(_ list: [BaseModel]) {
        DispatchQueue.main.async{
            self.viewer?.updateCameraListView(list)
        }
    }
    
    public func updateDocument(_ documents: [DocumentModel]) {
        self.viewer?.updateDocument(documents)
    }
    
}
