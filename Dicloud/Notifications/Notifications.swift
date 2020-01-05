//
//  Notifications.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 5/1/20.
//  Copyright © 2020 Queralt Sosa Mompel. All rights reserved.
//

import Foundation
import UserNotifications
import NotificationCenter

class Notifications {
    func scheduleNotification(message: String) {
        print("entro")
        //Compose New Notificaion
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Delete Notification Type"
        content.sound = UNNotificationSound.default
        content.body = "This is example how to send "
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
}
