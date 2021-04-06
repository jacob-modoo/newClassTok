//
//  PushNotification.swift
//  modooClass
//
//  Created by 조현민 on 09/07/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class PushNotificationModel: NSObject {
    
    var appnotify_id:Int?
    var title:String?
    var body:String?
    var push_type:String?
    var class_info:String?
    var mutable_content:String?
    var push_url:String?
    var profile_url:String?
    var mcClass_id:Int?
    var mcComment_id:Int?
    var mcCurriculum_id:Int?
    var chat_id:Int?
    
    var short_name:String?
    var created_at:String?
    var time_spilled:String?
    var read_status:String?
    
    var friend_id:Int?
    var photo:String?
    
    var icon_type:Int?
    var chat_count:Int?
    var badge_count:String?
    var alarm_count:String?
    var badge:String?
    
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        appnotify_id = DictionaryToInt(dic: dic, intName: "appnotify_id")
        title = DictionaryToString(dic: dic, strName: "title")
        body = DictionaryToString(dic: dic, strName: "body")
        push_type = DictionaryToString(dic: dic, strName: "push_type")
        class_info = DictionaryToString(dic: dic, strName: "class_info")
        mutable_content = DictionaryToString(dic: dic, strName: "mutable-content")
        push_url = DictionaryToString(dic: dic, strName: "push_url")
        profile_url = DictionaryToString(dic: dic, strName: "profile_url")
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        mcComment_id = DictionaryToInt(dic: dic, intName: "mcComment_id")
        mcCurriculum_id = DictionaryToInt(dic: dic, intName: "mcCurriculum_id")
        chat_id = DictionaryToInt(dic: dic, intName: "chat_id")
        
        short_name = DictionaryToString(dic: dic, strName: "short_name")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        read_status = DictionaryToString(dic: dic, strName: "read_status")
        
        friend_id = DictionaryToInt(dic: dic, intName: "friend_id")
        photo = DictionaryToString(dic: dic, strName: "photo")
        
        icon_type = DictionaryToInt(dic: dic, intName: "icon_type")
        chat_count = DictionaryToInt(dic: dic, intName: "chat_count")
        badge_count = DictionaryToString(dic: dic, strName: "badge_count")
        alarm_count = DictionaryToString(dic: dic, strName: "alarm_count")
        badge = DictionaryToString(dic: dic, strName: "badge")
    }
}


