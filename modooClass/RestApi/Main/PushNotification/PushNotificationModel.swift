//
//  PushNotification.swift
//  modooClass
//
//  Created by 조현민 on 09/07/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class PushNotificationModel: NSObject {
    var friend_id:Int?
    var icon_type:Int?
    var push_type:Int?
    var read_status:String?
    var appnotify_id:Int?
    var mcClass_id:Int?
    var mcComment_id:Int?
    var time_spilled:String?
    var created_at:String?
    var mcCurriculum_id:Int?
    var push_url:String?
    var short_name:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        friend_id = DictionaryToInt(dic: dic, intName: "friend_id")
        icon_type = DictionaryToInt(dic: dic, intName: "icon_type")
        push_type = DictionaryToInt(dic: dic, intName: "push_type")
        read_status = DictionaryToString(dic: dic, strName: "read_status")
        appnotify_id = DictionaryToInt(dic: dic, intName: "appnotify_id")
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        mcComment_id = DictionaryToInt(dic: dic, intName: "mcComment_id")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        mcCurriculum_id = DictionaryToInt(dic: dic, intName: "mcCurriculum_id")
        push_url = DictionaryToString(dic: dic, strName: "push_url")
        short_name = DictionaryToString(dic: dic, strName: "short_name")
    }
}


