//
//  ViewController.swift
//  NativeNotificationTest
//
//  Created by Jimison on 2018/10/23.
//  Copyright © 2018年 Jimison. All rights reserved.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {
    
    @IBOutlet weak var notifyButton: UIButton!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var center: UNUserNotificationCenter?
    
    let snoozeAction = UNNotificationAction(identifier: "SnoozeAction",
                                            title: "Snooze", options: [.authenticationRequired])
    let deleteAction = UNNotificationAction(identifier: "DeleteAction",
                                            title: "Delete", options: [.destructive])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let category = UNNotificationCategory(identifier: "Demo", actions: [snoozeAction,deleteAction], intentIdentifiers: [], options: [])
        center = app.center
        center?.setNotificationCategories([category])
    }
    
    @IBAction func onSendNotificationButtonClick(_ sender: Any) {
        center?.getNotificationSettings(completionHandler: { (settings) in
            //判斷Notification的權限設定是否開啟
            if settings.authorizationStatus == .authorized{
                self.sendNotification()     //有授權，開始傳送Notification
            }else if settings.authorizationStatus == .denied{
                self.deniedAlert()          //沒有授權，顯示警告對話框
            }else{
                return
            }
        })
    }
    
    func sendNotification() {
        // Main thread checker
        DispatchQueue.main.async {
            let titleText = "My Notification"
            let bodyText = "Notification Content"
            
            let content = UNMutableNotificationContent()
            content.title = titleText
            content.body = bodyText
            content.sound = UNNotificationSound.default
            content.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber + 1)
            content.categoryIdentifier = "Demo" //定義發送的Notification類別
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: trigger)
            
            self.center?.add(request,withCompletionHandler: {(error) in
                if let error = error {
                    print("\(error)")
                }else {
                    print("successed")
                }
            })
        }
    }
    
    //若用戶取消授權，則帶用戶跳轉至Setting設定畫面
    func deniedAlert() {
        let useNotificationsAlertController = UIAlertController(title: "Turn on notifications", message: "This app needs notifications turned on for the best user experience \n ", preferredStyle: .alert)
        
        // go to setting alert action
        let goToSettingsAction = UIAlertAction(title: "Go to settings", style: .default, handler: { (action) in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        useNotificationsAlertController.addAction(goToSettingsAction)
        useNotificationsAlertController.addAction(cancelAction)
        
        self.present(useNotificationsAlertController, animated: true)
    }
    
    //警告視窗-原文用於提醒使用者，Notification內容不可為空值
    func emptyAlert() {
        let controller = UIAlertController(title: "Warning", message: "Title or Body can't be empty!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
}

