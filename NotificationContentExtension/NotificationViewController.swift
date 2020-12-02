//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by iOS|Dev on 2020/11/30.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    
    var bestAttemptContent: UNMutableNotificationContent?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = view.bounds.size
        preferredContentSize = CGSize(width: size.width, height: 50)
    }
    
    func didReceive(_ notification: UNNotification) {
        
//        let content = notification.request.content
        
        titleLbl.text = bestAttemptContent?.title
        bodyLbl.text = bestAttemptContent?.body
        if let imageURLString = bestAttemptContent?.userInfo["photo"] as? String {
            if let imagePath = image(imageURLString) {
                let imageURL = URL(fileURLWithPath: imagePath)
                do {
                    let attach = try UNNotificationAttachment(identifier: "image-test", url: imageURL, options: nil)
                    bestAttemptContent?.attachments = [attach]
                } catch {
                    print(error)
                }
            }
        }
        
        
        
    }
    
    func image(_ URLString: String) -> String? {
        let component = URLString.components(separatedBy: "/")
        if let fileName = component.last {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            if let documentsPath = paths.first {
                let filePath = documentsPath.appending("/" + fileName)
                if let imageURL = URL(string: URLString) {
                    do {
                        let data = try NSData(contentsOf: imageURL, options: NSData.ReadingOptions(rawValue: 0))
                        if data.write(toFile: filePath, atomically: true) {
                            return filePath
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        return nil
    }

}
