//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by 조현민 on 02/07/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.title = "\(bestAttemptContent.title)"
            if let imageURLString = bestAttemptContent.userInfo["photo"] as? String {
                if let imagePath = image(imageURLString) {
                    let imageURL = URL(fileURLWithPath: imagePath)
                    do {
                        let attach = try UNNotificationAttachment(identifier: "image-test", url: imageURL, options: nil)
                        bestAttemptContent.attachments = [attach]
                    } catch {
                        print(error)
                    }
                }
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    func image(_ URLString: String) -> String? {
        let componet = URLString.components(separatedBy: "/")
        if let fileName = componet.last {
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
