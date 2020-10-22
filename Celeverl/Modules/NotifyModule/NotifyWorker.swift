//
//  NotifyWorker.swift
//  Celeverl
//
//  Created by Евгений on 2/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation

public class NotifyWorker: NotifyWorkerProtocol {
    
    public func getNotification(userId: String) throws -> [NotificationModel]? {
        
        var notifications: [NotificationModel]?
        let url = URLComponents(string: AppConstants.APP_NOTIFICATION_URL)
        guard var urlComponent = url else { return notifications }
        
        urlComponent.queryItems = [URLQueryItem(name: "userId", value: userId)]
        
        if (AccountService.shared.currentAccount != nil) && AccountService.shared.currentAccount?.PhoneNumber == "7777777777" {
            urlComponent.queryItems?.append(URLQueryItem(name: "isTest", value: "true"))
        }
        
        let response = NetworkService.getAsync(urlComponent)
        if let error = response.error {
           print("Error in sending request to Notification center: \(error)")
        }
        else if let data = response.data {
            do {
                notifications = try ConvertService.converTo(data)
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
            catch let error {
                print(error)
            }
        }
        return notifications
    }
    
}
