//
//  AcceptInteractorProtocol.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 11/29/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

public protocol SettingsInteractorProtocol: BaseDataSourceProtocol {
    
    var presenter: SettingsPresenterProtocol? {get set}
    var worker: SettingsWorkerProtocol? {get set}
    var router: SettingsRouterProtocol? {get set}
    
    var isBusy: Bool { get set}
    var cameraTypesWork: [CameraTypeWork] { get set }
    var arrayDays: [DayModel] { get set}
    var accountSettings: SettingsModel? { get set}
    
    func back()
    func getNotifications()
    
    
    func loadAccountSettings()
    func updateCameraStatus(status: Bool)
    func updateTimeZone(timeZone: Int)
    func updatePipeSettings(settings: SettingsModel)
    func updateDays(settings: SettingsModel)
}
