//
//  PilotModel.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/27.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class PilotModel: NSObject {
    var code:String?
    var message:String?
    var results:PilotResult?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = PilotResult.init(dic: results)
        }
    }
}

class PilotResult:NSObject{
    var user_info:User_info_pilot?
    var user_type:String?
    var user_id:Int?
    var head_title:String?
    var category:Category_pilot?
    var category_list_arr:Array = Array<Category_pilot>()
    var today_mission:Int?
    var class_review:Class_review_pilot?
    var class_review_arr:Array = Array<Class_review_pilot>()
    var class_list:Main_class_list?
    var class_list_arr:Array = Array<Main_class_list>()
    var notice:Notice_pilot?
    var management_class:Management_class_pilot?
    var management_class_arr:Array = Array<Management_class_pilot>()
    var favorites_class:Favorites_class_pilot?
    var favorites_class_arr:Array = Array<Favorites_class_pilot>()
    var chat_address:String?
    var guide_address:String?
    
    var deal_yn:String?
    var deal_image:String?
    var deal_web:String?
    var app_notice:String?
    var app_notice_date:String?
    var app_notice_link:String?
    var app_guidance_link:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        if let user_info = dic["user_info"] as? Dictionary<String, Any> {
            self.user_info = User_info_pilot.init(dic: user_info)
        }
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_type = DictionaryToString(dic: dic, strName: "user_type")
        head_title = DictionaryToString(dic: dic, strName: "head_title")
        if let category = dic["category"] as? Array<Any>{
            let array:Array = category
            for category in array {
                let temp = Category_pilot.init(dic: category as! Dictionary<String, Any>)
                category_list_arr.append(temp)
            }
        }
        today_mission = DictionaryToInt(dic: dic, intName: "today_mission")
        if let class_review = dic["class_review"] as? Array<Any>{
            let array:Array = class_review
            for class_review in array {
                let temp = Class_review_pilot.init(dic: class_review as! Dictionary<String, Any>)
                class_review_arr.append(temp)
            }
        }
        if let class_list = dic["class_list"] as? Array<Any>{
            let array:Array = class_list
            for list in array {
                let temp = Main_class_list.init(dic: list as! Dictionary<String, Any>)
                class_list_arr.append(temp)
            }
        }
        if let notice = dic["notice"] as? Dictionary<String, Any> {
            self.notice = Notice_pilot.init(dic: notice)
        }
        if let management_class = dic["management_class"] as? Array<Any>{
            let array:Array = management_class
            for management_class in array {
                let temp = Management_class_pilot.init(dic: management_class as! Dictionary<String, Any>)
                management_class_arr.append(temp)
            }
        }
        if let favorites_class = dic["favorites_class"] as? Array<Any>{
            let array:Array = favorites_class
            for favorites_class in array {
                let temp = Favorites_class_pilot.init(dic: favorites_class as! Dictionary<String, Any>)
                favorites_class_arr.append(temp)
            }
        }
        chat_address = DictionaryToString(dic: dic, strName: "chat_address")
        guide_address = DictionaryToString(dic: dic, strName: "guide_address")
        
        deal_yn = DictionaryToString(dic: dic, strName: "deal_yn")
        deal_image = DictionaryToString(dic: dic, strName: "deal_image")
        deal_web = DictionaryToString(dic: dic, strName: "deal_web")
        app_notice = DictionaryToString(dic: dic, strName: "app_notice")
        app_notice_date = DictionaryToString(dic: dic, strName: "app_notice_data")
        app_notice_link = DictionaryToString(dic: dic, strName: "app_notice_link")
        app_guidance_link = DictionaryToString(dic: dic, strName: "app_guidance_link")
    }
}

class Favorites_class_pilot:NSObject{
    var class_id:Int?
    var class_photo:String?
    var class_name:String?
    var category:String?
    var class_short_name:String?
    var curriculum_cnt:Int?
    var week_mission_cnt:Int?
    var search_link:String?
    var favorites_status:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        category = DictionaryToString(dic: dic, strName: "category")
        class_short_name = DictionaryToString(dic: dic, strName: "class_short_name")
        curriculum_cnt = DictionaryToInt(dic: dic, intName: "curriculum_cnt")
        week_mission_cnt = DictionaryToInt(dic: dic, intName: "week_mission_cnt")
        search_link = DictionaryToString(dic: dic, strName: "search_link")
        favorites_status = DictionaryToString(dic: dic, strName: "favorites_status")
    }
}

class User_info_pilot:NSObject{
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var gender:String?
    var level_info:Level_info_pilot?
    var interest_list:Pilot_Interest_list?
    var interest_list_arr:Array = Array<Pilot_Interest_list>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        gender = DictionaryToString(dic: dic, strName: "gender")
        
        if let level_info = dic["level_info"] as? Dictionary<String, Any> {
            self.level_info = Level_info_pilot.init(dic: level_info)
        }
        if let interest_list = dic["interest"] as? Array<Any>{
            let array:Array = interest_list
            for interest_list in array {
                let temp = Pilot_Interest_list.init(dic: interest_list as! Dictionary<String, Any>)
                interest_list_arr.append(temp)
            }
        }
        
    }
}

class Pilot_Interest_list:NSObject{
    var id:Int?
    var name:String?
    var mcCategory_id:Int?
    var use_yn:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        name = DictionaryToString(dic: dic, strName: "name")
        mcCategory_id = DictionaryToInt(dic: dic, intName: "mcCategory_id")
        use_yn = DictionaryToString(dic: dic, strName: "use_yn")
    }
}

class Level_info_pilot:NSObject{
    var total_point:Int?
    var level_name:String?
    var level_code:String?
    var level_score:Int?
    var level_benefits:String?
    var next_level_name:String?
    var next_level_score:Int?
    var level_per:Int?
    var level_icon:String?
    var level_information_page:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        total_point = DictionaryToInt(dic: dic, intName: "total_point")
        level_name = DictionaryToString(dic: dic, strName: "level_name")
        level_code = DictionaryToString(dic: dic, strName: "level_code")
        level_score = DictionaryToInt(dic: dic, intName: "level_score")
        level_benefits = DictionaryToString(dic: dic, strName: "level_benefits")
        next_level_name = DictionaryToString(dic: dic, strName: "next_level_name")
        next_level_score = DictionaryToInt(dic: dic, intName: "next_level_score")
        level_per = DictionaryToInt(dic: dic, intName: "level_per")
        level_icon = DictionaryToString(dic: dic, strName: "level_icon")
        level_information_page = DictionaryToString(dic: dic, strName: "level_information_page")
    }
}

class Category_pilot:NSObject{
    var id:Int?
    var name:String?
    var photo:String?
    var interest_list:Pilot_Interest_list?
    var interest_list_arr:Array = Array<Pilot_Interest_list>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        name = DictionaryToString(dic: dic, strName: "name")
        photo = DictionaryToString(dic: dic, strName: "photo")
        if let interest_list = dic["list"] as? Array<Any>{
            let array:Array = interest_list
            for interest_list in array {
                let temp = Pilot_Interest_list.init(dic: interest_list as! Dictionary<String, Any>)
                interest_list_arr.append(temp)
            }
        }
    }
}

class Class_review_pilot:NSObject {
    var class_id:Int?
    var class_name:String?
    var review_star:Int?
    var class_photo:String?
    var coach_content:String?
    var mcClassPayUser_id:Int?
    var status:String?
    var payment_address:String?
    var review_address:String?
    var search_link:String?
    var category:String?
    var review_star_status:String?
    var type:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        review_star = DictionaryToInt(dic: dic, intName: "review_star")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        coach_content = DictionaryToString(dic: dic, strName: "coach_content")
        mcClassPayUser_id = DictionaryToInt(dic: dic, intName: "mcClassPayUser_id")
        status = DictionaryToString(dic: dic, strName: "status")
        payment_address = DictionaryToString(dic: dic, strName: "payment_address")
        review_address = DictionaryToString(dic: dic, strName: "review_address")
        search_link = DictionaryToString(dic: dic, strName: "search_link")
        category = DictionaryToString(dic: dic, strName: "category")
        review_star_status = DictionaryToString(dic: dic, strName: "review_star_status")
        type = DictionaryToInt(dic: dic, intName: "type")
    }
}

class Notice_pilot:NSObject{
    var id:Int?
    var subject:String?
    var content:String?
    var admin_id:Int?
    var date:String?
    var created_at:String?
    var updated_at:String?
    var username:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        subject = DictionaryToString(dic: dic, strName: "subject")
        content = DictionaryToString(dic: dic, strName: "content")
        admin_id = DictionaryToInt(dic: dic, intName: "admin_id")
        date = DictionaryToString(dic: dic, strName: "date")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        updated_at = DictionaryToString(dic: dic, strName: "updated_at")
        username = DictionaryToString(dic: dic, strName: "username")
    }
}

class Management_class_pilot:NSObject{
    
    var id:Int?
    var status:Int?
    var class_short_name:String?
    var class_photo:String?
    var class_group_data:Int?
    var class_signup_data:Int?
    var coach_wait_cnt:Int?
    var chat_link:String?
    var chat_user_id:String?
    var manager_link:String?
    var button_text1:String?
    var button_text2:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        status = DictionaryToInt(dic: dic, intName: "status")
        class_short_name = DictionaryToString(dic: dic, strName: "class_short_name")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        class_group_data = DictionaryToInt(dic: dic, intName: "class_group_data")
        class_signup_data = DictionaryToInt(dic: dic, intName: "class_signup_data")
        coach_wait_cnt = DictionaryToInt(dic: dic, intName: "coach_wait_cnt")
        chat_link = DictionaryToString(dic: dic, strName: "chat_link")
        chat_user_id = DictionaryToString(dic: dic, strName: "chat_user_id")
        manager_link = DictionaryToString(dic: dic, strName: "manager_link")
        button_text1 = DictionaryToString(dic: dic, strName: "button_text1")
        button_text2 = DictionaryToString(dic: dic, strName: "button_text2")
    }
}
