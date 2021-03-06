//
//  ProfileNewModel.swift
//  modooClass
//
//  Created by iOS|Dev on 2020/11/12.
//  Copyright © 2020 신민수. All rights reserved.
//

import UIKit

class ProfileNewModel: NSObject {
    var code: String?
    var message:String?
    var results:ProfileNewResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic: Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ProfileNewResults.init(dic: results)
        }
    }
}

class ProfileNewResults: NSObject {
    
    var mode:String?
    var mcChat_id:Int?
    var friend_yn:String?
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var user_comment:String?
    var sns_instagram:String?
    var sns_facebook:String?
    var sns_youtube:String?
    var sns_homepage:String?
    var level_name:String?
    var level_code:String?
    var level_icon:String?
    var helpful_cnt:Int?
    var class_cnt:Int?
    var page:Int?
    var total:Int?
    var total_page:Int?
    var comment_cnt:Int?
    var class_link:String?
    var class_studio_link:String?
    var profile_link:String?
    var chat_link:String?
    var class_yn:String?
    
    var class_list:Class_New_List?
    var class_list_arr:Array = Array<Class_New_List>()
    var comment_list:Activity_List?
    var comment_list_arr:Array = Array<Activity_List>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        mode = DictionaryToString(dic: dic, strName: "mode")
        mcChat_id = DictionaryToInt(dic: dic, intName: "mcChat_id")
        friend_yn = DictionaryToString(dic: dic, strName: "friend_yn")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_comment = DictionaryToString(dic: dic, strName: "user_comment")
        sns_instagram = DictionaryToString(dic: dic, strName: "sns_instagram")
        sns_facebook = DictionaryToString(dic: dic, strName: "sns_facebook")
        sns_youtube = DictionaryToString(dic: dic, strName: "sns_youtube")
        sns_homepage = DictionaryToString(dic: dic, strName: "sns_homepage")
        level_name = DictionaryToString(dic: dic, strName: "level_name")
        level_code = DictionaryToString(dic: dic, strName: "level_code")
        level_icon = DictionaryToString(dic: dic, strName: "level_icon")
        helpful_cnt = DictionaryToInt(dic: dic, intName: "helpful_cnt")
        class_cnt = DictionaryToInt(dic: dic, intName: "class_cnt")
        page = DictionaryToInt(dic: dic, intName: "page")
        total = DictionaryToInt(dic: dic, intName: "total")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        comment_cnt = DictionaryToInt(dic: dic, intName: "comment_cnt")
        class_link = DictionaryToString(dic: dic, strName: "class_link")
        class_studio_link = DictionaryToString(dic: dic, strName: "class_studio_link")
        profile_link = DictionaryToString(dic: dic, strName: "profile_link")
        chat_link = DictionaryToString(dic: dic, strName: "chat_link")
        class_yn = DictionaryToString(dic: dic, strName: "class_yn")
        
        if let list = dic["class_list"] as? Array<Any> {
            let array:Array = list
            for listTemp in array {
                let temp = Class_New_List.init(dic: listTemp as! Dictionary<String,Any>)
                class_list_arr.append(temp)
            }
        }
        if let list = dic["comment_list"] as? Array<Any> {
            let array:Array = list
            for listTemp in array {
                let temp = Activity_List.init(dic: listTemp as! Dictionary<String,Any>)
                comment_list_arr.append(temp)
            }
        }

    }
    
    
    
}

class Class_New_List: NSObject {
    var _id:String?
    var class_id:Int?
    var class_name:String?
    var class_photo:String?
    var status:Int?
    var helpful_cnt:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String,Any>) {
        self.init()
        _id = DictionaryToString(dic: dic, strName: "_id")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        status = DictionaryToInt(dic: dic, intName: "status")
        helpful_cnt = DictionaryToInt(dic: dic, intName: "helpful_cnt")
    }
}

class Activity_List: NSObject {
    var id:String?
    var class_id:Int?
    var curriculum_id:Int?
    var created_at:String?
    var content:String?
    var delete_yn:String?
    var emoticon:Int?
    var mission_yn:String?
    var photo_data:String?
    var reply_cnt:Int?
    var like_cnt:Int?
    var play_status:String?
    var class_name:String?
    var class_photo:String?
    var status:Int?
    var curriculum_no:Int?
    var curriculum_title:String?
    var new_flag:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String,Any>) {
        self.init()
        id = DictionaryToString(dic: dic, strName: "id")
        class_id = DictionaryToInt(dic: dic, intName: "class_id")
        curriculum_id = DictionaryToInt(dic: dic, intName: "curriculum_id")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        content = DictionaryToString(dic: dic, strName: "content")
        delete_yn = DictionaryToString(dic: dic, strName: "delete_yn")
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        mission_yn = DictionaryToString(dic: dic, strName: "mission_yn")
        photo_data = DictionaryToString(dic: dic, strName: "photo_data")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        play_status = DictionaryToString(dic: dic, strName: "play_status")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        status = DictionaryToInt(dic: dic, intName: "status")
        curriculum_no = DictionaryToInt(dic: dic, intName: "curriculum_no")
        curriculum_title = DictionaryToString(dic: dic, strName: "curriculum_title")
        new_flag = DictionaryToString(dic: dic, strName: "new_flag")
    }
}
