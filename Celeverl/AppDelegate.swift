//
//  AppDelegate.swift
//  Celeverl
//
//  Created by Евгений on 2/6/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import BackgroundTasks
import Firebase
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  //  let notificationService : LocalNotificationService = LocalNotificationService.shared
    let localStorage: RealmService = RealmService.shared
    var pushToken = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
  //      self.notificationService.notificationCenter.delegate = self
        FirebaseApp.configure()
        registerAPNS(application)
           refreshPushToken()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
         if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
             let remoteNotif = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary
             DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 5 to desired number of seconds
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notification"), object: self, userInfo: (remoteNotif as! [AnyHashable : Any]))
             }
         }
        
        if RealmService.shared.hasAccount() {
            if let account = RealmService.shared.getAccount() {
                do{
                   try AccountService.shared.writeAccount(account)
                    let viewer = ContainerViewer()
                    let router = ContainerRouter()
                    let presneter = ContainerPresenter()
                    let worker = ContainerWorker()
                    let interactor = ContainerInteractor()
                      
                    ContainerBuilder.createcreateBudiler(viewer: viewer, interactor: interactor, worker: worker, router: router, presenter: presneter)
                      
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    self.window?.rootViewController = viewer
                    self.window?.makeKeyAndVisible()
                }
                catch _ {
                }
            }
        }
        else {
            let mainController = MainViewer()
            MainBuilder.createBudiler(viewer: mainController)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = mainController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    
   

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Celeverl")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
  

}

extension AppDelegate: UNUserNotificationCenterDelegate,MessagingDelegate {
    
    func registerAPNS (_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            
            
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        print("Notification data----\(content.userInfo)")
        
     
    
        completionHandler([.alert,.badge, .sound]) // Display notification as
        
        NotificationCenter.default.post(name: NSNotification.Name.init("NEW_NOTIFICATION"), object: nil, userInfo: nil)
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
       
        completionHandler(UIBackgroundFetchResult.newData)
    }

    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error-\(error)-")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        print("1Device Token: \(token)")
        
        //InstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
        let refreshedToken = InstanceID.instanceID().token()
        
        if refreshedToken != nil {
            pushToken = refreshedToken!
            print("2Device Token: \(pushToken)")
        }
    }
    
    func connectToFcm() {
        Messaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {
        if InstanceID.instanceID().token() != nil {
            let refreshedToken = InstanceID.instanceID().token()!
            
            let defaults = UserDefaults.standard
            defaults.setValue(refreshedToken, forKey: "firebasetoken")
            
            print("InstanceID token: \(refreshedToken)")
            pushToken = refreshedToken
            print("pushToken: \(pushToken)")
        } else {
            connectToFcm()
        }
    }
    
    func refreshPushToken() {
        if InstanceID.instanceID().token() != nil {
            let refreshedToken = InstanceID.instanceID().token()!
            print("InstanceID token: \(refreshedToken)")
            pushToken = (refreshedToken as NSString) as String
            print("strNotificationToken: \(pushToken)")
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // reset badge count
   //     application.applicationIconBadgeNumber = 0
    }
}
