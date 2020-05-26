//
//  File.swift
//  modooClass
//
//  Created by 조현민 on 20/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit
import UserNotifications

extension UIViewController:UNUserNotificationCenterDelegate{
    func localNotification(){
        //creating the notification content
        let content = UNMutableNotificationContent()

        //adding title, subtitle, body and badge
        content.title = "알림"
//        content.subtitle = ""
        content.body = "알림이 도착했어요"
        content.badge = 1

        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)

        //getting the notification request
        let request = UNNotificationRequest(identifier: "ActiveNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().delegate = self

        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

//    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
////        localNotification()
//        completionHandler([.alert, .badge, .sound])
//    }
    
}
