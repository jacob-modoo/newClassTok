//
//  ProfileSettingModel.swift
//  modooClass
//
//  Created by 조현민 on 21/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class ProfileSettingModel: NSObject {
    var code:String?
    var message:String?
    var results:ProfileSettingResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ProfileSettingResults.init(dic: results)
        }
    }
}

class ProfileSettingResults:NSObject{

    var point_title:String?
    var point_address:String?
    var payment_title:String?
    var payment_address:String?
    var review_title:String?
    var review_address:String?
    var manage_class_title:String?
    var manage_class_address:String?
    var revenue_title:String?
    var revenue_address:String?
    var coach_profile_title:String?
    var coach_profile_address:String?
    var notice_title:String?
    var notice_address:String?
    var event_title:String?
    var event_address:String?
    var support_title:String?
    var support_address:String?
    var frequent_questions_title:String?
    var frequent_questions_address:String?
    var app_notify:String?
    var message_notify:String?
    var class_count:Int?
    var class_list:SettingClassList?
    var settingClassList:Array = Array<SettingClassList>()
    var service_address:String?
    var policy_address:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        point_title = DictionaryToString(dic: dic, strName: "point_title")
        point_address = DictionaryToString(dic: dic, strName: "point_address")
        payment_title = DictionaryToString(dic: dic, strName: "payment_title")
        payment_address = DictionaryToString(dic: dic, strName: "payment_address")
        review_title = DictionaryToString(dic: dic, strName: "review_title")
        review_address = DictionaryToString(dic: dic, strName: "review_address")
        manage_class_title = DictionaryToString(dic: dic, strName: "manage_class_title")
        manage_class_address = DictionaryToString(dic: dic, strName: "manage_class_address")
        coach_profile_title = DictionaryToString(dic: dic, strName: "coach_profile_title")
        coach_profile_address = DictionaryToString(dic: dic, strName: "coach_profile_address")
        revenue_title = DictionaryToString(dic: dic, strName: "revenue_title")
        revenue_address = DictionaryToString(dic: dic, strName: "revenue_address")
        notice_title = DictionaryToString(dic: dic, strName: "notice_title")
        notice_address = DictionaryToString(dic: dic, strName: "notice_address")
        event_title = DictionaryToString(dic: dic, strName: "event_title")
        event_address = DictionaryToString(dic: dic, strName: "event_address")
        frequent_questions_title = DictionaryToString(dic: dic, strName: "frequent_questions_title")
        frequent_questions_address = DictionaryToString(dic: dic, strName: "frequent_questions_address")
        support_title = DictionaryToString(dic: dic, strName: "support_title")
        support_address = DictionaryToString(dic: dic, strName: "support_address")
        app_notify = DictionaryToString(dic: dic, strName: "app_notify")
        message_notify = DictionaryToString(dic: dic, strName: "message_notify")
        class_count = DictionaryToInt(dic: dic, intName: "class_count")
        service_address = DictionaryToString(dic: dic, strName: "service_address")
        policy_address = DictionaryToString(dic: dic, strName: "policy_address")
        if let class_list = dic["class_list"] as? Array<Any>{
            let array:Array = class_list
            for listTemp in array {
                let temp = SettingClassList.init(dic: listTemp as! Dictionary<String, Any>)
                settingClassList.append(temp)
            }
        }
    }
}

class SettingClassList:NSObject{
    var id:Int?
    var class_name:String?
    var flag:String?
    var mcAppConfig_id:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        flag = DictionaryToString(dic: dic, strName: "flag")
    }
}
