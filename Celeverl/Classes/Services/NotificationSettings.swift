//
//  NotificationSettings.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/3/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UserNotifications

//MARK: - NotificationSettings
public class NotificationSettings {
    
    func createNotificationTrigger<T: NotificationModel>(_ data: T) -> UNNotificationTrigger {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        return trigger
    }
    
    func createNotificationContent<T: NotificationModel>(_ data: T) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.body = data.description
        content.sound = UNNotificationSound.default
        content.badge = 1
        return content
    }
    
    func createNotificationRequest<T: NotificationModel>(_ data: T) -> UNNotificationRequest {
        
        let content = self.createNotificationContent(data)
        let trigger = self.createNotificationTrigger(data)
        let Id = data.getId()
        let request = UNNotificationRequest(identifier: Id, content: content, trigger: trigger)
        return request
    }
}
