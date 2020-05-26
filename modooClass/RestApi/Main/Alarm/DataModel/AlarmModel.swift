//
//  AlarmModel.swift
//  modooClass
//
//  Created by 조현민 on 18/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class AlarmModel: NSObject {
    var code:String?
    var message:String?
    var results:AlarmResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = AlarmResults.init(dic: results)
        }
    }
}

class AlarmResults:NSObject{
    var page:Int?
    var total:Int?
    var total_page:Int?
    var curr:Int?
    var list:AlarmList?
    var alarmList:Array = Array<AlarmList>()
    var mcChat_cnt:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        page = DictionaryToInt(dic: dic, intName: "page")
        total = DictionaryToInt(dic: dic, intName: "total")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        curr = DictionaryToInt(dic: dic, intName: "curr")
        mcChat_cnt = DictionaryToInt(dic: dic, intName: "mcChat_cnt")
        if let alarm_list = dic["list"] as? Array<Any>{
            let array:Array = alarm_list
            for list in array {
                let temp = AlarmList.init(dic: list as! Dictionary<String, Any>)
                alarmList.append(temp)
            }
        }
    }
}

class AlarmList:NSObject{
    var appnotify_id:Int?
    var friend_id:Int?
    var friend_name:String?
    var photo:String?
    var short_name:String?
    var mcClass_id:Int?
    var mcCurriculum_id:Int?
    var mcComment_id:Int?
    var push_type:Int?
    var body:String?
    var read_status:String?
    var push_url:String?
    var created_at:String?
    var time_spilled:String?
    var icon_type:Int?
    var profile_url:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        appnotify_id = DictionaryToInt(dic: dic, intName: "appnotify_id")
        friend_id = DictionaryToInt(dic: dic, intName: "friend_id")
        friend_name = DictionaryToString(dic: dic, strName: "friend_name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        short_name = DictionaryToString(dic: dic, strName: "short_name")
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        push_type = DictionaryToInt(dic: dic, intName: "push_type")
        body = DictionaryToString(dic: dic, strName: "body")
        read_status = DictionaryToString(dic: dic, strName: "read_status")
        push_url = DictionaryToString(dic: dic, strName: "push_url")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        mcCurriculum_id = DictionaryToInt(dic: dic, intName: "mcCurriculum_id")
        mcComment_id = DictionaryToInt(dic: dic, intName: "mcComment_id")
        icon_type = DictionaryToInt(dic: dic, intName: "icon_type")
        profile_url = DictionaryToString(dic: dic, strName: "profile_url")
    }
}
