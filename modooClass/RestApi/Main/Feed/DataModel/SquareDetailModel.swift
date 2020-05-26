//
//  SquareDetailModel.swift
//  modooClass
//
//  Created by 조현민 on 2020/02/18.
//  Copyright © 2020 조현민. All rights reserved.
//

import Foundation

class SquareDetailModel: NSObject {
    var code:String?
    var message:String?
    var results:SquareDetailResult?

    override init() {
        super.init()
    }

    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = SquareDetailResult.init(dic: results)
        }
    }
}

class SquareDetailResult:NSObject{
    var type:String?
    var id:String?
    var user_info:SquareUserInfo?
    var like_cnt:Int?
    var scrap_cnt:Int?
    var reply_cnt:Int?
    var like_yn:String?
    var scrap_yn:String?
    var category1:String?
    var category2:String?
    var photo:SquarePhoto?
    var photo_arr:Array = Array<SquarePhoto>()
    var star:Int?
    var class_group_no:Int?
    var content:String?
    var content_reply:String?
    var created_at:String?
    var coach_id:Int?
    var coach_name:String?
    var coach_photo:String?
    var emoticon:Int?
    var play_file:String?
    var play_file_image:String?
    var youtube_file:String?
    var interest:SquareInterest?
    var interest_arr:Array = Array<SquareInterest>()
    var mcClass_id:Int?
    var class_name:String?
    var class_status:Int?
    var class_signup_data:Int?
    var class_photo:String?
    var comment_reply:SquareReply?
    var play_file_app:String?
    var time_spilled:String?
    var donation_status:String?
    var content_id:Int?
    var content_delete_yn:String?
    var delete_availability:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        
        type = DictionaryToString(dic: dic, strName: "type")
        id = DictionaryToString(dic: dic, strName: "id")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        scrap_cnt = DictionaryToInt(dic: dic, intName: "scrap_cnt")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        like_yn = DictionaryToString(dic: dic, strName: "like_yn")
        scrap_yn = DictionaryToString(dic: dic, strName: "scrap_yn")
        category1 = DictionaryToString(dic: dic, strName: "category1")
        category2 = DictionaryToString(dic: dic, strName: "category2")
        star = DictionaryToInt(dic: dic, intName: "star")
        class_group_no = DictionaryToInt(dic: dic, intName: "class_group_no")
        content = DictionaryToString(dic: dic, strName: "content")
        content_reply = DictionaryToString(dic: dic, strName: "content_reply")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        coach_id = DictionaryToInt(dic: dic, intName: "coach_id")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        play_file = DictionaryToString(dic: dic, strName: "play_file")
        play_file_image = DictionaryToString(dic: dic, strName: "play_file_image")
        youtube_file = DictionaryToString(dic: dic, strName: "youtube_file")
        mcClass_id = DictionaryToInt(dic: dic, intName: "mcClass_id")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        class_status = DictionaryToInt(dic: dic, intName: "class_status")
        class_signup_data = DictionaryToInt(dic: dic, intName: "class_signup_data")
        class_photo = DictionaryToString(dic: dic, strName: "class_photo")
        play_file_app = DictionaryToString(dic: dic, strName: "play_file_app")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
        donation_status = DictionaryToString(dic: dic, strName: "donation_status")
        content_id = DictionaryToInt(dic: dic, intName: "content_id")
        content_delete_yn = DictionaryToString(dic: dic, strName: "content_delete_yn")
        delete_availability = DictionaryToString(dic: dic, strName: "delete_availability")
        
        if let user_info = dic["user_info"] as? Dictionary<String, Any> {
            self.user_info = SquareUserInfo.init(dic: user_info)
        }
        if let list = dic["photo_app"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = SquarePhoto.init(dic: list as! Dictionary<String, Any>)
                photo_arr.append(temp)
            }
        }
        if let list = dic["interest_app"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = SquareInterest.init(dic: list as! Dictionary<String, Any>)
                interest_arr.append(temp)
            }
        }
        if let comment_reply = dic["comment_reply"] as? Dictionary<String, Any> {
            self.comment_reply = SquareReply.init(dic: comment_reply)
        }
    }
}

class SquareUserInfo:NSObject{
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var gender:String?
    var mcFriend_cnt:Int?
    var friend_status:String?
    var active_list:SquareActive_list?
    var active_list_arr:Array = Array<SquareActive_list>()
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        gender = DictionaryToString(dic: dic, strName: "gender")
        mcFriend_cnt = DictionaryToInt(dic: dic, intName: "mcFriend_cnt")
        friend_status = DictionaryToString(dic: dic, strName: "friend_status")
        if let list = dic["active_list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = SquareActive_list.init(dic: list as! Dictionary<String, Any>)
                active_list_arr.append(temp)
            }
        }
    }
}

class SquareActive_list:NSObject{
    var source:String?
    var id:Int?
    var type:String?
    var click_event:String?
    var user_id:Int?
    var content:String?
    var user_photo:String?
    var photo_url:String?
    var like_cnt:Int?
    var reply_cnt:Int?
    var interest:String?
    var play_address:String?
    var play_file_image:String?
    var youtu_address:String?
    var source_link_id:String?
    var mcLike_status:String?
    
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        source = DictionaryToString(dic: dic, strName: "source")
        id = DictionaryToInt(dic: dic, intName: "id")
        type = DictionaryToString(dic: dic, strName: "type")
        click_event = DictionaryToString(dic: dic, strName: "click_event")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        content = DictionaryToString(dic: dic, strName: "content")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        reply_cnt = DictionaryToInt(dic: dic, intName: "reply_cnt")
        interest = DictionaryToString(dic: dic, strName: "interest")
        play_address = DictionaryToString(dic: dic, strName: "play_address")
        play_file_image = DictionaryToString(dic: dic, strName: "play_file_image")
        youtu_address = DictionaryToString(dic: dic, strName: "youtu_address")
        source_link_id = DictionaryToString(dic: dic, strName: "source_link_id")
        mcLike_status = DictionaryToString(dic: dic, strName: "mcLike_status")
    }
}

class SquarePhoto:NSObject{
    var photo_url:String?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
    }
}

class SquareInterest:NSObject{
    var name:String?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        name = DictionaryToString(dic: dic, strName: "name")
    }
}

class SquareReply:NSObject{
    var page:Int?
    var reply_total:Int?
    var reply_curr_count:Int?
    var total_page:Int?
    var list:SquareReply_list?
    var list_arr:Array = Array<SquareReply_list>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        
        page = DictionaryToInt(dic: dic, intName: "page")
        reply_total = DictionaryToInt(dic: dic, intName: "reply_total")
        reply_curr_count = DictionaryToInt(dic: dic, intName: "reply_curr_count")
        total_page = DictionaryToInt(dic: dic, intName: "total_page")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for list in array {
                let temp = SquareReply_list.init(dic: list as! Dictionary<String, Any>)
                list_arr.append(temp)
            }
        }
    }
}

class SquareReply_list:NSObject{
    var id:Int?
    var user_id:Int?
    var user_name:String?
    var user_photo:String?
    var content:String?
    var emoticon:Int?
    var job_name:String?
    var like_cnt:Int?
    var like_me:String?
    var photo_url:String?
    var created_at:String?
    var comment_id:String?
    var coach_yn:String?
    var friend_yn:String?
    var time_spilled:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        
        id = DictionaryToInt(dic: dic, intName: "id")
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        content = DictionaryToString(dic: dic, strName: "content")
        emoticon = DictionaryToInt(dic: dic, intName: "emoticon")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        like_cnt = DictionaryToInt(dic: dic, intName: "like_cnt")
        like_me = DictionaryToString(dic: dic, strName: "like_me")
        photo_url = DictionaryToString(dic: dic, strName: "photo_url")
        created_at = DictionaryToString(dic: dic, strName: "created_at")
        comment_id = DictionaryToString(dic: dic, strName: "comment_id")
        coach_yn = DictionaryToString(dic: dic, strName: "coach_yn")
        friend_yn = DictionaryToString(dic: dic, strName: "friend_yn")
        time_spilled = DictionaryToString(dic: dic, strName: "time_spilled")
    }
}
