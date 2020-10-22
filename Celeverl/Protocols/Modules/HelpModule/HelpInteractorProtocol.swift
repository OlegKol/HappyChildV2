//
//  DocumentInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/23/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public protocol HelpInteractorProtocol: BaseDataSourceProtocol {
    
    var router: HelpRouterProtocol? { get set }
    var worker: HelpWorkerProtocol? { get set }
    var presenter: HelpPresenterProtocol? { get set }
    
    var IsBusy: Bool { get set }
    var helpModel: HelpModel? { get set }
    
    func loadData()
    
    func updatePage(_ data: HelpModel)
}
