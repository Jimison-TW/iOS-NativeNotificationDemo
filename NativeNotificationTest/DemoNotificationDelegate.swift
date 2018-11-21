//
//  DemoNotificationDelegate.swift
//  NativeNotificationTest
//
//  Created by Jimison on 2018/10/23.
//  Copyright © 2018年 Jimison. All rights reserved.
//

import UIKit
import UserNotifications

class DemoNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    //收到通知時，App在畫面中如何顯示
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert, .sound, .badge])  //badge指得是首頁中app icon右上角的數字號碼
    }
    
    //處理使用者對於notification的動作
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Determine the user action
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
            
        case "SnoozeAction":
            print("Snooze")
            let identifier = "SnoozeNotification"
            let content = response.notification.request.content
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: {(error) in
                if let error = error {
                    print("\(error)")
                }else {
                    print("successed snooze")
                }
            })
            
        case "DeleteAction":
            print("Delete")
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }

}
