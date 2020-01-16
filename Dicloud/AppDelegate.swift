//
//  AppDelegate.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 4/10/19.
//  Copyright © 2019 Queralt Sosa Mompel. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var backgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    let notificationCenter = UNUserNotificationCenter.current()
    static var menu_bool = true 
    var window: UIWindow?
    let sendNotifications = UserDefaults.standard.object(forKey: "notifications_switch_value") as? Bool
    let userLoginStatus = UserDefaults.standard.bool(forKey: "isUserLoggedIn")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
        })
    
        if(userLoginStatus){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            self.window?.rootViewController = homeVC
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    func checkMessages(time:Int){
        newsTimer = nil
        chatTimer = nil
        NewsWorker().start(time:time)
        ChatWorker().start(time:time)
    }
    
    func confirmUserAuthorization() {
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
                UserDefaults.standard.set(false, forKey: "notifications_switch_value")
            }
        }
    }
    
    
    //MARK: Local Notification Methods Starts here
    // Prepare New Notification with details and trigger
    func scheduleNotification(message: String) {
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "notification"
        content.body = message
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            } else {
                print("todo bien")
            }
        }
    }
    //Handle Notification Center Delegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if (UserDefaults.standard.object(forKey: "sound_notification_id") == nil) {
            defaults.set(1003, forKey: "sound_notification_id")
        }
        if (UserDefaults.standard.object(forKey: "vibration_switch_value") == nil) {
            defaults.set(true, forKey: "vibration_switch_value")
        }
        let systemSoundID = UInt32(UserDefaults.standard.object(forKey: "sound_notification_id") as! Int)
        let vibration = UserDefaults.standard.object(forKey: "vibration_switch_value") as! Bool
        if (vibration) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        print("Show notification")
        AudioServicesPlayAlertSound(UInt32(systemSoundID))
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        completionHandler()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if (userLoginStatus && sendNotifications != nil && sendNotifications!) {
            var time = 0
            if (defaults.object(forKey: "data_frequency_selected") as? String == nil) {
                defaults.set("Cada 15 minutos", forKey: "data_frequency_selected")
            }
            switch (defaults.object(forKey: "data_frequency_selected") as? String) {
            case "Cada 15 minutos":
                time = 900
                break
            case "Cada 30 minutos":
                time = 1800
                break
            case "Cada hora":
                time = 3600
                break
            case "Cada 3 horas":
                time = 10800
                break
            case "Cada 5 horas":
                time = 18000
                break
            default:
                time = 0
                break
            }
            newsTimer?.invalidate()
            chatTimer?.invalidate()
            self.checkMessages(time:time)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if (userLoginStatus && sendNotifications != nil && sendNotifications!) {
            newsTimer?.invalidate()
            chatTimer?.invalidate()
            self.checkMessages(time:5)
         }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
