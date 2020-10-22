//
//  ContainerWorker.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/9/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation

//MARK: - ContainerWorker
public class ContainerWorker: ContainerWorkerProtocol {
    
    func getMenuItems() -> [MenuModel]{
        
        let menuItems = [
            MenuModel(id: 0, name: "Cameras", image: "camera_picture", typePage: .Camera),
            MenuModel(id: 1, name: "Profile", image: "person_picture", typePage: .Profile),
            MenuModel(id: 2, name: "Documents", image: "dashboard_picture", typePage: .Documents),
            MenuModel(id: 2, name: "Settings", image: "setting_picture", typePage: .Setting)
        ]
        return menuItems
    }
    
    
    public func loadUserSttings(user: UserModel) throws -> UserModel? {
        
        var model: UserModel? = nil
        var urlComponent = URLComponents(string: AppConstants.APP_USER_SETTING_URL)
        
        urlComponent?.queryItems = [
            URLQueryItem(name: "userId", value: user.Id)
        ]
        
        let response = NetworkService.getAsync(urlComponent!)
        if response.error != nil {
            throw CustomError.invalid(message: response.error!.localizedDescription)
        }
        if let data = response.data {
            do{
                let json = try JSONSerialization.jsonObject(with:data, options: []) as! [String: Any]
                model = UserModel(json)
              }
            catch let parsingError {
                throw parsingError
            }
        }
        return model
    }
}
