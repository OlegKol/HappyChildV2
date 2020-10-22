//
//  AppLocalNotificationService.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 12/3/19.
//  Copyright © 2019 oberon. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit


//MARK: - LocalNotificationService
public class LocalNotificationService: NSObject {
    
    public var minutesInterval: Float = 10.0
    public let notificationCenter = UNUserNotificationCenter.current()
    
    private var timer: Timer?
    private var IsListen: Bool = false
    private var queue = DispatchQueue.main
    
    private let notificationSettingService: NotificationSettings = NotificationSettings()
    
    public static var shared: LocalNotificationService = LocalNotificationService()
    
    private override init(){
        super.init()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {(didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        self.registerListenerNotificationCenter()
    }
    
    deinit {
        self.unRegisterListenerNotificationCenter()
    }
    
    
    private func registerListenerNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startRecieveNotifications), name: Notification.Name.didRecieveStartListenLocalNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopRecieveNotifications), name: Notification.Name.didRecieveStopListenLocalNotification, object: nil)
    }
    
    private func unRegisterListenerNotificationCenter(){
        NotificationCenter.default.removeObserver(self, name: Notification.Name.didRecieveStartListenLocalNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.didRecieveStopListenLocalNotification, object: nil)
    }
    
    
    @objc private func startRecieveNotifications(_ notification:Notification) {
        do{
            queue.async {
                guard let user = AccountService.shared.currentAccount else { return }
                self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.minutesInterval * 60), repeats:true, block: { timer in
                    self.checkNotificationOnServer(user.Id)
                })
                RunLoop.current.add(self.timer!, forMode: .common)
                self.IsListen = true
            }
        }
        catch let error {
            print(error)
        }
    }
    
    @objc private func stopRecieveNotifications(_ name: Notification) {
        self.timer?.invalidate()
        self.timer = nil
        self.IsListen = false
    }
    
    
    func sendNotificationToCenter(_ notifications: [NotificationModel]) {
        do{
            notifications.forEach({
                let notify = self.notificationSettingService.createNotificationRequest($0)
                self.notificationCenter.add(notify) { (error) in
                    if let error = error {
                        print("Error couldn't create notification : \(error.localizedDescription)")
                    }
                }
            })
        }
        catch let exception {
            print(exception.localizedDescription)
        }
    }
    
    
    func checkNotificationOnServer(_ Id: String){
        guard let notifications = self.getRequestToNotificationsById(Id) else { return }
        let newNotifications = notifications.filter({!$0.hasBeenSentToUser})
        self.sendNotificationToCenter(newNotifications)
    }
    
    func getRequestToNotificationsById(_ Id: String) -> [NotificationModel]? {
        
        var notifications: [NotificationModel]?
        var url = URLComponents(string: AppConstants.APP_NOTIFICATION_URL)
        url?.queryItems = [
            URLQueryItem(name: "userId", value: Id)
        ]
            
        guard let urlComponent = url else { return notifications }
        let response = NetworkService.getAsync(urlComponent)
        
        if let error = response.error {
            print("Error in sending request to Notification center: \(error)")
        }
        else if let data = response.data {
            do{
                notifications = try ConvertService.converTo(data)
            }
            catch let anotherException {
               print("Another error in parse response from data Notification center: \(anotherException.localizedDescription)")
            }
        }
        return notifications
    }
}



extension Notification.Name {
    
    static let didRecieveStartListenLocalNotification = Notification.Name(rawValue: "didRecieveStartListenLocalNotification")
    static let didRecieveStopListenLocalNotification = Notification.Name(rawValue: "didRecieveStopListenLocalNotification")
}
