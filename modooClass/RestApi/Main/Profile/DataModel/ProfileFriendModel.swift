//
//  ProfileFriendModel.swift
//  modooClass
//
//  Created by 조현민 on 24/06/2019.
//  Copyright © 2019 조현민. All rights reserved.
//

import UIKit

class ProfileFriendModel: NSObject {
    var code:String?
    var message:String?
    var results:ProfileFriendResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ProfileFriendResults.init(dic: results)
        }
    }
}

class ProfileFriendResults:NSObject{
    
    var user_id:Int?
    var point:Int?
    var user_name:String?
    var user_photo:String?
    var grade_name:String?
    var coachInfo:String?
    var following_address:String?
    var following_count:Int?
    var follower_address:String?
    var follower_count:Int?
    var manage_class:Friend_Class?
    var attend_class:Friend_Class?
    var prehave_class:Friend_Class?
    var notify_class:Friend_Class?
    var profile_edit_link:String?
    var point_link:String?
    var payment_link:String?
    var friend_state:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        point = DictionaryToInt(dic: dic, intName: "point")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        grade_name = DictionaryToString(dic: dic, strName: "grade_name")
        coachInfo = DictionaryToString(dic: dic, strName: "coachInfo")
        following_count = DictionaryToInt(dic: dic, intName: "following_count")
        following_address = DictionaryToString(dic: dic, strName: "following_address")
        follower_count = DictionaryToInt(dic: dic, intName: "follower_count")
        follower_address = DictionaryToString(dic: dic, strName: "follower_address")
        profile_edit_link = DictionaryToString(dic: dic, strName: "profile_edit_link")
        point_link = DictionaryToString(dic: dic, strName: "point_link")
        payment_link = DictionaryToString(dic: dic, strName: "payment_link")
        friend_state = DictionaryToString(dic: dic, strName: "friend_state")
        if let manage_class = dic["manage_class"] as? Dictionary<String, Any> {
            self.manage_class = Friend_Class.init(dic: manage_class)
        }
        if let attend_class = dic["attend_class"] as? Dictionary<String, Any> {
            self.attend_class = Friend_Class.init(dic: attend_class)
        }
        if let notify_class = dic["notify_class"] as? Dictionary<String, Any> {
            self.notify_class = Friend_Class.init(dic: notify_class)
        }
        if let prehave_class = dic["prehave_class"] as? Dictionary<String, Any> {
            self.prehave_class = Friend_Class.init(dic: prehave_class)
        }
    }
}

class Friend_Class:NSObject{
    var title:String?
    var list:Friend_Class_List?
    var class_list:Array = Array<Friend_Class_List>()
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        title = DictionaryToString(dic: dic, strName: "title")
        if let list = dic["list"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = Friend_Class_List.init(dic: listTemp as! Dictionary<String, Any>)
                class_list.append(temp)
            }
        }
        
    }
}

class Friend_Class_List:NSObject{
    var id:Int?
    var type:String?
    var video:String?
    var photo:String?
    var class_name:String?
    var category1:String?
    var category2:String?
    var point_text:String?
    var refund_text:String?
    var stamp_text:String?
    var start_day:String?
    var review_count:Int?
    var review_avg:String?
    var prehave:String?
    var list_type:Int?
    var user_photo:String?
    var user_comment:String?
    var coach_photo:String?
    var coach_name:String?
    var total_count:Int?
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        id = DictionaryToInt(dic: dic, intName: "id")
        type = DictionaryToString(dic: dic, strName: "type")
        video = DictionaryToString(dic: dic, strName: "video")
        photo = DictionaryToString(dic: dic, strName: "photo")
        class_name = DictionaryToString(dic: dic, strName: "class_name")
        category1 = DictionaryToString(dic: dic, strName: "category1")
        category2 = DictionaryToString(dic: dic, strName: "category2")
        point_text = DictionaryToString(dic: dic, strName: "point_text")
        refund_text = DictionaryToString(dic: dic, strName: "refund_text")
        stamp_text = DictionaryToString(dic: dic, strName: "stamp_text")
        start_day = DictionaryToString(dic: dic, strName: "start_day")
        review_count = DictionaryToInt(dic: dic, intName: "review_count")
        review_avg = DictionaryToString(dic: dic, strName: "review_avg")
        if review_avg == ""{review_avg = "0.0"}
        prehave = DictionaryToString(dic: dic, strName: "prehave")
        list_type = DictionaryToInt(dic: dic, intName: "list_type")
        user_photo = DictionaryToString(dic: dic, strName: "user_photo")
        user_comment = DictionaryToString(dic: dic, strName: "user_comment")
        coach_name = DictionaryToString(dic: dic, strName: "coach_name")
        coach_photo = DictionaryToString(dic: dic, strName: "coach_photo")
        total_count = DictionaryToInt(dic: dic, intName: "total_count")
    }
}

class ProfileFriendInfoModel: NSObject {
    var code:String?
    var message:String?
    var results:ProfileFriendInfoResults?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        code = DictionaryToString(dic: dic, strName: "code")
        message = DictionaryToString(dic: dic, strName: "message")
        if let results = dic["results"] as? Dictionary<String, Any> {
            self.results = ProfileFriendInfoResults.init(dic: results)
        }
    }
}

class ProfileFriendInfoResults:NSObject{
    
    var user_id:Int?
    var condition_status:String?
    var user_name:String?
    var birthday_year:Int?
    var gender:String?
    var photo:String?
    var job_name:String?
    var interest:Array<String> = Array<String>()
//    var friend
    var friend:FriendInfo_List?
    var friend_arr:Array = Array<FriendInfo_List>()
    var friend_count:Int?
    var friend_address:String?
    var profile_comment:String?
    var chat_address:String?
    var mcFriend_id:Int?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        condition_status = DictionaryToString(dic: dic, strName: "condition_status")
        user_name = DictionaryToString(dic: dic, strName: "user_name")
        birthday_year = DictionaryToInt(dic: dic, intName: "birthday_year")
        gender = DictionaryToString(dic: dic, strName: "gender")
        photo = DictionaryToString(dic: dic, strName: "photo")
        job_name = DictionaryToString(dic: dic, strName: "job_name")
        friend_count = DictionaryToInt(dic: dic, intName: "friend_count")
        friend_address = DictionaryToString(dic: dic, strName: "friend_address")
        profile_comment = DictionaryToString(dic: dic, strName: "profile_comment")
        chat_address = DictionaryToString(dic: dic, strName: "chat_address")
        mcFriend_id = DictionaryToInt(dic: dic, intName: "mcFriend_id")
        if let list = dic["interest"] as? Array<String>{
            let array:Array = list
            print(array)
            for listTemp in array {
                print(listTemp)
                interest.append(listTemp)
            }
        }
        if let list = dic["friend"] as? Array<Any>{
            let array:Array = list
            for listTemp in array {
                let temp = FriendInfo_List.init(dic: listTemp as! Dictionary<String, Any>)
                friend_arr.append(temp)
            }
        }
    }
}

class FriendInfo_List:NSObject{
    
    var user_id:Int?
    var photo:String?
    
    override init() {
        super.init()
    }
    
    convenience init(dic:Dictionary<String, Any>) {
        self.init()
        user_id = DictionaryToInt(dic: dic, intName: "user_id")
        photo = DictionaryToString(dic: dic, strName: "photo")
    }
}
